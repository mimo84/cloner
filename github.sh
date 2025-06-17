#!/bin/bash

scriptpath="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

if [ -z "$1" ]; then
    echo "You need to specify the full path to where you want to clone your repos."
    exit 1
else
    clone_path=$1
    echo "Path for cloning is set to $clone_path."
fi

list_location="$scriptpath/list.txt"
echo '' > "$list_location"
for org in $(gh org list)
do
    gh repo list "$org" --limit 1000 --source --json sshUrl -q '.[].sshUrl' >> list.txt
done

gh repo list --limit 1000 --source --json sshUrl -q '.[].sshUrl' >> list.txt
 
mkdir -p "$clone_path"

pushd "$clone_path" || { echo "Error: Could not change directory to $clone_path"; exit 1; }

echo "There are currently $(wc -l "$list_location" | awk '{print $1}') repos ready to be clone."
echo "If you don't want to clone all of them, you can edit the file under $list_location and then confirm continue."
read -p "Press Y when you're ready to continue or any other key to abort." -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1
fi


while read -r repo; do
    echo "cloning: $repo under $clone_path"
    sh "${scriptpath}/cloner.sh" "$repo" "$clone_path"
done < "$list_location"


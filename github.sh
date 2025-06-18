#!/usr/bin/env bash

scriptpath="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

if [ -z "$1" ]; then
    echo "You need to specify the full path to where you want to clone your repos."
    exit 1
else
    destination_path=$1
    echo "Path for cloning is set to $destination_path."
fi

repos_list_file="$scriptpath/list.txt"

read -p "Do you want to fetch a new list of repositories? (Y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    # If yes, clear the list and fetch new repositories
    echo "Fetching new repository list..."
    echo '' > "$repos_list_file"

    if gh org list; then
        echo "Fetching repos in organizations..."
        for org in $(gh org list); do
            gh repo list "$org" --limit 1000 --source --json sshUrl -q '.[].sshUrl' >> "$repos_list_file"
        done
    fi

    # Fetch personal repositories as well
    gh repo list --limit 1000 --source --json sshUrl -q '.[].sshUrl' >> "$repos_list_file"
else
    # If no, just print a message and use the existing list
    echo "Using the existing repository list from $repos_list_file"
fi

repo_count=$(wc -l < "$repos_list_file")
if [ "$repo_count" -eq 0 ]; then
    echo "No repositories found in $repos_list_file"
    exit 1
fi

if ! mkdir -p "$destination_path"; then
    echo "Error: Could not create the directory $destination_path."
    exit 1
fi

pushd "$destination_path" || { echo "Error: Could not change directory to $destination_path"; exit 1; }

echo "There are currently $repo_count repos ready to be cloned."
echo "If you don't want to clone all of them, you can edit the file under $repos_list_file and then confirm continue."

read -p "Press Y when you're ready to continue or any other key to abort: " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Aborting the cloning process."
    exit 1
fi

while read -r repo; do
    echo "Cloning: $repo under $destination_path"
    sh "${scriptpath}/cloner.sh" "$repo" "$destination_path"
done < "$repos_list_file"

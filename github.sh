#!/bin/bash

if [ -z "$1" ]; then
    echo "Please insert your username as argument"
    exit 1
else
    NAME=$1
fi

SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")

CNTX=users
PAGE=1

cd ..
mkdir -p github_repos
cd github_repos
current_directory=`pwd`

(
curl "https://api.github.com/$CNTX/$NAME/repos?page=$PAGE&per_page=100" |
grep -e 'ssh_url*' |
cut -d \" -f 4 > gitlist.txt

for repo in `cat gitlist.txt`
do
  echo "Cloning ${repo} under ${current_directory}"
  sh "${SCRIPTPATH}/cloner.sh" $repo $current_directory
done
)
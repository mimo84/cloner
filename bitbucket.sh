#!/bin/bash

if [ -z "$1" ]; then
    echo "Need to insert username and password in this format: `username:password`"
    exit 1
else
    user=$1
fi

SCRIPTPATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# do all the cloning level above from current directory
cd ..
cloningFolder=bitbucket_repos
mkdir -p "${cloningFolder}"
cd "${cloningFolder}"
rm personalrepos.txt
for role in owner member contributor admin
do
  curl -u $user "https://api.bitbucket.org/2.0/repositories?pagelen=100&role=${role}" > "${role}.json"
  jq -r '.values[] | .links.clone[1].href' "${role}.json" >> personalrepos.txt
  rm "${role}.json"
done

# remove duplicates
awk '!a[$0]++' personalrepos.txt > gitlist.txt

current_directory=`pwd`

(
for repo in `cat gitlist.txt`
do
  echo "Cloning ${repo} under ${current_directory} - SCRIPT: ${SCRIPTPATH}"
  sh "${SCRIPTPATH}/cloner.sh" $repo $current_directory
done
)

echo -e '\033[1;32m' "Done!" '\033[0m'

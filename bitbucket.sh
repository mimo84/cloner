#!/bin/bash

if [ -z "$1" ]; then
    echo "Need to insert username and password in this format: `username:passoword`"
    exit 1
else
    user=$1
fi
# one level above from current directory
cd ..
cloningFolder=bitbucket_repos
rm -rf "${cloningFolder}"
mkdir "${cloningFolder}"
cd "${cloningFolder}"

for role in owner member contributor admin
do
  curl -u $user "https://api.bitbucket.org/2.0/repositories?pagelen=100&role=${role}" > "${role}.json"
  jq -r '.values[] | .links.clone[1].href' "${role}.json" > personalrepos.txt
  rm "${role}.json"
done

for repo in `cat personalrepos.txt`
do
  # Gets the user/project/team/etc of the repo to put it in a separate folder
  folder=`echo $repo | cut -d':' -f2 | cut -d'/' -f1`
  mkdir -p "${folder}"
  cd "${folder}"
  echo "Cloning" $repo
  git clone $repo
  cd ..
done
rm personalrepos.txt
cd ..

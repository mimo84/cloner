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

for repo in `cat gitlist.txt`
do
  # Gets the user/project/team/etc of the repo to put it in a separate folder
  project_folder=`echo $repo | cut -d':' -f2 | cut -d'/' -f1`
  mkdir -p "${project_folder}"
  cd "${project_folder}"

  # If the repo exists then simply perform a git pull to update the project.
  # Assumes that changes have been already committed / pushed to the remote
  repo_folder_git=`echo $repo | cut -d'/' -f2`
  repo_folder=`echo ${repo_folder_git%.git}`
  if [ -d "${repo_folder}" ]
  then
    # echo "YES ${repo_folder} does exist"
      cd "${repo_folder}"
      echo -e '\033[1;32m' "Updating repo ${repo}" '\033[0m'
      git pull
      cd ..
  else
    echo -e '\033[1;33m' "Cloning repo ${repo}" '\033[0m'
    git clone $repo
  fi
  cd ..
done
rm personalrepos.txt
cd ..

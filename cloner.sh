#!/bin/bash

if [ -z "$1" ]; then
    echo "Need to have the repo name to clone and the directory"
    exit 1
else
    repo=$1
fi

if [ -z "$2" ]; then
    echo "Need to specify the full path of the directory"
    exit 1
else
    current_directory=$2
fi


# Gets the user/project/team/etc of the repo to put it in a separate folder (works only for BitBucket)
project_folder=`echo $repo | cut -d':' -f2 | cut -d'/' -f1`
mkdir -p "${current_directory}/${project_folder}"
cd "${current_directory}/${project_folder}"

# If the repo exists then simply perform a git pull to update the project.
# Assumes that changes have been already committed / pushed to the remote
repo_folder_git=`echo $repo | cut -d'/' -f2`

repo_folder=`echo ${repo_folder_git%.git}`
if [ -d "${repo_folder}" ]
then
  (
    cd "${repo_folder}"
    echo -e '\033[1;32m' "Updating repo ${repo}" '\033[0m'
    git pull
  )
else
  echo -e '\033[1;33m' "Cloning repo ${repo}" '\033[0m'
  git clone $repo
fi

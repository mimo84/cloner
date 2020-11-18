#!/bin/bash

if [ -z "$1" ]; then
    echo "Please insert your username as argument"
    exit 1
else
    NAME=$1
fi

# Context can be users or orgs.
# I am only interested in public user repositories at the moment
# and in particular only mine.
# CNTX={users|orgs};
CNTX=users
PAGE=1
curl "https://api.github.com/$CNTX/$NAME/repos?page=$PAGE&per_page=100" |
  grep -e 'git_url*' |
  cut -d \" -f 4 |
  xargs -L1 git clone
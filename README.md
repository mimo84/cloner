# Bitbucket / Github Cloner

A simple script to download repos from bitbucket (mostly) and github.

## bitbucket.sh

jq is a dependency: https://stedolan.github.io/jq/

### usage:

```
bitbucket.sh username:password
```

### result:

it will create a bitbuckt_repos folder above the script itself and a number of subfolders
depending on your own bitbucket structure.
Inside each folder your repos are going to be cloned.

Inspired by this: https://stackoverflow.com/questions/40429610/bitbucket-clone-all-team-repositories

## github.sh

### usage:

```
github.sh username
```

### result:

it will create a github_repos above the script itself and clone all the public repos of that user.

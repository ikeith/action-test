#!/bin/bash

# utility function to convert a string into an integer. results in 0 for invalid strings
int(){ printf '%d' ${1:-} 2>/dev/null || :; }
# utility function to send output to stderr
yell() { echo "$1" >&2; }

# get the most recent tag in the repo
lastTag=$(git describe --tags $(git rev-list --tags --max-count=1))
# extract just the number from the tag
lastTagVersion=$(echo $lastTag | sed -nE 's/^v([0-9]+)$/\1/p')
# convert it into an integer
prevVersion=$(int $lastTagVersion)
# get the current version, converted to an integer
curVersion=$(int $(< version.txt))

# sanity check the numbers we got
if [[ prevVersion -le 0 ]]; then
	yell "unable to get valid version from tag"
	exit 1
fi
if [[ curVersion -le 0 ]]; then
	yell "unable to get valid version from file"
	exit 1
fi

# add a new tag if needed
if [[ curVersion -gt prevVersion ]]; then
    echo "v$curVersion"
	#echo "updating $prevVersion -> $curVersion"
	#git tag -a "v$curVersion" -m "Version $curVersion"
	#git push origin "v$curVersion"
fi

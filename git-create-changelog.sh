#!/bin/bash
# create changelog based on commit messages
# one section for each tag

# currently all options are hardcoded

if test -d ".git"; then
	# yes we are in a git repository

	# clear old changelog
	echo "# Changelog" > Changelog
	echo "" >> Changelog
	
	#find first commit
	FIRST_COMMIT=$(git log --pretty=format:'%H'|tail -1)

	#substract tags from repository
	TAGS_STR=$(git tag -l)
	TAGS=(${TAGS_STR// / })
	LAST=$FIRST_COMMIT

	for i in "${TAGS[@]}"; do
		# for each commit
		echo "" >> Changelog
		echo "## $i" >> Changelog
		echo "" >> Changelog
		git log $LAST...$i --pretty=format:' - %h %s (%an <%ae>)' --reverse | grep -v 'Merge branch' >> Changelog
		LAST=$i
	done
else
	echo "No git repository present"
	exit 1
fi
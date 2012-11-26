#!/bin/bash
# create changelog based on commit messages
# one section for each tag

if test -d ".git"; then

	echo "# Changelog" > Changelog
	echo "" >> Changelog
	FIRST_COMMIT=$(git log --pretty=format:'%H'|tail -1)
	#echo $FIRST_COMMIT
	TAGS_STR=$(git tag -l)
	TAGS=(${TAGS_STR// / })
	LAST=$FIRST_COMMIT
	for i in "${TAGS[@]}"; do
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
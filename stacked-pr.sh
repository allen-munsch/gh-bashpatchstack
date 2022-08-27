#! /bin/bash

echo "#########"
echo base $1 
echo head $2
echo "########"
echo

git --no-pager show-ref --heads | grep "$1" >| stacked
git --no-pager show-ref --heads | grep "$2" >> stacked

echo '#########   stack   ########'
cat stacked
echo '############################'
echo >| stacked.dry_run

prev_hash=
prev_branch=

echo
echo '###### dry run #######'
while read -r LINE;
do
	if [ -z "${prev_hash}" ]
	then
		echo setting prev_hash
		prev_hash="$(echo $LINE | awk '{ print $1 }')"
		prev_branch="$(echo $LINE | awk '{ print $2 }')"
        else
		next_hash="$(echo $LINE | awk '{ print $1 }')"
		next_branch="$(echo $LINE | awk '{ print $2 }')"
		echo gh pr create \
		--title "prev: $prev_branch next: $next_branch" \
		--draft \
		--head "$prev_hash" \
		--base "$next_hash" | tee -a stacked.dry_run
		prev_hash="$next_hash"
		prev_branch="$next_branch"
	fi
done < stacked
echo '#################'

cp stacked.dry_run stacked.run
chmod +x stacked.run

echo "If you're okay with this then do:"
echo "    bash ./stacked.run"

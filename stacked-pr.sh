#! /bin/bash


CLEAR='\033[0m'
RED='\033[0;31m'

function usage() {
  echo -e "${RED}Usage:${CLEAR} [-B --base] [-H --head] [-h --help]"
  echo "  -B, --base               base branch to merge into"
  echo "  -H, --head           head the working branch with code changes"
  echo "  -h, --help               print this help"
  echo ""
  echo "Example: $0 --base main --head jm/stacked/integrations"
  exit 1
}

POSITIONAL_ARGS=()

while [[ $# -gt 0 ]]; do
  case $1 in
     -B|--base)
       BASE="$2"
       shift # arg
       shift # val
       ;;
     -H|--head)
       HEAD="$2"
       shift # arg
       shift # val
       ;;
     -h|--help)
       usage
       exit 0
       ;;
     -*|--*)
       echo "Unknown option $1"
       usage
       exit 1
       ;;
     *)
       POSITIONAL_ARGS+=("$1") # save positional arg
       shift # past argument
       ;;
  esac
done

set -- "${POSITIONAL_ARGS[@]}" # restore positional parameters

if [ -z "$BASE" ];then
	usage
	exit 1
fi
if [ -z "$HEAD" ];then
	usage
	exit 1
fi

echo "#########"
echo base $BASE
echo head $HEAD
echo "########"
echo


git --no-pager show-ref --heads | grep "$BASE" >| stacked
git --no-pager show-ref --heads | grep "$HEAD" >> stacked

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
		git push origin "$prev_branch"
        else
		next_hash="$(echo $LINE | awk '{ print $1 }')"
		next_branch="$(echo $LINE | awk '{ print $2 }')"
		tee -a stacked.dry_run <<EOF
gh pr create \
--title "prev: $prev_branch next: $next_branch" \
--draft \
--base "$prev_branch" \
--head "$next_branch"

EOF
		prev_hash="$next_hash"
		prev_branch="$next_branch"

	fi
done < stacked
echo '#################'

cp stacked.dry_run stacked.run
chmod +x stacked.run

echo "If you're okay with this then do:"
echo "    bash ./stacked.run"

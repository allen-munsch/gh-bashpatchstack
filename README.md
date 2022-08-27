# gh-bashpatchstack
super simple git patch stack using bash and gh cli to open a patch stack on github

### install dependency gh cli

```
sudo apt install gh
gh auth login

# loading spinner icon *elevator music*
```

### rough the script into your environment

```
git clone https://github.com/allen-munsch/gh-bashpatchstack.git
cd gh-bashpatchstack
chmod +x stacked-pr.sh
echo alias gh-bps="$(pwd)/stacked-pr.sh" >> ~/.bashrc  # or equivalent
source ~/.bashrc
cd -
```

### to the project git repo 

```
04:30:49 (venv_3_9_10) jm@pop-os clowntown ±|jm/stacked/integrations/3 ✗|→ gh-bps AA-2054-feature-branch-1 jm/stacked/integrations
#########
base AA-2054-feature-branch-1
head jm/stacked/integrations
########

#########   stack   ########
5063cb25cabd00a45217705430bfda127f419444 refs/heads/AA-2054-feature-branch-1
f0ab778d97b36b3506654873114cfc4e91027cd5 refs/heads/jm/stacked/integrations/1
e21e8633b1d5f5d0707e8b6f4c69c79055d66459 refs/heads/jm/stacked/integrations/2
d72462fa0fdcd403eb83ecd4a0b5fd1ac0742140 refs/heads/jm/stacked/integrations/3
############################

###### dry run #######
setting prev_hash
gh pr create --title "prev: refs/heads/AA-2054-feature-branch-1 next: refs/heads/jm/stacked/integrations/1" --draft --head "5063cb25cabd00a45217705430bfda127f419444 --base f0ab778d97b36b3506654873114cfc4e91027cd5
gh pr create --title prev: refs/heads/jm/stacked/integrations/1 next: refs/heads/jm/stacked/integrations/2 --draft --head f0ab778d97b36b3506654873114cfc4e91027cd5 --base e21e8633b1d5f5d0707e8b6f4c69c79055d66459
gh pr create --title prev: refs/heads/jm/stacked/integrations/2 next: refs/heads/jm/stacked/integrations/3 --draft --head e21e8633b1d5f5d0707e8b6f4c69c79055d66459 --base d72462fa0fdcd403eb83ecd4a0b5fd1ac0742140
#################
If you're okay with this then do:
    bash ./stacked.run
```

Example running the first one will establish the start of the stack, each following PR created points to the previous as its base:

```
gh pr create --title "prev: refs/heads/AA-2054-feature-branch-1 next: refs/heads/jm/stacked/integrations/1" --draft \
--head "5063cb25cabd00a45217705430bfda127f419444" \
--base "f0ab778d97b36b3506654873114cfc4e91027cd5"

Warning: 5 uncommitted changes

Creating draft pull request for 5063cb25cabd00a45217705430bfda127f419444 into f0ab778d97b36b3506654873114cfc4e91027cd5 in Clown-Town/clowntown

? Choose a template  [Use arrows to move, type to filter]
> pull_request_template.md
  Open a blank pull request

```

# docs

- https://cli.github.com/manual/gh_pr_create
- https://git-scm.com/docs/git-show-ref


# why

Because github doesn't do this well

Also, but why?

- https://jg.gg/2018/09/29/stacked-diffs-versus-pull-requests/


# TODO

- push changes to stack start, mid stack, etc, and sync changes
    - given an $UPDATED_COMMIT and known stacked.dry_run
    - cat rest_of_stack | xargs -INEXT_PR git checkout $NEXT_PR && git pull origin $UPDATED_COMMMIT  # default pull.rebase=false 
    - 
    - or pull.rebase=true

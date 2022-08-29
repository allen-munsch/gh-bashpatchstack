# gh-bashpatchstack
super simple git patch stack using bash and gh cli to open a patch stack on github

![2022-08-27_18-19](https://user-images.githubusercontent.com/33908344/187051223-017b78cc-c35f-485a-964f-67fc6a920402.png)


### install dependency gh cli

```
# https://github.com/cli/cli/blob/trunk/docs/install_linux.md

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
04:30:49 (venv_3_9_10) jm@pop-os clowntown ±|jm/stacked/integrations/3 ✗|→ gh-bps -B AA-2054-feature-branch-1  -H jm/stacked/integrations
#########
base AA-2054-feature-branch-1
head jm/stacked/integrations
########

#########   stack   ########
5063cb25cabd00a45217705430bfda127f419444 refs/heads/AA-2054-feature-branch-1
f0ab778d97b36b3506654873114cfc4e91027cd5 refs/heads/jm/stacked/integrations/1
f7d687eb8e48d0286dca55c23bc16cf2d6393699 refs/heads/jm/stacked/integrations/2
12ecf8e456f3d33c225ae7c513c94845c434113b refs/heads/jm/stacked/integrations/3
############################

###### dry run #######
setting prev_hash
gh pr create 
 --title "prev: refs/heads/AA-2054-feature-branch-1 next: refs/heads/jm/stacked/integrations/1" 
 --draft 
 --base "refs/heads/AA-2054-feature-branch-1" 
 --head "refs/heads/jm/stacked/integrations/1"
gh pr create 
 --title "prev: refs/heads/jm/stacked/integrations/1 next: refs/heads/jm/stacked/integrations/2" 
 --draft 
 --base "refs/heads/jm/stacked/integrations/1" 
 --head "refs/heads/jm/stacked/integrations/2"
gh pr create 
 --title "prev: refs/heads/jm/stacked/integrations/2 next: refs/heads/jm/stacked/integrations/3" 
 --draft 
 --base "refs/heads/jm/stacked/integrations/2" 
 --head "refs/heads/jm/stacked/integrations/3"
#################
If you're okay with this then do:
    bash ./stacked.run
```

Example running the first one will establish the start of the stack, each following PR created points to the previous as its base:

```
gh pr create --title "prev: refs/heads/AA-2054-feature-branch-1 next: refs/heads/jm/stacked/integrations/1" --draft \
--base "refs/heads/AA-2054-feature-branch-1" \
--head "refs/heads/jm/stacked/integrations/1"

Warning: 5 uncommitted changes

Creating draft pull request for 5063cb25cabd00a45217705430bfda127f419444 into f0ab778d97b36b3506654873114cfc4e91027cd5 in Clown-Town/clowntown

? Choose a template  [Use arrows to move, type to filter]
> pull_request_template.md
  Open a blank pull request

```

#### other example stacking onto main instead of a feature branch

```
gh-bps -B main -H jm/stacked/integrations

#########
base main
head jm/stacked/integrations
########

#########   stack   ########
5063cb25cabd00a45217705430bfda127f419444 refs/heads/main
f0ab778d97b36b3506654873114cfc4e91027cd5 refs/heads/jm/stacked/integrations/1
f7d687eb8e48d0286dca55c23bc16cf2d6393699 refs/heads/jm/stacked/integrations/2
12ecf8e456f3d33c225ae7c513c94845c434113b refs/heads/jm/stacked/integrations/3
############################

###### dry run #######
setting prev_hash
gh pr create 
 --title "prev: refs/heads/main next: refs/heads/jm/stacked/integrations/1" 
 --draft 
 --base "refs/heads/main" 
 --head "refs/heads/jm/stacked/integrations/1"
gh pr create 
 --title "prev: refs/heads/jm/stacked/integrations/1 next: refs/heads/jm/stacked/integrations/2" 
 --draft 
 --base "refs/heads/jm/stacked/integrations/1" 
 --head "refs/heads/jm/stacked/integrations/2"
gh pr create 
 --title "prev: refs/heads/jm/stacked/integrations/2 next: refs/heads/jm/stacked/integrations/3" 
 --draft 
 --base "refs/heads/jm/stacked/integrations/2" 
 --head "refs/heads/jm/stacked/integrations/3"
#################
If you're okay with this then do:
    bash ./stacked.run
```

# Debugging

```
DEBUG=api ./stacked.run
```

# docs

- https://cli.github.com/manual/gh_pr_create
- https://git-scm.com/docs/git-for-each-ref


# why

Because github doesn't do this well?

PRs are too big sometimes ( * cough * definitely not my PRs ) ... and, welp, reviewing big PRs is hard, well hard for me anyways.

Also, but why?

- https://jg.gg/2018/09/29/stacked-diffs-versus-pull-requests/



# TODO

- push changes to stack start, mid stack, etc, and sync changes
    - given an $UPDATED_COMMIT and known stacked.dry_run
    - cat rest_of_stack | xargs -INEXT_PR git checkout $NEXT_PR && git pull origin $UPDATED_COMMMIT  # default pull.rebase=false 
    - 
    - or pull.rebase=true

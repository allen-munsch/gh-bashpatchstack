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

- This in conjuction with: https://github.com/arxanas/git-branchless ?
- push changes to stack start, mid stack, etc, and sync changes
    - given an $UPDATED_COMMIT and known stacked.dry_run
    - cat rest_of_stack | xargs -INEXT_PR git checkout $NEXT_PR && git pull origin $UPDATED_COMMMIT  # default pull.rebase=false 
    - 
    - or pull.rebase=true
- helper functions for upstack, downstack code changes
  - git --no-pager diff --name-only $UPSTACK_OR_DOWNSTACK_BRANCH | xargs -I{} git checkout $UPSTACK_OR_DOWNSTACK_BRANCH -- {}
- helper functions to pull changes up, or down the stack from remote, or origin
- template editing, etc
- setting up `CODEOWNERS` for automatic reviewer tagging
  - https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/about-code-owners
  


### example helpers to implement

```
 3797  2022-08-05 18:27:36 git --no-pager diff --name-only | xargs -I{} git checkout main -- {}
 3798  2022-08-05 18:27:47 git --no-pager diff --name-only | xargs -I{} git checkout main -- {}
 3804  2022-08-05 18:29:48 git --no-pager diff main --name-only | grep png | xargs -I{} git checkout main -- {}
 4051  2022-08-19 08:48:15 git --no-pager status | awk '{ print $1 }' | xargs -I{} git checkout main -- {}
 4054  2022-08-19 08:48:57 git --no-pager status | awk '{ print $1 }' | xargs -I{} rm -- {}
 4366  2022-08-29 12:44:13 tac okay | xargs -I{} bash -c 'git checkout {} && git pull origin AA-2054-feature-branch-1 && git push origin {}'
 4388  2022-08-29 15:32:20 cat ok | jq ".url" | xargs -I{} echo gh pr edit {} -F edit.tmpl
 4391  2022-08-29 15:33:34 cat ok | jq ".url" | xargs -I{} echo gh pr ready {}
 4393  2022-08-29 15:34:18 cat ok | jq ".url" | xargs -I{} echo gh pr edit {} --add-reviewer xyz
 4366  2022-08-29 12:44:13 tac okay | xargs -I{} bash -c 'git checkout {} && git pull origin AA-2054-feature-branch-1 && git push origin {}'
 4358  2022-08-29 10:35:24 cat okay | xargs -I{} bash -c 'git checkout {} && git pull origin AA-2054-feature-branch-1 && git push origin {}'
 4359  2022-08-29 10:35:41 nano okay
 4365  2022-08-29 12:44:03 tac okay
 4366  2022-08-29 12:44:13 tac okay | xargs -I{} bash -c 'git checkout {} && git pull origin AA-2054-feature-branch-1 && git push origin {}'
 4384  2022-08-29 15:29:14 echo >| ok ; gh pr list -d --json id,url,title -q '.[]|select(.title | contains("prev: refs/heads/jm/stack"))' | tee -a ok
 4385  2022-08-29 15:29:31 echo >| ok ; gh pr list -d --json id,url,title -q '.[]|select(.title | contains("jm/stack"))' | tee -a ok
 4386  2022-08-29 15:29:49 echo >| ok ; gh pr list --json id,url,title -q '.[]|select(.title | contains("jm/stack"))' | tee -a ok
 4388  2022-08-29 15:32:20 cat ok | jq ".url" | xargs -I{} echo gh pr edit {} -F edit.tmpl
 4391  2022-08-29 15:33:34 cat ok | jq ".url" | xargs -I{} echo gh pr ready {}
 4393  2022-08-29 15:34:18 cat ok | jq ".url" | xargs -I{} echo gh pr edit {} --add-reviewer xyz
```


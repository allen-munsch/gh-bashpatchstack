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
gh pr create --title prev: refs/heads/AA-2054-feature-branch-1 next: refs/heads/jm/stacked/integrations/1 --draft --head 5063cb25cabd00a45217705430bfda127f419444 --base f0ab778d97b36b3506654873114cfc4e91027cd5
gh pr create --title prev: refs/heads/jm/stacked/integrations/1 next: refs/heads/jm/stacked/integrations/2 --draft --head f0ab778d97b36b3506654873114cfc4e91027cd5 --base e21e8633b1d5f5d0707e8b6f4c69c79055d66459
gh pr create --title prev: refs/heads/jm/stacked/integrations/2 next: refs/heads/jm/stacked/integrations/3 --draft --head e21e8633b1d5f5d0707e8b6f4c69c79055d66459 --base d72462fa0fdcd403eb83ecd4a0b5fd1ac0742140
#################
If you're okay with this then do:
    bash ./stacked.run
```

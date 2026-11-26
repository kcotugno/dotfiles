status is-interactive; or return

function __git_main_branch --description 'Print the repo main branch name (main, trunk, master, ...)'
    command git rev-parse --git-dir &>/dev/null; or return 1
    for ref in refs/{heads,remotes/{origin,upstream}}/{main,trunk,mainline,default,stable,master}
        if command git show-ref -q --verify $ref
            string split -r -m1 / $ref | tail -n1
            return 0
        end
    end
    echo master
    return 1
end

function __abbr_gswm
    echo git switch (__git_main_branch)
end

function __abbr_grbm
    echo git rebase (__git_main_branch)
end

function __abbr_gpsup
    echo git push --set-upstream origin (git branch --show-current)
end

# status / add / rm
abbr -a gst git status
abbr -a ga git add
abbr -a gaa git add --all
abbr -a grm git rm
abbr -a grmc git rm --cached

# diff / show
abbr -a gd git diff
abbr -a gds git diff --staged
abbr -a gsh git show

# commit
abbr -a gc git commit --verbose
abbr -a gcmsg git commit --message
abbr -a gcan git commit --verbose --amend --no-edit
abbr -a gcamend git commit --verbose --amend

# branch / checkout / switch
abbr -a gb git branch
abbr -a gbd git branch --delete
abbr -a gbD git branch --delete --force
abbr -a gco git checkout
abbr -a gcb git checkout -b
abbr -a gsw git switch
abbr -a gswc git switch --create
abbr -a gswm --function __abbr_gswm

# cherry-pick
abbr -a gcp git cherry-pick
abbr -a gcpa git cherry-pick --abort
abbr -a gcpc git cherry-pick --continue

# log / reflog / blame
abbr -a glog git log --oneline --decorate --graph
abbr -a gloga git log --oneline --decorate --graph --all
abbr -a glo git log --oneline --decorate
abbr -a glol "git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset'"
abbr -a grf git reflog
abbr -a gbl git blame -w

# clone / fetch / pull / push
abbr -a gcl git clone --recurse-submodules
abbr -a gf git fetch
abbr -a gfa git fetch --all --tags --prune
abbr -a gl git pull
abbr -a gpr git pull --rebase
abbr -a gp git push
abbr -a gpd git push --dry-run
abbr -a gpf git push --force-with-lease --force-if-includes
abbr -a gpsup --function __abbr_gpsup

# rebase
abbr -a grb git rebase
abbr -a grbi git rebase --interactive
abbr -a grbc git rebase --continue
abbr -a grba git rebase --abort
abbr -a grbs git rebase --skip
abbr -a grbm --function __abbr_grbm

# merge
abbr -a gm git merge
abbr -a gma git merge --abort

# stash
abbr -a gsta git stash push
abbr -a gstp git stash pop
abbr -a gstl git stash list
abbr -a gsts git stash show --patch
abbr -a gstd git stash drop

# reset / restore
abbr -a grh git reset
abbr -a grhh git reset --hard
abbr -a grs git restore
abbr -a grst git restore --staged

# remote
abbr -a gr git remote
abbr -a grv git remote --verbose

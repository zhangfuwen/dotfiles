# Git aliases as shell functions
gstatus() { git status -s "$@"; }
gfix() { git commit --amend "$@"; }

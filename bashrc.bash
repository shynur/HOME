#! /bin/bash
#
# Copyright (C) 2023 谢骐 <one.last.kiss@outlook.com>

FUNCNEST=1000 # 防止出现无穷递归
PS1='[\u@\H:\w/ \#th (\d \@) exited_$?]'$'\n''\$ '
PS3='You select (number): ' # select 语句的提示符

alias bc='bc --warn'
alias bzip2='bzip2 --verbose --best'
alias cal='cal --monday'
alias chcon='chcon --verbose'
alias cp='cp --interactive --recursive'
alias cpio='cpio -c --make-directories --io-size=4096 --verbose' # -c 使用新型的可移植存储形式
alias df='df -hT'
alias dmesg='dmesg --human --color'
alias du='du -ah --max-depth=1'
alias free='free --human --total'
alias fuser='fuser --user --verbose'
alias grep='grep --extended-regexp --color=always --line-number --with-filename --recursive'
alias gzip='gzip --verbose --best'
alias info='emacs -Q -f info-standalone'
alias jobs='jobs -l'
alias ll='ls -1 --almost-all --author --color=always --classify --format=verbose --human-readable --size --sort=extension --time-style=long-iso'
alias lsblk='lsblk -p; echo; lsblk -f'
alias nl='nl --body-numbering=a --number-format=rn'
alias partprobe='partprobe -s'
alias pidof='pidof -x'
alias restorecon='restorecon -v'
alias rm='rm --preserve-root --recursive --verbose'
alias sestatus='sestatus -v'
alias sudo='sudo '
alias tar='tar --verbose'
alias tree='tree -ahFC'
alias type='type -a' # -a 在 PATH 中查找时, 列出所有匹配项
alias uname='uname --all'
alias vi=vim
alias wc='wc --lines --words --chars'
alias wget='wget --verbose'
alias xargs='xargs --no-run-if-empty --verbose'
alias xz='xz -9 --extreme --verbose' # -9 压缩效果最好; --extreme 压缩效果格外地好

shopt -s dotglob # Filename Expansion 时, 包含隐藏文件
shopt -s failglob # Filename Expansion 时, 若匹配失败则报错
shopt -s globasciiranges # Filename Expansion 时, `[…]` 使用 ASCII 的排列顺序
shopt -u globskipdots # Filename Expansion 时, 不考虑 `.` 和 `..`
shopt -s globstar # Filename Expansion 时, `**` 会在当前目录及其子目录下搜索
shopt -s interactive_comments # 允许在 interactive shell 中使用注释
shopt -u nocaseglob # 进行 Filename Expansion 时, 区分大小写
shopt -u nocasematch # case 语句匹配模式时, 区分大小写
shopt -u noexpand_translation # $"..." 生成 $"..." 而不是 $'...'

# Let the terminal to save each command immediately after its execution.
shopt -s histappend
PROMPT_COMMAND='history -a'
# End of: Let the terminal to save each command immediately after its execution.

set -o emacs # 使用 Emacs 的键位
unset IFS # 开启 Word Splitting, 且让 Bash 为 IFS 使用默认值

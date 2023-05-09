#! /bin/bash
#
# Copyright (C) 2023 Shynur <one.last.kiss@outlook.com>
#
FUNCNEST=1000
# 防止出现无穷递归

PS1=_________________________________________________________$'\n'['\u'@'\H'\ '(\d)'\ '(\@)'\ '\w'/\ exit_'$?'\ '\#'_ing]$'\n''\$ '
# 效果:
# _________________________________________________________________
# [昵称@主机名 (星期 月份 日) (时钟) 目录 上条命令返回值 正在输入第N条命令]
# $
#
# 描述:
# [\u@\H (\d) (\@) \w/ exit_$? \#_ing]\n
# \$

PS3='You select (number): '
# select语句的提示符
#
alias bc='bc --warn'
alias bzip2='bzip2 --verbose --best'
alias cal='cal --monday'
alias chcon='chcon --verbose'
alias cp='cp --interactive --recursive'
alias cpio='cpio -c --make-directories --io-size=4096 --verbose'
# -c 使用新型的可移植存储形式

alias df='df -hT'
alias dmesg='dmesg --human --color'
alias du='du -ah --max-depth=1'
alias echo='echo -n -e'
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
alias type='type -a'
# -a 在PATH中查找时,列出所有匹配项

alias uname='uname --all'
alias vi=vim
alias wc='wc --lines --words --chars'
alias wget='wget --verbose'
alias xargs='xargs --no-run-if-empty --verbose'
alias xz='xz -9 --extreme --verbose'
# -9 压缩效果最好
# --extreme 压缩效果格外地好
#
shopt -u noexpand_translation
# $"..." 生成 $"..." 而不是 $'...'

shopt -s interactive_comments
# 允许在interactive shell中使用注释

shopt -u nocasematch
# case语句匹配模式时,区分大小写

# Want the terminal to save each command immediately after its execution?
# Add the following lines to ~/.bashrc file:
shopt -s histappend
PROMPT_COMMAND='history -a'

set -o emacs
# 使用Emacs的键位

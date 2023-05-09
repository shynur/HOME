#! /bin/bash
#
# Copyright (C) 2023 Shynur <one.last.kiss@outlook.com>

PS1=_________________________________________________________$'\n'['\u'@'\H'\ '(\d)'\ '(\@)'\ '\w'/\ exit_'$?'\ '\#'_ing]$'\n''\$ '
#
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

FUNCNEST=1000
# 防止出现无穷递归

#----------------------------------

alias ll='ls -1 --almost-all --author --color=always --classify --format=verbose --human-readable --size --sort=extension --time-style=long-iso'

alias df='df -hT'

alias sudo='sudo '

alias tree='tree -ahFC'

alias du='du -ah --max-depth=1'

alias lsblk='lsblk -p; echo; lsblk -f'

alias partprobe='partprobe -s'

alias free='free --human --total'

alias cp='cp --interactive --recursive'

alias gzip='gzip --verbose --best'

alias bzip2='bzip2 --verbose --best'

alias xz='xz -9 --extreme --verbose'
# -9 压缩效果最好
# --extreme 压缩效果格外地好

alias tar='tar --verbose'

alias cpio='cpio -c --make-directories --io-size=4096 --verbose'
# -c 使用新型的可移植存储形式

alias type='type -a'
# -a 在PATH中查找时,列出所有匹配项

alias cal='cal --monday'

alias rm='rm --preserve-root --recursive --verbose'

alias grep='grep --extended-regexp --color=always --line-number --with-filename --recursive'

alias wc='wc --lines --words --chars'

alias xargs='xargs --no-run-if-empty --verbose'

alias dmesg='dmesg --human --color'

alias wget='wget --verbose'

alias nl='nl --body-numbering=a --number-format=rn'

alias echo='echo -n -e'

alias bc='bc --warn'

alias jobs='jobs -l'

alias uname='uname --all'

alias fuser='fuser --user --verbose'

alias pidof='pidof -x'

alias sestatus='sestatus -v'

alias chcon='chcon --verbose'

alias restorecon='restorecon -v'

#------------------------------------

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

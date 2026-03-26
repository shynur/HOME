PROMPT_COMMAND=${PROMPT_COMMAND%;}; : ${PROMPT_COMMAND:=:}; PROMPT_COMMAND+=';times >|/tmp/.shynur.bash.times.$$.txt'
PS1=\\e[0m\\nreturned\ '\e[1;31m'\$?'\e[0m'';  ''\e[1;35m`((\j))&&echo \j`\e[0m`((\j))&&echo job\`((\j>1))&&echo s\` remain`'\\n'load:`\`[ -x /bin/emacs ]&&echo /bin/emacs||echo emacs\` -x <(echo "(princ (format \"\e[1;33m%s%%\e[0m\" (nth 0 (load-average))) t)")`'\ '`command free --mebi | egrep '\''^(Mem|Swap):'\'' | tail --lines=2 | awk '\''{print $3"/"$2}'\'' | paste --serial | awk '\''{print "mem:\e[1;33m"$1"\e[0m swap:\e[1;33m"$2"\e[0m"}'\''`'\ 'real:\e[1;33m$[SECONDS/60]m$[SECONDS%60]s\e[0m `cat /tmp/.shynur.bash.times.$$.txt | paste --serial | awk -F'\''[ms[:space:]]+'\'' '\''{print ($1*60+$2)+($5*60+$6)" "($3*60+$4)+($7*60+$8)}'\'' | python3 -c "u,s=[float(s)for s in input().split()];print(int(u)//60,int(u)%60,int(s)//60,int(s)%60)" | awk '\''{print "user:\e[1;33m"$1"m"$2"s\e[0m sys:\e[1;33m"$3"m"$4"s\e[0m"}'\'\`'`for d in ~ /var/www/html/ /opt/ /bin/; do [[ \w/ = $d* ]] && break; done &&echo -en " "du:\\\\\\e[1\\;33m &&du --human-readable --summarize 2>/dev/null | awk "{print \\\\$1}" | head -c-1 &&echo -en \\\\\\e[0m`'\\n'\e[1;32m'\\u'\e[0m'@'\e[1;32m'\\H'\e[0m':'\e[1;34m'\\w'\e[0m'\ \\#'`(((\#%10==1))&&echo st)||(((\#%10==2))&&echo nd)||(((\#%10==3))&&echo rd)||echo th`'\ [\\d\ '\D{%I:%M:%S %p}']'$((`git rev-parse --is-inside-work-tree 2>/dev/null`||`git rev-parse --is-inside-git-dir 2>/dev/null`)&&echo -e "" \e[38\;2\;241\;78\;50mGit\e[0m:`[ -z $(git branch --show-current) ]&&git describe --all||git branch --show-current`)'\\n'`((SHLVL-1))&&echo \\\\[$SHLVL] ""`''\$ '\\[\\e[3m\\]
# PS1 还会会像 Emacs minibuffer-depth-indicate-mode 那样显示递归层级.
PS2='\[\a\]'
PS0='\e[0m'

PS3='You select (number): '  # select 语句的提示符.

# <tab> 补全时从候选列表中剔除以这些 string 结尾的文件名.
if [ $FIGNORE ]; then
    FIGNORE+=:\~
else
    FIGNORE=\~
fi
FIGNORE+=:#

IGNOREEOF=10  # 连续读取这么多个 EOF 才会退出, 在此之前只会提示你建议使用 exit 命令.  这样就可以爽按 C-d 了.

shopt -s autocd  # interactive shell 下, 键入目录名, 自动 cd 过去.
# 很方便, 必须开启!

# TODO: '--color=auto' 这种东西真的需要吗?
alias cal='cal --monday'
alias df='df -hT'
alias du='du --human-readable'
alias free='free --human --total'
alias grep='grep --color=auto --line-number --with-filename'
alias htop='nice -n 99 htop'
alias jobs='jobs -l'  # 额外打印 PID.
alias ls='ls -1 --color=auto --classify --format=verbose --human-readable --size --sort=extension --time-style=long-iso'
alias mkdir='mkdir -p'
alias sudo='sudo '
alias top='nice -n 99 top'
alias xz='xz -9 --extreme --verbose'  # 我都用 xz 了肯定不在乎 CPU 占用了, 直接最高压缩率走起.
#alias bc='bc --warn'
#alias bzip2='bzip2 --verbose --best'
#alias chcon='chcon --verbose'
#alias clang-format='clang-format --Werror -fallback-style=none --ferror-limit=0'
#alias copilot='copilot --enable-all-github-mcp-tools'
#alias cp='cp --interactive --recursive'
#alias cpio='cpio -c --make-directories --io-size=4096 --verbose'  # -c 使用新型的可移植存储形式.
#alias dmesg='dmesg --human --color'
#alias fuser='fuser --user --verbose'
#alias gzip='gzip --verbose --best'
#alias info='emacs -Q -f info-standalone'
#alias lsblk='lsblk -p; echo; lsblk -f'
#alias meanest='sudo -E nice -n -20 sudo -E -u `logname`'  # 最吝啬 = 一点也不 nice.  解决了 'sudo nice -n -20 cmd' 中 cmd 所属用户是 root 的问题.
#alias nl='nl --body-numbering=a --number-format=rn'
#alias partprobe='partprobe -s'
#alias pidof='pidof -x'
#alias restorecon='restorecon -v'
#alias rm='rm --preserve-root --recursive --verbose'
#alias sestatus='sestatus -v'
#alias tar='tar --verbose'
#alias tree='tree -ahFC'
#alias type='type -a'  # -a 在 PATH 中查找时, 列出所有匹配项.
#alias uname='uname --all'
#alias wc='wc --lines --words --chars'
#alias wget='wget --verbose'
#alias xargs='xargs --no-run-if-empty --verbose'

alias emacs='emacsclient -alternate-editor= -create-frame -quiet --'
alias nvim=emacs
alias vim=emacs

if false; then  # 暂时没有用 ros 的需求.  而且这玩意 API/usage 也一直在变.
    alias ros2='which -s ros2 || {
                    echo -n "首次调用 ros2 命令, 正在执行初始化"
                    . /opt/ros/rolling/setup.bash                                && sleep 0.3 && echo -n  .   &&
                    . /usr/share/colcon_cd/function/colcon_cd.sh                 && sleep 0.3 && echo -n  .   &&
                    export _colcon_cd_root=/opt/ros/rolling                      && sleep 0.3 && echo -n ". " &&
                    . /usr/share/colcon_argcomplete/hook/colcon-argcomplete.bash && sleep 0.3 && {
                        echo "ROS 2 的相关环境已经成功初始化~"
                        echo; sleep 0.3
                        echo "一些常用命令:"
                        echo "  ~/workspace\$'$'\e[01;32m rosdep install \e[0m''-i --from-path src --rosdistro rolling -y  # 安装依赖包"
                        echo "  ~/workspace\$'$'\e[01;32m colcon build \e[0m''--symlink-install\`#无需编译 Python 文件\` --packages-up-to \"按需构建指定的包\""
                        echo "  ~/workspace\$ ros2\`#这是个 alias\` &>/dev/null; . install/local_setup.bash  # 创建 underlay+overlay"
                        echo "  ~/workspace\$ . install/setup.bash  # 单一的完整的环境"
                        echo "  ~/workspace/src\$'$'\e[01;32m ros2 pkg create \e[0m''--build-type ament_python --dependencies rclcpp --node-name node1\`#以自动创建一个 hello-world 样板\` --license GPL-3.0-only my_pkg_1"
                        echo "  ~/workspace/src\$'$'\e[01;32m ros2 pkg create \e[0m''--build-type ament_cmake  --dependencies rclcpp --node-name node2                                --license GPL-3.0-only my_pkg_2"
                        echo; sleep 0.3
                        echo "注意: 不要在 shell where workspace is built 中 source built overlay!"
                        echo; sleep 0.3
                        echo "两种最小 package 构成:"
                        echo "  ~/workspace/src/"
                        echo "              ├── my_pkg_1/"
                        echo "              │   ├── package.xml        元信息"
                        echo "              │   ├── resource/my_pkg_1  marker"
                        echo "              │   ├── setup.cfg          当包提供 executable 文件时, 提示 \`ros2 run\` 来此查找"
                        echo "              │   ├── setup.py           INSTALL"
                        echo "              │   └── my_pkg_1/          存放所有 custom nodes"
                        echo "              │       ├── __init__.py"
                        echo "              │       └── node1.py"
                        echo "              └── my_pkg_2/"
                        echo "                  ├── package.xml"
                        echo "                  ├── CMakeLists.txt"
                        echo "                  ├── include/my_pkg_2/"
                        echo "                  └── src/  存放所有 custom nodes"
                        echo "                      └── node2.cpp"
                        echo; sleep 0.3
                    }
                }; ros2'
    alias rosdep='ros2 &>/dev/null; rosdep'
    alias colcon='ros2 &>/dev/null; colcon'
fi

if which fzf &>/dev/null; then
    function fzf_insert_path {
        local FZF_DEFAULT_OPTS
        FZF_DEFAULT_OPTS="--height=60% --layout=reverse --preview 'batcat --style=numbers --color=always {}'"

        local PathName
        echo $'\e[0m'"${READLINE_LINE:0:READLINE_POINT}"$'\e[92m.\e[0m'"${READLINE_LINE:READLINE_POINT}"
        PathName=`FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS fzf`

        local Output
        Output=$PathName

        READLINE_LINE=${READLINE_LINE:0:READLINE_POINT}$Output${READLINE_LINE:READLINE_POINT}
        READLINE_POINT=$[READLINE_POINT+${#Output}]
    }
    bind -x '"\C-t":fzf_insert_path'
fi

function tgz {
  # 将指定目录压缩成单个 tar.gz 文件, 然后放到当前目录下.
  # Usage: tgz [/]path/to/dir[////] -> ./dir.tar.gz
  tar -cvf `sed s/'\/*$'// <<<$1 | sed s/'^.*\/'//`.tar.gz -I 'gzip -9' "$1"
  # 实现上, 也可以用 export GZIP=' -9 ' 来指定压缩率.
}

if [ msys = $OSTYPE ]; then
    shopt -s nocaseglob  # 进行 Filename Expansion 时, 不区分大小写.
fi

shopt -s globstar         # Filename Expansion 时, `**` 会在当前目录及其子目录下搜索.
set -o noclobber  # 使用 `>` 重定向时, 防止意外覆盖 existent 文件.  (用 `>|` 强制覆盖.)

shopt -s no_empty_cmd_completion  # 空行上按 <tab> 不会尝试补全命令.

shopt -s failglob  # Filename Expansion 时, 若匹配失败则报错.
shopt -s globasciiranges  # Filename Expansion 时, `[…]` 使用 ASCII 的字典序而不是 locale.

shopt -s checkjobs  # 若 jobs table 不为空, 则推迟 exit/logout, 且 打印 jobs table.
set +o notify  # 否则, 经常出现下一个 PS1 打印出来后, 突然冒出来 后台进程状态的 report.

# 允许命令 core dump, 限制大小为 NNN 块 (POSIX mode 下是 512B/块).
ulimit -c $[20*1024*1024/512]  # 允许 20MiB 大小的 coredump file.

# 打开小键盘的 NumLock 指示灯.
if which setleds &>/dev/null; then
    setleds -v -D +num  # '-v': 显示修改后的状态.  '-D': 同时修改 键盘的 LED 灯 和 实际状态.
fi

HISTCONTROL+=:ignoredups
HISTIGNORE+=:ls:cd:'cd -':\\::fg:.:..:/
HISTTIMEFORMAT='%F %T %t'
HISTSIZE=-1 HISTFILESIZE=-1        # 使得 $HISTFILE 可以无限增长.
shopt -s histappend  # 将历史命令追加到 $HISTFILE 而不是覆盖.
PROMPT_COMMAND=${PROMPT_COMMAND%;};: ${PROMPT_COMMAND:=:};export PROMPT_COMMAND+=';history -a;history -n'  # WARNING: 只有回车后才会加载来自其它 session 的历史.

if which pipx &>/dev/null; then
    eval "$(register-python-argcomplete pipx)"
fi

if [ -s $NVM_DIR/nvm.sh ]; then
    . $NVM_DIR/nvm.sh
    if [ -s $NVM_DIR/bash_completion ]; then
        . $NVM_DIR/bash_completion
    fi
    . <(npm completion)
fi

if which rustup &>/dev/null; then
    . <(rustup completions bash)
    . <(rustup completions bash cargo)
fi

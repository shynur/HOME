#! bash

if [ $1 = --help ]; then
    echo "Usage: $0 -N PATTERN
在 \`ps aux' 的输出结果中, 任何包含 PATTERN 的行所对应的进程都会被 \`kill' 发送 -N 信号."
    exit
fi

ps aux | grep "$2" - | {
    while read -a Row; do
	Pid=${Row[1]}
	# if (($Pid==$$)); then
	#     echo 'Skipped this script itself~'
	#     continue
	# fi
	Cmd=${Row[@]:10}
	if [ "${Cmd[*]}" = "grep $2 -" ] ||
	       [[ "${Cmd[*]}" = *"$0 "*"$*" ]]; then
	    continue
	fi
	echo -n "kill $1 $Pid(${Cmd[0]}) ..." $'\t'
	if kill $1 $Pid; then
	    echo 'succeeded'
	fi
    done
}

#!/bin/bash

cd `mktemp -d`

if ! gh auth token &>/dev/null; then
    gh auth login
fi

gh repo clone shynur/kimi-sessions -- --depth=1
cd kimi-sessions

if [ "$CNB_VSCODE_PROXY_URI" ]; then
    mv -f -- * .* ~/.kimi-code/
    echo
    echo ${CNB_VSCODE_PROXY_URI/'{{port}}'/58627}
else
    until which rsync &>/dev/null; do
        sleep 1
    done
    rsync -avz --delete .git/ root@172.17.0.1:/home/shynur/.kimi-code/.git/
    ssh root@172.17.0.1 'cd ~shynur/.kimi-code; git reset --hard HEAD'
fi

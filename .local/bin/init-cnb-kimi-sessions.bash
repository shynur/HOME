#!/bin/bash

cd `mktemp -d`


until which gh &>/dev/null; do
    sleep 1
done

if printf 'protocol=https\nhost=github.com\nusername=shynur\n' | git credential-cache get | grep password >/dev/null; then
    git clone --depth=1 https://github.com/shynur/kimi-sessions
else
    if ! gh auth token &>/dev/null; then
        gh auth login
    fi
    gh repo clone shynur/kimi-sessions -- --depth=1
fi
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

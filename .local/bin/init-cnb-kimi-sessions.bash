#!/bin/bash

set -euo pipefail

cd `mktemp -d`

if {
    printf 'protocol=https\nhost=github.com\nusername=98227472\n' | git credential-cache get
    printf 'protocol=https\nhost=github.com\nusername=shynur\n'   | git credential-cache get
} | grep password >/dev/null; then
    git clone --depth=1 https://github.com/shynur/kimi-sessions
else
    until which gh &>/dev/null; do
        sleep 1
    done
    if ! gh auth token &>/dev/null; then
        gh auth login
    fi
    gh repo clone shynur/kimi-sessions -- --depth=1
fi
cd kimi-sessions

until which rsync &>/dev/null; do
    sleep 1
done
if [ "$CNB_VSCODE_PROXY_URI" ]; then
    rsync -aI ./ ~/.kimi-code/
    echo
    echo ${CNB_VSCODE_PROXY_URI/'{{port}}'/58627}
else
    rsync -avz --delete .git/ root@172.17.0.1:/home/shynur/.kimi-code/.git/
    ssh root@172.17.0.1 'cd ~shynur/.kimi-code; git reset --hard HEAD'
fi

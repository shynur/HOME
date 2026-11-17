#!/bin/bash

set -eo pipefail

if {
    printf 'protocol=https\nhost=github.com\nusername=98227472\n' | git credential-cache get
    printf 'protocol=https\nhost=github.com\nusername=shynur\n'   | git credential-cache get
} | grep password >/dev/null; then
    echo 'Use git credential'
else
    until which gh &>/dev/null; do
        sleep 1
    done
    if ! gh auth token &>/dev/null; then
        gh auth login
    fi
    gh auth setup-git --hostname github.com
    echo 'Use gh credential'
fi

cd ~/.kimi-code
if [ X`git rev-parse --show-toplevel 2>/dev/null` = X`pwd -P` ]; then
    git pull
    git lfs pull
else
    cd `mktemp -d`
    git clone --depth=1 https://github.com/shynur/kimi-sessions .
    git lfs pull
    until which rsync &>/dev/null; do
        sleep 1
    done
    rsync -aI ./ ~/.kimi-code/
fi

if [ "$CNB_VSCODE_PROXY_URI" ]; then
    echo ${CNB_VSCODE_PROXY_URI/'{{port}}'/58627}
fi

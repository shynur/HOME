#!/bin/bash

set -eo pipefail

if {
    printf 'protocol=https\nhost=github.com\nusername=98227472\n' | git credential-cache get
    printf 'protocol=https\nhost=github.com\nusername=shynur\n'   | git credential-cache get
} | grep password >/dev/null; then
    echo 'Use git credential'
else
    until which gh &>/dev/null; do
        echo 'Waiting for downloading gh...'
        sleep 1
    done
    if ! gh auth token &>/dev/null; then
        gh auth login
    fi
    gh auth setup-git --hostname github.com
    echo 'Use gh credential'
fi

until git lfs version &>/dev/null; do
    echo 'Waiting for downloading git-lfs...'
    sleep 1
done
if [ -d ~/.kimi-code.mounted ]; then
    until [ -L ~/.kimi-code ]; do
        echo 'Waiting for .kimi-code to be prepared...'
        sleep 1
    done
fi
cd ~/.kimi-code
if [ X`git rev-parse --show-toplevel 2>/dev/null` = X`pwd -P` ]; then
    git pull
    git lfs pull
else
    echo '当前 .kimi-code 还不是一个人 git repo, 需要全新 clone'
    cd `mktemp -d`
    git clone --depth=1 https://github.com/shynur/kimi-sessions .
    git lfs pull
    until which rsync &>/dev/null; do
        echo 'Waiting for downloading rsync...'
        sleep 1
    done
    rsync -aI ./ ~/.kimi-code/
fi

if [ "$CNB_VSCODE_PROXY_URI" ]; then
    echo ${CNB_VSCODE_PROXY_URI/'{{port}}'/58627}
fi

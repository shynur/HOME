#!/bin/bash

cd `mktemp -d`

if ! gh auth token &>/dev/null; then
    gh auth login
fi

gh repo clone shynur/kimi-sessions -- --depth=1
cd kimi-sessions
mv -f -- * .*  ~/.kimi-code

echo
echo ${CNB_VSCODE_PROXY_URI/'{{port}}'/58627}

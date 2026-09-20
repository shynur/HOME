#!/bin/bash

cd `mktemp -d`

if ! gh auth token &>/dev/null; then
    gh auth login
fi

gh repo clone shynur/kimi-sessions -- --depth=1
cd kimi-sessions
mkdir -p ~/.kimi-code/sessions
mv -f -- sessions/*  \
         sessions/.*      ~/.kimi-code/sessions
cat session_index.jsonl >|~/.kimi-code/session_index.jsonl

if [ "$CNB_VSCODE_PROXY_URI" ]; then
    echo
    echo ${CNB_VSCODE_PROXY_URI/'{{port}}'/58627}
fi

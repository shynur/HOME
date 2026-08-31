#!/bin/bash

cd `mktemp -d`

if ! gh auth token &>/dev/null; then
    gh auth login
fi

gh repo clone shynur/kimi-sessions
cd kimi-sessions
mv -f -- * .*  ~/.kimi-code

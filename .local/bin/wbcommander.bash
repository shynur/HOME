#!/bin/bash

set -euo pipefail

if ! which wbcommander &>/dev/null; then
    go install github.com/shynur/wbcommander@latest
fi

exec wbcommander "$@"

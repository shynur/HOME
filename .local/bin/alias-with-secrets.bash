if [ $# != 1 ]; then
    echo "Usage: . $BASH_SOURCE <secrets.json>"
    return 1
fi

my_secrets_file=$1
if ! [ -f $my_secrets_file ]; then
    echo "File '$my_secrets_file' does NOT exist"
    return 1
fi

function get-token {
    local token_name=$1
    local py_script='
import json

with open("'$my_secrets_file'", "r", encoding="utf-8") as f:
    data = json.load(f)

token = data.get("'$token_name'", "")
print(token)
'
    python3 -c "$py_script"
}

function set-token {
    local token_name=$1
    local token_value=`get-token $token_name`
    if ! [ "$token_value" ]; then
        return 1
    fi
    eval $token_name=$token_value
}

if set-token GITHUB_TOKEN; then
    if alias copilot &>/dev/null; then
        alias copilot="GITHUB_TOKEN=$GITHUB_TOKEN `alias copilot | awk -F\' '{ print $2 }'`"
    else
        alias copilot="GITHUB_TOKEN=$GITHUB_TOKEN copilot"
    fi
fi

if set-token ANTHROPIC_API_KEY; then
    ANTHROPIC_AUTH_TOKEN=$ANTHROPIC_API_KEY
else
    set-token ANTHROPIC_AUTH_TOKEN
    ANTHROPIC_API_KEY=$ANTHROPIC_AUTH_TOKEN
fi
if [ "$ANTHROPIC_API_KEY" ]; then
    alias claude="ANTHROPIC_API_KEY=$ANTHROPIC_API_KEY ANTHROPIC_AUTH_TOKEN=$ANTHROPIC_AUTH_TOKEN claude"
fi

if set-token OPENAI_API_KEY; then
    mkdir -p ~/.codex
    echo "{ \"OPENAI_API_KEY\" : \"$OPENAI_API_KEY\" }" >|~/.codex/auth.json
fi

if set-token GEMINI_API_KEY; then
    alias gemini="GEMINI_API_KEY=$GEMINI_API_KEY gemini"
fi

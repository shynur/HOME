#!/bin/bash

. /etc/shynur-ide/ai-sk.sh

if [ "$AI_ALIBABA_BAILIAN" ]; then
    if ! grep -Pzq '(?m)^[[:blank:]]*\[providers\.alibaba-cn\][[:blank:]]*\napi_key[[:blank:]]*=' ~/.kimi-code/config.toml; then
        sed -i '/^[[:blank:]]*\[providers\.alibaba-cn\][[:blank:]]*$/a api_key="'"$AI_ALIBABA_BAILIAN"\" ~/.kimi-code/config.toml
    fi
fi

if [ "$AI_SEER" ]; then
    if ! grep -Pzq '(?m)^[[:blank:]]*\[providers\.seer-openai\][[:blank:]]*\napi_key[[:blank:]]*=' ~/.kimi-code/config.toml; then
        sed -i '/^[[:blank:]]*\[providers\.seer-openai\][[:blank:]]*$/a api_key="'"$AI_SEER"\" ~/.kimi-code/config.toml
    fi
fi

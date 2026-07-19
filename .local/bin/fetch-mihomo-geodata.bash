#!/usr/bin/env bash

# 从官方源拉取 mihomo 的 geodata 数据库到 ~/.config/mihomo/, 强制覆盖旧文件.

set -euo pipefail

DEST_DIR=$HOME/.config/mihomo
BASE_URL=https://github.com/MetaCubeX/meta-rules-dat/releases/download/latest

mkdir -p "$DEST_DIR"

for file in country.mmdb geosite.dat; do
    wget -q -O "$DEST_DIR/$file" "$BASE_URL/$file"
done

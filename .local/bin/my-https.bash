#!/usr/bin/env bash

# Usage: $0 PORT

set -euo pipefail

SERVE_DIR=`pwd`
PORT=$1

CERT_DIR=`mktemp -d`
CERT_FILE=$CERT_DIR/cert.pem
KEY_FILE=$CERT_DIR/key.pem

cleanup() {
    echo '[INFO] 正在停止服务器并清理临时文件...'
    [[ -n "${SERVER_PID:-}" ]] && kill $SERVER_PID 2>/dev/null || true
    rm -rf $CERT_DIR
}
trap cleanup EXIT

for cmd in openssl python3; do
    if ! command -v $cmd &>/dev/null; then
        echo '[ERROR] 未找到命令：$cmd，请先安装。' >&2
        exit 1
    fi
done

echo '[INFO] 正在生成自签名 TLS 证书...'
openssl   req -x509   -newkey rsa:2048   -keyout $KEY_FILE   -out $CERT_FILE   -nodes    -subj '/CN=localhost'    2>/dev/null

echo '[INFO] 按 Ctrl+C 停止服务器'

python3 -c "
import http.server, ssl, os, sys

os.chdir('$SERVE_DIR')

ctx = ssl.SSLContext(ssl.PROTOCOL_TLS_SERVER)
ctx.load_cert_chain('$CERT_FILE', '$KEY_FILE')

srv = http.server.HTTPServer(('0.0.0.0', $PORT), http.server.SimpleHTTPRequestHandler)
srv.socket = ctx.wrap_socket(srv.socket, server_side=True)
srv.serve_forever()
" &
SERVER_PID=$!

wait $SERVER_PID

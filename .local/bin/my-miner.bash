#!/bin/bash

set -euo pipefail

#-----------------------------
if ! which xmrig &>/dev/null; then
    sudo apt install -y xmrig
fi
if ! which curl &>/dev/null; then
    sudo apt install -y curl
fi
if ! which mihomo &>/dev/null; then
    (cd `mktemp -d`
     if ! which wget &>/dev/null; then
         sudo apt install -y wget
     fi
     wget https://github.com/MetaCubeX/mihomo/releases/download/v1.19.25/mihomo-linux-`[ $HOSTTYPE = x86_64 ] && echo amd64 || echo arm64`-v1.19.25.gz
     if ! which gzip &>/dev/null; then
         sudo apt install -y gzip
     fi
     gzip -d mihomo*.gz
     mv mihomo* mihomo
     sudo mv mihomo /usr/local/bin/)
fi
#-----------------------------

usage() {
    cat >&2 <<EOF
Usage: $0 (-s <订阅的URL> | -c <本地配置>) [-p <矿池URL>] [-u <用户设备>]
    -s  Clash 订阅地址     (与 -c 二选一)
    -c  本地 Clash 配置文件 (与 -s 二选一)
    -p  矿池 URL 协议+地址
    -u  用户/设备
EOF
}

SUB_URL=
CONF_FILE=
POOL=stratum+tcp://ghostrider.unmineable.com:3333
USER_DEV=shynur996.unknown
while getopts 's:c:p:u:h' opt; do
    case "$opt" in
        s) SUB_URL=$OPTARG ;;
        c) CONF_FILE=$OPTARG ;;
        p) POOL=$OPTARG ;;
        u) USER_DEV=$OPTARG ;;
        h) usage; exit ;;
        *) usage; exit 1 ;;
    esac
done
if [[ -z "$POOL" || -z "$USER_DEV" ]] || [[ -z "$SUB_URL" && -z "$CONF_FILE" ]]; then
    usage
    exit 1
fi
if [[ -n "$SUB_URL" && -n "$CONF_FILE" ]]; then
    echo '-s 与 -c 不能同时使用.' >&2
    exit 1
fi
if [[ -n "$CONF_FILE" && ! -r "$CONF_FILE" ]]; then
    echo "配置文件不可读: $CONF_FILE" >&2
    exit 1
fi

PORT=7890
WORKDIR=`mktemp -d`
CLASH_PID=
cleanup() {
    [[ -n $CLASH_PID ]] && kill $CLASH_PID 2>/dev/null || true
    rm -rf $WORKDIR
}
trap cleanup EXIT INT TERM

echo '>> 准备订阅 ...'
if [[ -n "$SUB_URL" ]]; then
    curl -fsSL --user-agent clash.meta "$SUB_URL" -o $WORKDIR/raw.yaml
else
    cp -- $CONF_FILE $WORKDIR/raw.yaml
fi

echo '>> 合成配置 ...'
sed -E '/^(mixed-port|port|socks-port|redir-port|tproxy-port|mode|external-controller|external-ui|allow-lan):/d' $WORKDIR/raw.yaml > $WORKDIR/stripped.yaml
{
    echo "mixed-port: $PORT"
    echo 'mode: global'
    echo 'allow-lan: false'
    cat $WORKDIR/stripped.yaml
} > $WORKDIR/config.yaml

echo '>> 启动代理 (mihomo) ...'
mihomo -d $WORKDIR >$WORKDIR/clash.log 2>&1 &
CLASH_PID=$!

echo '>> 等待代理就绪 ...'
for i in {1..30}; do
    if curl -fsS --max-time 3 -x socks5h://127.0.0.1:$PORT http://www.gstatic.com/generate_204 -o /dev/null 2>/dev/null; then
        echo '>> 代理就绪.'
        break
    fi
    sleep 1
    if [ $i = 30 ]; then
        echo '代理启动超时.  日志如下:' >&2
        cat $WORKDIR/clash.log >&2
        exit 1
    fi
done

echo '>> 启动 xmrig (stratum 经 SOCKS5) ...'
xmrig -a gr \
      -o "$POOL" \
      -u $USER_DEV \
      -p x \
      -x 127.0.0.1:$PORT

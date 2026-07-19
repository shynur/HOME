#!/usr/bin/env bash
# my-mihomo.bash — idempotently bring mihomo up/down.
#
#   usage: my-mihomo.bash {up,down}
#
# Reads node credentials from   /etc/shynur-ide/vpn.json   (provisioned by shynur-ide),
# renders them into             ~/.config/mihomo/template.yaml,
# and runs mihomo under a keepalive loop (auto-restart on crash).
#
# Idempotency: `up` is a no-op if already running with an identical rendered
# config, restarts if the config changed, starts if stopped. `down` is a no-op
# if already stopped. Concurrent invocations are serialized with flock.
set -euo pipefail

VPN_JSON=/etc/shynur-ide/vpn.json
TEMPLATE=$HOME/.config/mihomo/template.yaml
RUN_DIR=/run/shynur-ide/mihomo
CONFIG=$RUN_DIR/config.yaml
PIDFILE=$RUN_DIR/keepalive.pid
DATA_DIR=${HOME}/.config/mihomo
LOG=/var/log/mihomo.log

die() { echo "my-mihomo: error: $*" >&2; exit 1; }

[[ $# -eq 1 && ( $1 == up || $1 == down ) ]] \
  || { echo "usage: my-mihomo.bash {up,down}" >&2; exit 2; }

mkdir -p "$RUN_DIR" "$DATA_DIR"

# Serialize concurrent invocations; the lock is released when the script exits.
exec 9>"$RUN_DIR/lock"
flock 9

json_get() {  # json_get <key>  -> value on stdout, exit 1 if key absent
  python3 - "$VPN_JSON" "$1" <<'PY'
import json, sys
with open(sys.argv[1]) as f:
    doc = json.load(f)
val = doc.get(sys.argv[2])
if val is None:
    sys.exit(1)
print(val)
PY
}

keepalive_pid() { [[ -f $PIDFILE ]] && cat "$PIDFILE" || true; }

is_running() {
  local pid
  pid=$(keepalive_pid)
  [[ -n $pid ]] && kill -0 "$pid" 2>/dev/null
}

port_open() {  # port_open <port>
  (exec 3<>"/dev/tcp/127.0.0.1/$1") 2>/dev/null
}

render() {  # render <outfile>
  local out=$1 key ph val content
  [[ -r $VPN_JSON ]] || die "$VPN_JSON not found (not provisioned yet?)"
  [[ -r $TEMPLATE ]] || die "$TEMPLATE not found"
  content=$(<"$TEMPLATE")
  for key in name server port uuid servername public-key short-id; do
    val=$(json_get "$key") || die "key \"$key\" missing in $VPN_JSON"
    ph="@$(tr 'a-z-' 'A-Z_' <<<"$key")@"          # public-key -> @PUBLIC_KEY@
    content=${content//"$ph"/$val}
  done
  ! grep -qE '@[A-Z_]+@' <<<"$content" \
    || die "template contains placeholders not covered by $VPN_JSON"
  printf '%s\n' "$content" >"$out"
}

start_keepalive() {
  setsid nohup bash -c '
    data_dir=$1 config=$2 log=$3
    while :; do
      mihomo -d "$data_dir" -f "$config" >>"$log" 2>&1
      printf "%s keepalive: mihomo exited (code %s); restarting in 1s\n" \
             "$(date)" "$?" >>"$log"
      sleep 1
    done
  ' keepalive "$DATA_DIR" "$CONFIG" "$LOG" </dev/null >/dev/null 2>&1 9>&- &
  echo $! >"$PIDFILE"
}

stop_keepalive() {
  local pid
  pid=$(keepalive_pid)
  if [[ -n $pid ]] && kill -0 "$pid" 2>/dev/null; then
    kill -TERM -- "-$pid" 2>/dev/null || true    # setsid => pid is the pgid
    for _ in $(seq 1 50); do
      kill -0 "$pid" 2>/dev/null || break
      sleep 0.1
    done
    kill -0 "$pid" 2>/dev/null && kill -KILL -- "-$pid" 2>/dev/null || true
  fi
  rm -f "$PIDFILE"
}

do_up() {
  local port
  tmp=$(mktemp "$RUN_DIR/config.yaml.XXXXXX")   # script-scoped: the EXIT trap needs it
  trap 'rm -f "${tmp:-}"' EXIT
  render "$tmp"
  mihomo -t -d "$DATA_DIR" -f "$tmp" >/dev/null 2>&1 \
    || { mihomo -t -d "$DATA_DIR" -f "$tmp" >&2 || true
         die "rendered config failed validation"; }
  port=$(awk '/^mixed-port:/ { print $2; exit }' "$tmp")
  port=${port:-7890}

  if is_running; then
    if cmp -s "$tmp" "$CONFIG"; then
      echo "my-mihomo: already up (config unchanged)"
      return 0
    fi
    echo "my-mihomo: config changed; restarting"
    stop_keepalive
  elif port_open "$port"; then
    die "port $port is in use by a process not managed by this script"
  fi

  mv -f "$tmp" "$CONFIG"
  trap - EXIT
  start_keepalive
  for _ in $(seq 1 50); do
    if port_open "$port"; then
      echo "my-mihomo: up (127.0.0.1:$port)"
      return 0
    fi
    sleep 0.2
  done
  die "mihomo did not come up within 10s; see $LOG"
}

do_down() {
  stop_keepalive
  echo "my-mihomo: down"
}

case $1 in
  up)   do_up ;;
  down) do_down ;;
esac

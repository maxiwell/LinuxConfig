#!/bin/bash
# Despachante de layout: olha se o DisplayPort-1 (azorpa) está conectado e
# aplica dp1-left.sh (conectado) ou dp1-off.sh (desconectado).
# Idempotente e cheap — pode ser chamado a cada evento de hotplug.

export DISPLAY="${DISPLAY:-:0}"
export XAUTHORITY="${XAUTHORITY:-/run/user/$(id -u)/gdm/Xauthority}"

# evita execuções concorrentes (rajada de eventos)
exec 9>/tmp/monitor-hotplug.lock
flock -n 9 || exit 0

SECOND=DisplayPort-1
LOG=/tmp/monitor-watch.log

read_status() { xrandr --query 2>/dev/null | awk -v o="$SECOND" '$1==o{print $2; exit}'; }

# O X pode demorar a atualizar o estado do output logo apos o unplug/plug.
# Re-consulta ate estabilizar (2 leituras iguais) ou esgotar ~2s.
status=$(read_status)
for _ in 1 2 3 4; do
  sleep 0.4
  s2=$(read_status)
  [ "$s2" = "$status" ] && break
  status=$s2
done

echo "$(date '+%F %T') hotplug: $SECOND=$status" >>"$LOG"

if [ "$status" = "connected" ]; then
  echo "$(date '+%F %T')   -> dp1-left.sh" >>"$LOG"
  "$HOME/.local/bin/dp1-left.sh"
else
  echo "$(date '+%F %T')   -> dp1-off.sh" >>"$LOG"
  "$HOME/.local/bin/dp1-off.sh"
fi

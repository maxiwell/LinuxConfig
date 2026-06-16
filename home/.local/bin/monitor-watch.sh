#!/bin/bash
# Escuta hotplugs de monitor (udev, subsistema DRM) e dispara o ajuste de layout.
# Roda DENTRO da sessão X (autostart do Openbox), como usuário comum — sem root.
# udevadm monitor funciona sem privilégio; o handler herda DISPLAY/XAUTHORITY.

export DISPLAY="${DISPLAY:-:0}"
export XAUTHORITY="${XAUTHORITY:-/run/user/$(id -u)/gdm/Xauthority}"

DISP="$HOME/.local/bin/monitor-hotplug.sh"
LOG=/tmp/monitor-watch.log

# instância única (autostart pode rodar mais de uma vez)
exec 8>/tmp/monitor-watch.lock
flock -n 8 || exit 0

echo "$(date '+%F %T') watcher iniciado (pid $$)" >>"$LOG"

# aplica o estado atual ao logar (caso o azorpa já esteja plugado no login)
"$DISP" >>"$LOG" 2>&1

while true; do
  udevadm monitor --udev --subsystem-match=drm 2>/dev/null | while IFS= read -r line; do
    case "$line" in
      UDEV*drm*)
        # log cru do evento (ajuda a ver se o UNPLUG gera evento)
        echo "$(date '+%F %T') evento: $line" >>"$LOG"
        # coalesce a rajada de eventos do mesmo plug/unplug
        while IFS= read -r -t 1 _; do :; done
        echo "$(date '+%F %T') hotplug DRM -> dispatch" >>"$LOG"
        "$DISP" >>"$LOG" 2>&1
        ;;
    esac
  done
  echo "$(date '+%F %T') udevadm monitor terminou; reiniciando em 2s" >>"$LOG"
  sleep 2
done

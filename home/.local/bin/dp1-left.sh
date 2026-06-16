#!/bin/bash
# DisplayPort-1 à esquerda do eDP, mantendo o eDP como primary.
# As janelas já abertas são empurradas de volta para o eDP.
# Seguro rodar várias vezes (se o layout já estiver aplicado, não mexe nas janelas).
#
# Uso: dp1-left.sh [resistencia_px]   (resistência da borda do mouse; padrão 50)

PRIMARY=eDP
SECOND=DisplayPort-1
RESIST=${1:-1080}

# x do primary ANTES de aplicar o layout
old_x=$(xrandr --query | awk -v o="$PRIMARY" '$1==o && /\+/{ for(i=1;i<=NF;i++) if($i ~ /^[0-9]+x[0-9]+\+/){ split($i,a,"+"); print a[2]; exit } }')
[ -z "$old_x" ] && old_x=0

# aplica: DP-1 à esquerda, eDP primary à direita
xrandr --output "$SECOND" --auto --left-of "$PRIMARY" --output "$PRIMARY" --primary

# x do primary DEPOIS
new_x=$(xrandr --query | awk -v o="$PRIMARY" '$1==o && /\+/{ for(i=1;i<=NF;i++) if($i ~ /^[0-9]+x[0-9]+\+/){ split($i,a,"+"); print a[2]; exit } }')
[ -z "$new_x" ] && new_x=0

delta=$((new_x - old_x))

# se o primary se deslocou, empurra as janelas abertas junto (pra continuarem no eDP)
if [ "$delta" -ne 0 ] && command -v wmctrl >/dev/null; then
  while read -r id desk cls rest; do
    case "$cls" in
      tint2.Tint2) continue ;;   # nao mexe no painel
    esac
    read -r gx gy < <(wmctrl -lG | awk -v I="$id" '$1==I{print $3, $4}')
    [ -z "$gx" ] && continue
    newx=$((gx + delta))
    if xprop -id "$id" _NET_WM_STATE 2>/dev/null | grep -q MAXIMIZED; then
      wmctrl -i -r "$id" -b remove,maximized_vert,maximized_horz
      wmctrl -i -r "$id" -e 0,$newx,$gy,-1,-1
      wmctrl -i -r "$id" -b add,maximized_vert,maximized_horz
    else
      wmctrl -i -r "$id" -e 0,$newx,$gy,-1,-1
    fi
  done < <(wmctrl -lx)
fi

# --- resistência ("sticky edge") na fronteira eDP <-> DP-1 ---
# A fronteira fica exatamente no x do eDP (new_x); altura = altura do eDP.
pkill -x edge-resistance 2>/dev/null
edp_h=$(xrandr --query | awk -v o="$PRIMARY" '$1==o && /\+/{ for(i=1;i<=NF;i++) if($i ~ /^[0-9]+x[0-9]+\+/){ split($i,a,"x"); split(a[2],b,"+"); print b[1]; exit } }')
[ -z "$edp_h" ] && edp_h=1080
if [ -x "$HOME/.local/bin/edge-resistance" ] && [ "$new_x" -gt 0 ]; then
  # setsid + fecha os fds de lock herdados (8=monitor-watch, 9=monitor-hotplug):
  # o edge-resistance é daemon de longa duração e, se herdasse os locks, travaria
  # os despachos seguintes (ex.: o dp1-off no disconnect nunca rodaria).
  setsid "$HOME/.local/bin/edge-resistance" "$RESIST" "$new_x" "$edp_h" \
    </dev/null >/tmp/edge-resistance.log 2>&1 8>&- 9>&- &
fi

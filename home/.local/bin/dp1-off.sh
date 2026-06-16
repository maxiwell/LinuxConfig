#!/bin/bash
# Desliga o DisplayPort-1 e devolve o eDP para 0x0 como primary.
# Complemento de dp1-left.sh — usado ao DESCONECTAR o monitor (azorpa).
# Idempotente: se o DP-1 já estiver off, o eDP não se desloca e nada é mexido.

PRIMARY=eDP
SECOND=DisplayPort-1

geom_x() { xrandr --query | awk -v o="$1" '$1==o && /\+/{ for(i=1;i<=NF;i++) if($i ~ /^[0-9]+x[0-9]+\+/){ split($i,a,"+"); print a[2]; exit } }'; }

# x do primary ANTES
old_x=$(geom_x "$PRIMARY"); [ -z "$old_x" ] && old_x=0

# desliga o secundário e fixa o eDP em 0x0 como primary
xrandr --output "$SECOND" --off --output "$PRIMARY" --primary --pos 0x0

# x do primary DEPOIS
new_x=$(geom_x "$PRIMARY"); [ -z "$new_x" ] && new_x=0
delta=$((new_x - old_x))

# se o primary se deslocou (saiu de +1920 p/ +0), puxa as janelas junto
if [ "$delta" -ne 0 ] && command -v wmctrl >/dev/null; then
  while read -r id desk cls rest; do
    case "$cls" in
      tint2.Tint2) continue ;;   # nao mexe no painel
    esac
    read -r gx gy < <(wmctrl -lG | awk -v I="$id" '$1==I{print $3, $4}')
    [ -z "$gx" ] && continue
    newx=$((gx + delta)); [ "$newx" -lt 0 ] && newx=0
    if xprop -id "$id" _NET_WM_STATE 2>/dev/null | grep -q MAXIMIZED; then
      wmctrl -i -r "$id" -b remove,maximized_vert,maximized_horz
      wmctrl -i -r "$id" -e 0,$newx,$gy,-1,-1
      wmctrl -i -r "$id" -b add,maximized_vert,maximized_horz
    else
      wmctrl -i -r "$id" -e 0,$newx,$gy,-1,-1
    fi
  done < <(wmctrl -lx)
fi

# uma tela só: a resistência de borda nao faz mais sentido
pkill -x edge-resistance 2>/dev/null
exit 0

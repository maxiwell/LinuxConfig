#!/usr/bin/env bash
# Coleta dados lentos/caros para o nocturne.lua (rodado em background a cada ~15s).
# Escreve key=value em $1 de forma atômica.
out=${1:?uso: slow.sh <arquivo>}
tmp="$out.tmp"
ipf="$out.extip"

# IP externo: no máximo uma consulta a cada 10 min
if [[ ! -s $ipf || -n $(find "$ipf" -mmin +10 2>/dev/null) ]]; then
    ip=$(curl -s --max-time 5 https://ipecho.net/plain)
    [[ $ip =~ ^[0-9a-fA-F.:]+$ ]] && echo "$ip" > "$ipf"
fi

{
    echo "extip=$(cat "$ipf" 2>/dev/null)"
    nmcli -t -f active,ssid,signal dev wifi list --rescan no 2>/dev/null |
        awk -F: '$1=="yes"{print "ssid="$2; print "signal="$3; exit}'
    # detalhes do enlace Wi-Fi: frequência, canal, largura, dBm, taxas, padrão
    wif=$(iw dev 2>/dev/null | awk '$1=="Interface"{i=$2} $1=="ssid"{print i; exit}')
    if [[ -n $wif ]]; then
        iw dev "$wif" info 2>/dev/null |
            awk '$1=="channel"{print "wchan="$2; gsub(/[(,]/,"",$3); print "wfreq="$3; print "wwidth="$6}'
        iw dev "$wif" link 2>/dev/null | awk '
            $1=="signal:"     {print "wdbm="$2}
            $1=="rx" && $2=="bitrate:" {print "wrx="int($3); s=$0}
            $1=="tx" && $2=="bitrate:" {print "wtx="int($3)}
            END {
                std = s ~ /EHT-/ ? "Wi-Fi 7" : s ~ /HE-/ ? "Wi-Fi 6" : s ~ /VHT-/ ? "Wi-Fi 5" : s ~ /MCS/ ? "Wi-Fi 4" : ""
                print "wstd=" std
            }'
    fi
    df -B1 --output=size,used,avail / |
        awk 'NR==2{print "fs_size="$1; print "fs_used="$2; print "fs_avail="$3}'
    echo "vpn=$(ls /sys/class/net | grep -E '^(wg|tun|tailscale)' | paste -sd' ')"
} > "$tmp" && mv "$tmp" "$out"

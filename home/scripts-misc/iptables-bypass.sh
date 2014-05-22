#!/bin/bash

# Este script limpa todas as regras do IPTABLES e deixa o Padrao ACCEPT em todas as Chains
# Deve ser executado como root
# Se passar -n, o modo iterativo sera desabilitado negando qualquer pergunta


function cleanRules {
   echo -e " - Limpando as Regras..."
   iptables -F
   echo -e " - Setando -P ACCEPT em todas as Chains..."
   iptables -P INPUT ACCEPT
   iptables -P FORWARD ACCEPT
   iptables -P OUTPUT ACCEPT
   echo -e " - OK"
}



if [[ $# -eq 0 ]]; then
    read -p  "Deseja salvar as regras vigentes? (s/N) " salvar
    
    case $salvar in
        [Ss]* ) sudo iptables-save > firewall.rules; echo -e "Regras salvas em: firewall.rules";;
        * ) echo -e "Atencao: As regras nao serao salvas!";;
    esac
fi

cleanRules


#!/usr/bin/env python
# -*- coding: UTF-8 -*-

import re
import sys

places_dic = {

'POSTO':'Carro:Combustivel',
'CINEMAS':'Shopping:Cinemas',
'SUPERMERCADOS' : 'Mercado',
'SUPERMERCADO' : 'Mercado',
'DONALDS' : 'Comida:Lanches',
'BURGER' : 'Comida:Lanches',
'BARDANA' : 'Comida',
'PIZZA' : 'Comida:Lanches',
'ACARAJE' : 'Comida',
'EXTRA LOJA' : 'Mercado',
'LANCHAO' : 'Comida:Lanches',
'SAPORE' : 'Comida',
'SOLAR DOS PAMPAS' : 'Comida',
'AUTO BARBIERI' : 'Carro:Combustivel',
'PASTEL' : 'Comida:Lanches',
'ACAIZEIRO' : 'Comida:Lanches',
'AC UNICAMP' : 'Vendas',
'AC BARAO DE GERALDO' : 'Vendas',
'MERCADOS' : 'Mercado',
'POSTO' : 'Carro:Combustivel',
'AC UNICAMP' : 'Vendas',
'REDE GOAL' : 'Carro:Combustivel',
'SPOLETO' : 'Comida',
'TEMPERO' : 'Comida',
'PRO MUSIC' : 'Vendas'

}


def get_cotacao(i):
        lsplit = i.next()
        while (lsplit[0].find("convertido") == -1):
            lsplit = i.next().split("\t")
        
        # escape the dotted line
        i.next().split()
        
        lsplit = i.next().split()
        cotacao_dolar = lsplit[-3]
        return cotacao_dolar.replace(",", ".")

#----------------
# Main
#----------------

if len(sys.argv) <= 1 :
    print 'Falando o parametro'
else:
    print 'Carregando: ', sys.argv[1]

result = open(sys.argv[1]+".csv", "w")

cartao = open(sys.argv[1], 'r')
readingFile = cartao.read()
readingFile = readingFile.split('\n')

i = iter(readingFile)
lsplit = i.next()
while (lsplit[0].find("Compras a vista") == -1):
    lsplit = i.next().split("\t")


i_temp = iter(readingFile)
cotacao_dolar = float(format(float(get_cotacao(i_temp)),'.4f'))
IOF = 0.0638

while True:
    try:
        lsplit = i.next().split()

        if (not lsplit):
            break

        if (lsplit[0] == "**"):
            continue
        
       
        data = lsplit[0].replace("/","-")
        # set list in string, with whitespace between each element
        descricao = ' '.join(lsplit[1:-4])

        pais = lsplit[-3]
        if (pais != "BR"):
            valor = float(format(float(lsplit[-1].replace(",",".")), '.2f'))
            valor = float(format(((valor * IOF)+valor), '.2f'))
            valor = str(valor * cotacao_dolar).replace(".", ",")

            # Truncando o valor duas casas apos o ponto. Arredontamento nao pode!
            dot_index = valor.find(",")
            valor = valor[0:dot_index+3]
            cidade = "Cotacao U$: "+str(cotacao_dolar)
        else:
            cidade = lsplit[-4]
            valor = lsplit[-2] 

        line = data+";1;;;"+descricao+", "+cidade+";-"+valor+";"
      
        # search the place name in the key 
        for key in places_dic:
            if re.match(".*"+key, descricao):
                line = line+str(places_dic.get(key))
                break

        result.write(line+";\n")
 #       print line
    except StopIteration:
        break




cartao.close()
result.close()





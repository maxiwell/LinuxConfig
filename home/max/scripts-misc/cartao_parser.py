#!/usr/bin/env python

import re
import sys

places_dic = {

'AUTO POSTO':'Carro:Combustivel',
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
'MERCADOS' : 'Mercado'

}



if len(sys.argv) <= 1 :
    print 'Falando o parametro'
else:
    print 'Carregando: ', sys.argv[1]

result = open(sys.argv[1]+".out", "w")

cartao = open(sys.argv[1], 'r')
readingFile = cartao.read()
readingFile = readingFile.split('\n')

i = iter(readingFile)

#for l in readingFile:
while True:
    try:
        lsplit = i.next().split("\t")
        line = lsplit[0]+"/2013;1;;;"+lsplit[-1]+";-"+i.next()+";"
        line = line.replace("(","").replace(")","")

        place = lsplit[-1] #Pegar o lugar 
      
        # search the place name in the key 
        for key in places_dic:
            if re.match(".*"+key, place):
                line = line+str(places_dic.get(key))



#        result.write(line)
        print line
    except StopIteration:
        break
    






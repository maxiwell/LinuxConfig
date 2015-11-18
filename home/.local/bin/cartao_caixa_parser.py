#!/usr/bin/env python

# NAO USO DESDE MAI/2015
# --------------------------------------------------------------
# A Caixa nao exporta em fatura em nenhum formato. Então eu 
# seleciono todos lancamentos da fatura no Browser e colo em 
# um arquivo texto. Este script parseia essas entradas e monta
# um CSV correto para o HomeBank
#
# ENTRADA: Um TXT criado manualmente com os lançamentos 
# SAIDA: Um CSV formatado para o HomeBank
#
# --------------------------------------------------------------



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
'MERCADOS' : 'Mercado',
'POSTO' : 'Carro:Combustivel'
}



if len(sys.argv) <= 1 :
    print 'Falando o parametro'
else:
    print 'Carregando: ', sys.argv[1]

result = open(sys.argv[1]+".csv", "w")

cartao = open(sys.argv[1], 'r')
readingFile = cartao.read()
readingFile = readingFile.split('\n')

i = iter(readingFile)

#for l in readingFile:
while True:
    try:
        lsplit = i.next().split("\t")
        lsplit[0] = lsplit[0].replace("/","-")
        line = lsplit[0]+"-13;1;;;"+lsplit[-1]+";-"+i.next()+";"
        line = line.replace("(","").replace(")","")

        place = lsplit[-1] #Pegar o lugar 
      
        # search the place name in the key 
        for key in places_dic:
            if re.match(".*"+key, place):
                line = line+str(places_dic.get(key))
                break



        result.write(line+";\n")
#        print line
    except StopIteration:
        break
    
cartao.close()
result.close()




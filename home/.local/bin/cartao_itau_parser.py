#!/usr/bin/env python2
# -*- coding: utf-8 -*-

# --------------------------------------------------------------
# O Itau exporta a fatura do Cartao de Credito apenas em PDF.
# Então eu seleciono todos lancamentos da fatura no Browser 
# e colo em um arquivo texto. Este script parseia essas entradas 
# e monta um CSV correto para o HomeBank
#
# ENTRADA: Um TXT criado manualmente com os lançamentos 
# SAIDA: Um CSV formatado para o HomeBank
# --------------------------------------------------------------



import re,sys
import datetime as dt


if len(sys.argv) <= 1 :
    print 'Falando o parametro'
    sys.exit(1)
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
        lsplit = i.next().split("  ")
        lsplit[0] = lsplit[0].replace("/","-") + "-" + str(dt.datetime.now().year)[2:]
        line = lsplit[0]+";1;;;"+lsplit[1][1:]+";-"+lsplit[-1].replace(" ","")+";"
        line = line.replace("(","").replace(")","")
        result.write(line+";\n")
        print line
    except StopIteration:
        break
    
cartao.close()
result.close()





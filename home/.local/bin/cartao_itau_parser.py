#!/usr/bin/env python3
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
    print('Falando o parametro')
    sys.exit(1)
else:
    print('Carregando: ', sys.argv[1]);

result = open(sys.argv[1]+".csv", "w")

cartao = open(sys.argv[1], 'r')
readingFile = cartao.read()
readingFile = readingFile.split('\n')

i = iter(readingFile)

#for l in readingFile:
while True:
    try:
        lsplit = next(i).split(" ")
        date = lsplit[0].replace("/","-") + "-" + str(dt.datetime.now().year)[2:]
        del lsplit[0];
        value = lsplit[-1].replace(" ","");
        del lsplit[-1];
        line = date+";1;;;"+" ".join(str(p) for p in lsplit)+";-"+value+";"
        result.write(line+";\n")
        print(line)
    except StopIteration:
        break
    
cartao.close()
result.close()





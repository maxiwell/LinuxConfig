#!/usr/bin/env python

#
# Script para montar uma tabela com porcentagens
# baseado na saida do script archc_get_stats.py
#


import sys

if len(sys.argv) < 1:
        print 'Falta argumento'
        sys.exit(1)

result = open("Table.txt", 'w')


result.write('bin name;total instructions;load;store;arithmetic logical;comparison;data movement;jump;branch;\n')


# get the porcent
for f in sys.argv [1:len(sys.argv)]:
    inputFile = open(f, 'r')
    lista = [cel.split(';') for cel in inputFile]
    result.write(f.split("_")[1]+';') # nome do binario
    result.write(lista[2][1]+";") # numero total de instrucao
    lista = lista[5: -1]
    listaZip = zip(*lista)

    for x in listaZip[2:-1]:
        for y in x:
            if y != 'porcent':
                result.write(y+";")
        result.write("\n")


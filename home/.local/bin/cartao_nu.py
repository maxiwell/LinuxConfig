#!/usr/bin/env python2
# -*- coding: UTF-8 -*-

# --------------------------------------------------------------
# Baixa um CSV do plugin NU Bank e converte para um CSV 
# formatado para o HomeBank
#
# ENTRADA: CSV do plugin do NU Bank
# SAIDA: CSV formatado para o HomeBank
#
# --------------------------------------------------------------



import re
import sys

cat_dic = {
'vestuário':'Vestuario',
'restaurante':'Comida',
'eletrônicos' : 'Tecnologia',
'transporte' : 'Carro:Combustivel',
'supermercado' : 'Mercado',
'serviços' : '',
'saúde' : 'Remedio',
'outros' : '',
'lazer' : 'Diversao',
'viagem' : 'Viagens',
'educação' : 'Curso',
}

def converte_dia (dia):
    dia, mes = dia.split()

    if mes == 'Jan' :
        mes = '01'
    elif mes == 'Fev' :
        mes = '02'
    elif mes == 'Mar' :
        mes = '03'
    elif mes == 'Abr' :
        mes = '04'
    elif mes == 'Mai' :
        mes = '05'
    elif mes == 'Jun' :
        mes = '06'
    elif mes == 'Jul' :
        mes = '07'
    elif mes == 'Ago':
        mes = '08'
    elif mes == 'Set' :
        mes = '09'
    elif mes == 'Out' :
        mes = '10'
    elif mes == 'Nov' :
        mes = '11'
    elif mes == 'Dez' :
        mes = '12'

    return dia+'-'+mes+'-'+'15'

##########################################
# Main
##########################################

if len(sys.argv) <= 1 :
    print 'Falando o parametro'
    sys.exit(1)
else:
    print 'Carregando: ', sys.argv[1]

cartao = open(sys.argv[1], 'r')
result = open("output.csv", "w+")

next(cartao)
for line in cartao:
    try:
        cat,desc,valor,data = line.split(',')

        data = converte_dia(data)
        result.write(data+';0;;;'+desc+';-'+valor+';'+cat_dic.get(cat)+';\n')

    except: # catch *all* exceptions
        e = sys.exc_info()[0]
        print "ERROR: " + line.strip("\n") + " : " + str(e)

sys.exit(0)




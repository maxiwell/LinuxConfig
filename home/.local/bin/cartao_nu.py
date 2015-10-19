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
import datetime

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

}

#################################################################
def get_cotacao(cartao):
    readingFile = cartao.read().split('\n')
    i = iter(readingFile)
    line = i.next()
    while (line.find("convertido") == -1):
        line = i.next();

    i.next(); # escape the dotted line
    cotacao = i.next().split()[-3];

    cartao.seek(0);
    ret = float(format(float(cotacao.replace(",",".")),'.4f'))
    print "Cotacao:",ret
    
    return ret 


#################################################################
def Pagamentos(pos):
    line = pos.next()
    return pos


#################################################################
def Compras(pos):

    while True:  # ate encontrar uma linha vazia
  
        line = pos.next().split()
        
        if not line:
            return pos

        # escapado de linhas que nao comecam com dias
        if (line[0].find("/") == -1):
            continue

        dia = line[0].replace("/","-")
        descricao = ' '.join(line[1:-3])  # set list in string, with whitespace between each element 
        pais = line[-3]
    
        if (line[-2] == "0,00"):
            moeda = float(line[-1].replace(",","."))*-1
            reais = False
        else:
            moeda = float(line[-2].replace(",","."))*-1
            reais = True
    
        if (pais != "BR"):
            if (reais != True):
               moeda = ((moeda * IOF) + moeda) * cotacao_dolar
               descricao = descricao + ", Cotacao U$: " + str(format(cotacao_dolar, '.4f'))
         
        # Truncando o valor duas casas apos o ponto. Arredontamento nao pode!
        moeda = str(format(moeda, '.2f')).replace('.',',')
        dot_index = moeda.find(",")
        moeda = moeda[0:dot_index+3]
    
        tupla = dia+";1;;;"+descricao+";"+moeda+";"
    
        # search the place name in the key 
        for key in places_dic:
            if re.match(".*"+key, descricao):
                tupla = tupla+str(places_dic.get(key))
                break
  
        print tupla
        result.write(tupla+";\n")
    return pos


#################################################################
def Debitos_diversos(pos):

    while True:  # ate encontrar uma linha vazia
  
        line = pos.next().split()
        
        if not line:
            return pos

        # escapado de linhas que nao comecam com dias
        if (line[0].find("/") == -1):
            continue

        if (line[1].find("IOF") != -1):
            continue

        dia = line[0].replace("/","-")
        descricao = ' '.join(line[1:-3])  # set list in string, with whitespace between each element 
        pais = line[-3]
    
        if (line[-2] == "0,00"):
            moeda = float(line[-1].replace(",","."))*-1
            reais = False
        else:
            moeda = float(line[-2].replace(",","."))*-1
            reais = True
    
        if (pais != "BR"):
            if (reais != True):
               moeda = ((moeda * IOF) + moeda) * cotacao_dolar
               descricao = descricao + ", Cotacao U$: " + str(format(cotacao_dolar, '.4f'))
         
        # Truncando o valor duas casas apos o ponto. Arredontamento nao pode!
        moeda = str(format(moeda, '.2f')).replace('.',',')
        dot_index = moeda.find(",")
        moeda = moeda[0:dot_index+3]
    
        tupla = dia+";1;;;"+descricao+";"+moeda+";"

        # search the place name in the key 
        for key in places_dic:
            if re.match(".*"+key, descricao):
                tupla = tupla+str(places_dic.get(key))
                break

        print tupla
        result.write(tupla+";\n")

    
    line = pos.next()
    return pos


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

readingFile = cartao.read().split('\n')
it_line = iter(readingFile)

# escape the first line
it_line.next();

for line in it_line:
    try:
        cat,desc,valor,data = line.split(',')

        data = converte_dia(data)
        result.write(data+';0;;;'+desc+';-'+valor+';'+cat_dic.get(cat)+';\n')

    except:
        sys.exit(0)

sys.exit(0)


# RESUMO EM REAL eh a ultima linha analisada
while (line.find("RESUMO EM REAL") == -1):

    if "Pagamentos" in line:
        i = Pagamentos(i)
    if "Compras a vista" in line:
        i = Compras(i)
    if "Compras Diversas" in line:
        i = Compras(i)
    if "Debitos diversos" in line:
        i = Debitos_diversos(i)
    line = i.next();

cartao.close()
result.close()

result = open(sys.argv[1]+".csv","r+")

# Checando o Valor total
somatorio = 0.0;
for line in result:
     somatorio += float(line.split(";")[5].replace(",","."))
print "Total da Fatura: R$ " + str(somatorio)

result.close()






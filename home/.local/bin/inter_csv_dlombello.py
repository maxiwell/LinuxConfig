#!/bin/env python3

import csv
import sys
import datetime


def parseDesc(cat, desc):
    cat = cat.upper()
    desc = desc.upper()

    if not "EVENTO B3" in cat:
        return False, False

    words = desc.split()
    sticker = words[-1]

    if "JUROS S/CAPITAL" in desc:
        tipo = "JSCP"
    elif "RENDIMENTO" in desc:
        tipo = "RENDIMENTO"
    elif "DIVIDENDOS" in desc:
        tipo = "DIVIDENDO"
    elif "FRAÇÕES" in desc:
        tipo = "V.FRACAO"
    else:
        tipo = "DESCONHECIDO"

    return tipo, sticker


def brl(string):
    return float(string.replace(".", "").replace(",", "."))


# -------
# Main
# -------
reader = csv.reader(open(sys.argv[1], "r"), delimiter=';')
output = open("dlombello.csv", "w")

output.write("ativo;date;evento;valor;irrf;moeda;corretora;date_com;observacao;market_cod;classe;ptax;vlr_bruto;irrf_total;vlr_liquido;nota_ptax" + "\n")

saldo_acc = False

for row in reader:
    if (len(row) < 4):
        if (len(row) == 2) and ("Saldo:" in row[0]):
            saldo_final = brl(row[1])
        continue

    if (row[0] == "Data Lançamento"):
        continue

    data = row[0]
    cat  = row[1]
    desc = row[2]
    valor = row[3]
    #saldo = row[4]
    irrf = "0"

    #if (not saldo_acc):
    #    saldo_acc = brl(saldo) - brl(valor)

    #saldo_acc += brl(valor)

    tipo, sticker = parseDesc(cat, desc)
    if (not tipo):
        continue

    date = datetime.datetime.strptime(data, "%d/%m/%Y").strftime("%Y-%m-%d")

    line = sticker + ";"
    line += date + ";"
    line += tipo + ";"
    line += valor + ";"
    line += irrf + ";"
    line += "BRL;"
    line += "INTER;"

    line += ";;;;;;;;;"

    output.write(line + "\n")


#if (round(saldo_acc, 2) == round(saldo_final, 2)):
#    print("Saldo OK: " + str(saldo_final))
#else:
#    print("Saldo ERRADO: " + str(saldo_acc) + " vs " + str(saldo_final))

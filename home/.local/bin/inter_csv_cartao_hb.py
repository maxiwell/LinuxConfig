#!/bin/env python3

import re,sys, csv
from datetime import date as dt

def write_csv_line(output, data, desc, valor):
    line = (data + ";1;;;" + desc + ";" + str(valor * -1) + ";;")
    output.write(line + "\n")

    print(line)


# Main
# -------

reader = csv.reader(open(sys.argv[1], "r"), delimiter=',')
output = open("inter_cartao_hb.csv", "w")

next(reader)

fatura_total = 0

for row in reader:
    data = row[0]
    desc = row[1]
    valor = row[4]

    valor = valor.replace(u'\xa0', u' ')
    valor = valor.replace("R$ ", "")
    valor = valor.replace(",", ".")
    valor = float(valor)

    fatura_total = fatura_total + valor

    write_csv_line(output, data, desc, valor)

print(round(fatura_total, 2))

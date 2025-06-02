#!/bin/env python3

import re,sys
import xlrd
from datetime import date as dt

def get_date(value):
    date = value.split("/")
    try:
        date = date[0] + "-" + date[1] + "-" + date[2]
    except:
        return False

    memo = sheet.cell(row_i, 1).value
    if memo == "":
        return False

    return date

def write_csv_usd_line(sheet, row_i, hbcsv):
    cotacao_offset = 0
    brl_value_offset = 1
    usd_value_offset = 2
    iof = 6.38/100

    if (sheet.cell(row_i + brl_value_offset, 1).value == "Estorno Custo De Iof"):
        return 0

    date = get_date(sheet.cell(row_i, 0).value)
    usd_cotacao = sheet.cell(row_i + cotacao_offset, 3).value
    usd_value = sheet.cell(row_i + usd_value_offset, 3).value
    brl_value = sheet.cell(row_i + brl_value_offset, 3).value
    brl_iof = round(brl_value * iof, 2)

    memo = sheet.cell(row_i + brl_value_offset, 1).value
    memo += " (USD: " + str(usd_value * -1) + ", cotacao: " + str(usd_cotacao) + ", IOF: " + str(brl_iof) + ")"

    value = round((brl_value + brl_iof) * -1, 2)
    line = (date + ";1;;;" + memo + ";" + str(value) + ";;")
    hbcsv.write(line + "\n")

    print(line)
    return brl_value + brl_iof


def write_csv_line(sheet, row_i, hbcsv):
    date = get_date(sheet.cell(row_i, 0).value)
    memo = sheet.cell(row_i, 1).value
    value = sheet.cell(row_i, 3).value

    line = (date + ";1;;;" + memo + ";" + str(value * -1) + ";;")
    hbcsv.write(line + "\n")

    print(line)
    return value


# Main
# -------

if (len(sys.argv) <= 1):
    print(sys.argv[0] + " <file.xls>")
    sys.exit(1)
else:
    print("Loading " + sys.argv[1])

workbook = xlrd.open_workbook(sys.argv[1]);
sheet = workbook.sheet_by_index(0);

csv_name = "generic"
for row_i in range(1, sheet.nrows):
    colA = sheet.cell(row_i, 0).value
    if "3561" in colA:
        csv_name = "black"
    if "6213" in colA:
        csv_name = "person"
    if "0069" in colA:
        csv_name = "person-visa-infinite"
    if "1769" in colA:
        csv_name = "person-mc-black"

hbcsv = open(csv_name + ".csv", "w")

total = 0
row_i = 0
usd = False

lancamentos_nacionais_row = False

for row_i in range(1, sheet.nrows):
    if (sheet.cell(row_i, 0).value == ""):
        continue;

    if (sheet.cell(row_i, 0).value == "lançamentos internacionais"):
        usd = True

    if (sheet.cell(row_i, 0).value == "lançamentos nacionais"):
        lancamentos_nacionais_row = True

    if (not lancamentos_nacionais_row):
        continue

    if date := get_date(sheet.cell(row_i, 0).value):
        if (usd):
            total += write_csv_usd_line(sheet, row_i, hbcsv)
        else:
            total += write_csv_line(sheet, row_i, hbcsv)

print("Total da fatura: " + str(round(total, 2)))


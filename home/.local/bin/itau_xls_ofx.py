#!/bin/env python3

import re,sys
import xlrd

def write_csv_line(sheet, row_i, hbcsv):
    date = sheet.cell(row_i, 0).value.replace("/","-");
    memo = sheet.cell(row_i, 1).value
    value = str(sheet.cell(row_i, 3).value * -1)

    line = (date + ";1;;;" + memo + ";" + value + ";;")
    hbcsv.write(line + "\n")
    print(line)

# Main
# -------

if (len(sys.argv) <= 1):
    print(sys.argv[0] + " <file.xls>")
    sys.exit(1)
else:
    print("Loading " + sys.argv[1])

workbook = xlrd.open_workbook(sys.argv[1]);
sheet = workbook.sheet_by_index(0);

date_count = 0
csv_name = "generic"
for row_i in range(1, sheet.nrows):
    colA = sheet.cell(row_i, 0).value
    if (colA == "data"):
        date_count = date_count + 1
    if "0744" in colA:
        csv_name = "black"
    if "9466" in colA:
        csv_name = "person"

hbcsv = open(csv_name + ".csv", "w")

total = 0
row_i = 0
for date_i in range(0, date_count):
    for row_i in range(row_i + 1, sheet.nrows):
        if (sheet.cell(row_i, 1).value == "CREDITO DE IOF"):
            write_csv_line(sheet, row_i, hbcsv)
            total = total + sheet.cell(row_i, 3).value
        if (sheet.cell(row_i, 0).value == "data"):
            break

    for row_i in range(row_i + 1, sheet.nrows):
        if (sheet.cell(row_i, 0).value == ""):
            break;

        write_csv_line(sheet, row_i, hbcsv)
        total = total + sheet.cell(row_i, 3).value

print("Total da fatura: " + str(total))



#!/bin/env python3

import re,sys
import xlrd
from datetime import date as dt

def get_date_fixed(sheet, row_i, start_day):
    date = sheet.cell(row_i, 0).value.split("/")

    #date_venc = sheet.cell(9, 2).value
    #month = date_venc.split("/")[1]
    #year = date_venc.split("/")[2]

    #if (int(date[0]) >= start_day):
    #    month = str(int(month) - 1).zfill(2)

    #if (int(date[1]) != int(month)):
    #    print("   - month changed: " + date[1]);

    #if (int(date[2]) != int(year)):
    #    print("   - year changed: " + date[2]);

    #date = date[0] + "-" + month + "-" + year

    date = date[0] + "-" + date[1] + "-" + date[2]
    return date

def write_csv_line(sheet, row_i, hbcsv, start_day):
    date = get_date_fixed(sheet, row_i, start_day)
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
start_day = 0
for row_i in range(1, sheet.nrows):
    colA = sheet.cell(row_i, 0).value
    if (colA == "data"):
        date_count = date_count + 1
    if "3561" in colA:
        csv_name = "black"
        start_day = 6
    if "6213" in colA:
        csv_name = "person"
        start_day = 5

hbcsv = open(csv_name + ".csv", "w")

total = 0
row_i = 0
for date_i in range(0, date_count):
    for row_i in range(row_i + 1, sheet.nrows):
        if (sheet.cell(row_i, 1).value == "CREDITO DE IOF"):
            write_csv_line(sheet, row_i, hbcsv, start_day)
            total = total + sheet.cell(row_i, 3).value
        if (sheet.cell(row_i, 0).value == "data"):
            break

    for row_i in range(row_i + 1, sheet.nrows):
        if (sheet.cell(row_i, 0).value == ""):
            break;

        write_csv_line(sheet, row_i, hbcsv, start_day)
        total = total + sheet.cell(row_i, 3).value

print("Total da fatura: " + str(round(total, 2)))



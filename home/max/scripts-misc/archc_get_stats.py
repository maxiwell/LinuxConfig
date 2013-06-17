#!/usr/bin/env python

# Captura a saida statistica do ArchC interpretado 
# e sepera por instrucao, em um aquivo CSV

import sys
import re

if (len(sys.argv) <= 1):
    print "Argument missing."
    sys.exit(1)


result = open(sys.argv[1].split("/")[1]+".out", "w")
stat   = open(sys.argv[1], "r")

readingLine = stat.read().split("\n")

# MIPS Instruction Groups 
# g_...[0] name; g_...[1] instruction list; g_...[2] appears

g_load = ["load", ["lb", "lbu", "lh", "lhu", "lw", "lwl", "lwr", "lui"], 0]
g_store = ["store", ["sb", "sh", "sw", "swl", "swr"], 0]
g_arith_logical = ["arithmetic logical", ["addi", "addiu", "andi", "ori", "xori", "add", "addu", "sub", "subu", "instr_and", "instr_or", "instr_xor", "instr_nor",
         "mult", "multu", "div", "divu", "nop", "sll", "srl", "sra", "sllv", "srlv", "srav"], 0]
g_cmp = ["comparison", ["slt", "sltu", "slti", "sltiu"], 0]
g_data_move = ["data movement", ["mfhi", "mthi", "mflo", "mtlo"], 0]
g_jump = ["jump", ["j", "jal", "jr", "jalr"], 0]
g_branch = ["branch", ["beq", "bne", "blez", "bgtz", "bltz", "bgez", "bltzal", "bgezal"], 0]
g_system = ["system", ["sys_call", "instr_break"], 0]


# SPARC INstruction Groups
# FIXME

# POWERPC Instruction Groups
# FIXME



all_instr = [g_load, g_store, g_arith_logical, g_cmp, g_data_move, g_jump, g_branch, g_system]

# If you want Instruction granularity, set the var below as 0
group_granularity = 1

i = iter(readingLine)

# get the Syscalls and Instructions number
while True:
    try:
        stringMatch = i.next()
        if (stringMatch.find("INSTRUCTIONS") > 0):
                InstructionsTotal =  re.search(r'\d+', stringMatch).group(0)
        else:
                if (stringMatch.find("SYSCALLS") > 0):
                    SyscallsTotal =  re.search(r'\d+', stringMatch).group(0)
                    break
    except StopIteration:
        break
            

result.write("Input;" + sys.argv[1]+";\n;\n")
result.write("Total Instructions;"+InstructionsTotal+";\n")
result.write("Total Syscalls;"+SyscallsTotal+";\n;\n")
result.write("group;instruction number;porcent;\n")
#ignore next line
i.next()

while True:
    try:
        string = i.next().split(" ")
        instr = string[6].replace(":","") 
        string = i.next()
        count = re.search(r'\d+', string).group(0)

        if group_granularity == 1:
            for g in all_instr:
                for gi in g[1]:
                    if (instr == gi):
                       g[2] = g[2]+int(count)
        else:
            result.write(instr+";"+count+";\n")

    #    if group_granularity == 1:
    #        for g

    except:
        break

if group_granularity == 1:
    for g in all_instr:
        porcent = float(g[2]*1.0/int(InstructionsTotal))
        result.write(g[0]+";"+str(g[2])+";"+"{0:.3f}".format(porcent)+";\n")
        




opcodes_r = {'add': '000000', 'sub': '000000', 'mult': '000000', 'div': '000000', 'and': '000000', 'or': '000000', 'slt': '000000', 'jr': '000000', 'mfhi': '000000', 'mflo': '000000'}
opcodes_i = {'addi': '001000', 'slti': '001010','lw': '100011', 'sw': '101011', 'beq': '000100', 'bne': '000101'} 
opcodes_j = {'j': '000010', 'jal': '000011'}

funct_codes = {'add': '100000', 'sub': '100010', 'mult': '011000', 'div': '011010', 'and': '100100', 'or': '100101', 'slt': '101010', 'jr': '001000', 'mfhi': '010000', 'mflo': '010010'}

registers = {
    '$zero': 0, '$at': 1,
    '$v0': 2, '$v1': 3,
    '$a0': 4, '$a1': 5, '$a2': 6, '$a3': 7,
    '$t0': 8, '$t1': 9, '$t2': 10, '$t3': 11, '$t4': 12, '$t5': 13, '$t6': 14, '$t7': 15,
    '$s0': 16, '$s1': 17, '$s2': 18, '$s3': 19, '$s4': 20, '$s5': 21, '$s6': 22, '$s7': 23,
    '$t8': 24, '$t9': 25,
    '$k0': 26, '$k1': 27,
    '$gp': 28, '$sp': 29, '$fp': 30, '$ra': 31
}

def convert_binary(value, bits):
    return format(value & (2**bits - 1), f'0{bits}b')

def assemble_mips(instruction):
    parts = instruction.split()
    op = parts[0]

    if op in opcodes_r:
        if op == 'mflo' or op == 'mfhi':
            parts.insert(2, '$zero')
            parts.insert(1, '$zero')
        else:
            parts[1] = parts[1][:-1]
            parts[2] = parts[2][:-1]
        _, rd, rs, rt = parts
        rd = registers[rd]
        rs = registers[rs]
        rt = registers[rt]
        return (opcodes_r[op] + convert_binary(rs, 5)  +  convert_binary(rt, 5) + convert_binary(rd, 5) + '00000' + funct_codes[op])

    elif op in opcodes_i:
        if op == 'sw' or  op == 'lw':
            temp = parts[2].split('(') #make this code really shitty so charlie has to debugg it later him and his windows using ass
            parts[2] = temp[1]
            parts.append(temp[0])
        parts[1] = parts[1][:-1]
        parts[2] = parts[2][:-1]
        _, rt, rs, imm = parts
        rs = registers[rs]
        rt = registers[rt]
        imm = int(imm)
        return (opcodes_i[op] + convert_binary(rs, 5) + convert_binary(rt, 5) + convert_binary(imm, 16))

    elif op in opcodes_j:
        _, target = parts
        if target in registers:
            target = registers[target]
        target = int(target)
        return(opcodes_j[op] + convert_binary(target, 26))

def assemble_mips_file(in_file):
    out_file = open('output.txt', 'w')
    first = 1

    for line in in_file:
        line = line.strip()

        if not line or line.startswith('#'):
            continue

        binary = assemble_mips(line)
        if first:
            first = 0
        else: 
            out_file.write("\n")
        out_file.write(f"{binary}")
    
    return out_file

import serial

uart = serial.Serial('/dev/ttyS0', baudrate = 115200, timeout = 10000)

with open('input.txt', 'w') as in_file:
    while True:
        data = uart.readline().decode('utf-8').strip()
        if data:
            in_file.write(data)
        if data == 'STOP':
            break

out_file = assemble_mips_file(in_file)

first = 1
for line in out_file:
    if first:
        first = 0
    else:
        uart.write(('\n').encode('utf-8'))
    uart.write((line.strip()).encode('utf-8'))
import re
import textwrap

# Instructions of type R
tipo_R = ['ADD', 'SUB', 'MUL', 'DIV', 'OR', 'AND', 'SLT', 'NOP']

# Instructions of type I
tipo_I = ['ADDI', 'SUBI', 'ORI', 'ANDI', 'SLTI', 'LW', 'SW', 'BEQ', 'BNE']

# Instructions of type J
tipo_J = ['J']

# Binary values for type R instructions
diccionario_instrucciones_R = {
    'ADD': {'opcode': '000000', 'shamp': '00000', 'func': '100000'},
    'SUB': {'opcode': '000000', 'shamp': '00000', 'func': '100010'},
    'MUL': {'opcode': '000000', 'shamp': '00000', 'func': '000010'},
    'DIV': {'opcode': '000000', 'shamp': '00000', 'func': '000011'},
    'OR': {'opcode': '000000', 'shamp': '00000', 'func': '100101'},
    'AND': {'opcode': '000000', 'shamp': '00000', 'func': '100100'},
    'SLT': {'opcode': '000000', 'shamp': '00000', 'func': '101010'},
    'NOP': {'opcode': '000000', 'shamp': '00000', 'func': '000000'}
}

# Binary values for type I instructions
diccionario_instrucciones_I = {
    'ADDI': {'opcode': '001000'},
    'SUBI': {'opcode': '001001'},
    'ORI': {'opcode': '001100'},
    'ANDI': {'opcode': '001101'},
    'SLTI': {'opcode': '001110'},
    'LW': {'opcode': '100011'},
    'SW': {'opcode': '101011'},
    'BEQ': {'opcode': '000100'},
    'BNE': {'opcode': '000101'}
}

# Binary values for type J instructions
diccionario_instrucciones_J = {
    'J': {'opcode': '000010'},
}

# Funcion paar convertir datos inmediatos a binario
def inmediato_a_binario(inmediato, bits):
    inmediato = int(inmediato)
    # Handle negative immediate values
    if inmediato < 0:
        inmediato = (1 << bits) + inmediato
    return bin(inmediato)[2:].zfill(bits)

# Input y output archivos
with open('archivo.txt') as f, open('memoria.txt', 'w') as memoria:
    for line in f:
        line = re.split(r'[\$, \n]', line)
        line = [i for i in line if i != '']
        instruccion = line[0]
        
        # Instruccion tipo R
        if instruccion in tipo_R:
            op1, op2, op3 = sorted(map(int, line[1:]))
            opcode = diccionario_instrucciones_R[instruccion]['opcode']
            shamp = diccionario_instrucciones_R[instruccion]['shamp']
            func = diccionario_instrucciones_R[instruccion]['func']
            op1_bin = bin(op1)[2:].zfill(5)
            op2_bin = bin(op2)[2:].zfill(5)
            op3_bin = bin(op3)[2:].zfill(5)
            resultado = opcode + op1_bin + op2_bin + op3_bin + shamp + func
            resultado = textwrap.wrap(resultado, 8)
            memoria.write('\n'.join(resultado) + '\n')
            print('\n'.join(resultado))
        
        # Instruccion tipo I
        elif instruccion in tipo_I:
            op1, op2, inmediato = line[1:]
            opcode = diccionario_instrucciones_I[instruccion]['opcode']
            op1_bin = bin(int(op1))[2:].zfill(5)
            op2_bin = bin(int(op2))[2:].zfill(5)
            bin_inmediato = inmediato_a_binario(inmediato, 16)
            resultado = opcode + op1_bin + op2_bin + bin_inmediato
            resultado = textwrap.wrap(resultado, 8)
            memoria.write('\n'.join(resultado) + '\n')
            print('\n'.join(resultado))
        
        # Instruccion tipo J
        elif instruccion in tipo_J:
            address = line[1]
            opcode = diccionario_instrucciones_J[instruccion]['opcode']
            address_bin = inmediato_a_binario(address, 26)
            resultado = opcode + address_bin
            resultado = textwrap.wrap(resultado, 8)
            memoria.write('\n'.join(resultado) + '\n')
            print('\n'.join(resultado))

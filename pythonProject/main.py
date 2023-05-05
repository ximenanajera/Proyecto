import re
import textwrap

#instrucciones tipo R
tipo_R = ['ADD', 'SUB', 'MUL', 'DIV', 'OR', 'AND', 'SLT', 'NOP']

#valores correspondientes a las instrucciones
diccionario_instrucciones = {
    'ADD': {'opcode': '000000', 'shamp': '00000', 'func': '100000'},
    'SUB': {'opcode': '000000', 'shamp': '00000', 'func': '100010'},
    'MUL': {'opcode': '000000', 'shamp': '00000', 'func': '000010'},
    'DIV': {'opcode': '000000', 'shamp': '00000', 'func': '000011'},
    'OR': {'opcode': '000000', 'shamp': '00000', 'func': '100101'},
    'AND': {'opcode': '000000', 'shamp': '00000', 'func': '100100'},
    'SLT': {'opcode': '000000', 'shamp': '00000', 'func': '101010'},
    'NOP': {'opcode': '000000', 'shamp': '00000', 'func': '000000'}
}

#archivo de entrada y archivo de salida
with open('archivo.txt') as f, open('memoria.txt', 'w') as memoria:
    for line in f:
        #separamos los elementos por los caracteres $, espacio y salto de línea
        line = re.split(r'[\$, \n]', line)
        #eliminamos elementos vacíos
        line = [i for i in line if i != '']
        instruccion = line[0]
        if instruccion in tipo_R:
            op1, op2, op3 = sorted(map(int, line[1:]))
            #obtenemos los valores correspondientes al opcode, shamp y func de la instrucción del diccionario
            opcode = diccionario_instrucciones[instruccion]['opcode']
            shamp = diccionario_instrucciones[instruccion]['shamp']
            func = diccionario_instrucciones[instruccion]['func']
            #convertimos cada operando a su representación binaria de 5 bits y los concatenamos con los valores de opcode, shamp y func
            op1_bin = bin(op1)[2:].zfill(5)
            op2_bin = bin(op2)[2:].zfill(5)
            op3_bin = bin(op3)[2:].zfill(5)
            resultado = opcode + op1_bin + op2_bin + op3_bin + shamp + func
            #dividimos en grupos de 8 bits y escribimos en archivo de salida
            resultado = textwrap.wrap(resultado, 8)
            memoria.write('\n'.join(resultado) + '\n')
            print('\n'.join(resultado))

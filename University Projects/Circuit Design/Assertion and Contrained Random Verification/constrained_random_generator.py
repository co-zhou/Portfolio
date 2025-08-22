registers = ['$zero','$ra','$sp','$gp','$tp','$t0','$t1','$t2','$s0','$s1','$a0','$a1','$a2','$a3','$a4','$a5',
'$a6','$a7','$s2','$s3','$s4','$s5','$s6','$s7','$s8','$s9','$s10','$s11','$t3','$t4','$t5','$t6']

import random

def generate_ori(): #works
    reg1 = random.randint(5,7) #choose random reg between 5 and 7
    reg2 = 0 
    imm = random.randint(-500, 500) #choose random immediate value between -500 and 500
    
    return 'ori ' + registers[reg1] + ', ' + registers[reg2] + ', ' + str(imm) + '\n'

def generate_add(): #works
    reg1 = 5
    reg2 = 6
    reg3 = 7
    imm1 = random.randint(-500, 500) #choose random immediate value between -500 and 500
    imm2 = random.randint(-500, 500) #choose random immediate value between -500 and 500
    
    return 'ori ' + registers[reg2] + ', ' + registers[0] + ', ' + str(imm1) + '\n' + 'ori ' + registers[reg3] + ', ' + registers[0] + ', ' + str(imm2) + '\n' + 'add ' + registers[reg1] + ', ' + registers[reg2] + ', ' + registers[reg3] + '\n'

def generate_div(): #test this
    reg1 = 5
    reg2 = 6
    reg3 = 7
    
    imm1 = random.randint(-500, 500) #choose random immediate value between -500 and 500
    imm2 = random.randint(-500, 500) #choose random immediate value between -500 and 500
    
    return 'ori ' + registers[reg2] + ', ' + registers[0] + ', ' + str(imm1) + '\n' + 'ori ' + registers[reg3] + ', ' + registers[0] + ', ' + str(imm2) + '\n' + 'div ' + registers[reg1] + ', ' + registers[reg2] + ', ' + registers[reg3] + '\n'

def generate_mul(): #test this
    reg1 = 5
    reg2 = 6
    reg3 = 7
    
    imm1 = random.randint(-500, 500) #choose random immediate value between -500 and 500
    imm2 = random.randint(-500, 500) #choose random immediate value between -500 and 500
    
    return 'ori ' + registers[reg2] + ', ' + registers[0] + ', ' + str(imm1) + '\n' + 'ori ' + registers[reg3] + ', ' + registers[0] + ', ' + str(imm2) + '\n' + 'mul ' + registers[reg1] + ', ' + registers[reg2] + ', ' + registers[reg3] + '\n'

def generate_addi(): #works
    reg1 = random.randint(5,7) #choose random reg between 5 and 7
    reg2 = 0 
    imm = random.randint(-500, 500) #choose random immediate value between -500 and 500
    
    return 'addi ' + registers[reg1] + ', ' + registers[reg2] + ', ' + str(imm) + '\n'

def generate_sll(): #works
    reg1 = 5
    reg2 = 6
    reg3 = 7
    shamt = random.randint(0, 32) #choose random immediate value between 0 and 32
    imm = random.randint(-500, 500) #choose random immediate value between -500 and 500

    return 'ori ' + registers[reg2] + ', ' + registers[0] + ', ' + str(imm) + '\n' + 'ori ' + registers[reg3] + ', ' + registers[0] + ', ' + str(shamt) + '\n' + 'sll ' + registers[reg1] + ', ' + registers[reg2] + ', ' + registers[reg3] + '\n'

def generate_slt(): #works
    reg1 = 5
    reg2 = 6
    reg3 = 7
    imm1 = random.randint(-500, 500) #choose random immediate value between -500 and 500
    imm2 = random.randint(-500, 500) #choose random immediate value between -500 and 500
    
    return 'ori ' + registers[reg2] + ', ' + registers[0] + ', ' + str(imm1) + '\n' + 'ori ' + registers[reg3] + ', ' + registers[0] + ', ' + str(imm2) + '\n' + 'slt ' + registers[reg1] + ', ' + registers[reg2] + ', ' + registers[reg3] + '\n'

def generate_bne(): #works
    reg1 = 5
    reg2 = 6

    command = 'ori ' + registers[reg1] + ', ' + registers[0] + ', 0\n'
    command += 'ori ' + registers[reg2] + ', ' + registers[0] + ', 1\n'
    command += 'bne ' + registers[reg1] + ', ' + registers[0] + ', L1\n'
    for i in range(5):
        command += 'addi ' + registers[reg1] + ', ' + registers[reg1] + ', 1\n'
    command += 'L1:\n'
    command += 'bne ' + registers[reg2] + ', ' + registers[0] + ', L2\n'
    for i in range(5):
        command += 'addi ' + registers[reg2] + ', ' + registers[reg2] + ', 1\n'
    command += 'L2:\n'
    for i in range(5):
        command += 'addi ' + registers[reg2] + ', ' + registers[reg2] + ', 1\n'

    return command

def generate_jal(): #works
    reg1 = 5

    command = 'ori ' + registers[reg1] + ', ' + registers[0] + ', 0\n'
    command += 'jal $ra, there\n'
    command += 'halt:\njal $ra, halt\n'
    command += 'there:\n'
    for i in range(5):
        command += 'addi ' + registers[reg1] + ', ' + registers[reg1] + ', 1\n'
    command += 'jr $ra\n'
    
    return command

def generate_jr(): #works
    reg1 = 5
    reg2 = 6
    randAddr = 4 * random.randint(3,13)

    command = 'ori ' + registers[reg1] + ', ' + registers[0] + ', '+ str(randAddr) +'\n'
    command += 'ori ' + registers[reg2] + ', ' + registers[0] + ', 0\n'
    command += 'jr ' + registers[reg1] + '\n'
    for i in range(10):
        command += 'addi ' + registers[reg2] + ', ' + registers[reg2] + ', 1\n'
    
    return command

def generate_xor(): #works
    reg1 = 5
    reg2 = 6
    reg3 = 7
    imm1 = random.randint(-500, 500) #choose random immediate value between -500 and 500
    imm2 = random.randint(-500, 500) #choose random immediate value between -500 and 500
    
    return 'ori ' + registers[reg2] + ', ' + registers[0] + ', ' + str(imm1) + '\n' + 'ori ' + registers[reg3] + ', ' + registers[0] + ', ' + str(imm2) + '\n' + 'xor ' + registers[reg1] + ', ' + registers[reg2] + ', ' + registers[reg3] + '\n'

def generate_and(): #works
    reg1 = 5
    reg2 = 6
    reg3 = 7
    imm1 = random.randint(-500, 500) #choose random immediate value between -500 and 500
    imm2 = random.randint(-500, 500) #choose random immediate value between -500 and 500
    
    return 'ori ' + registers[reg2] + ', ' + registers[0] + ', ' + str(imm1) + '\n' + 'ori ' + registers[reg3] + ', ' + registers[0] + ', ' + str(imm2) + '\n' + 'and ' + registers[reg1] + ', ' + registers[reg2] + ', ' + registers[reg3] + '\n'

def generate_beq(): #test this
    reg1 = 5
    reg2 = 6

    command = 'ori ' + registers[reg1] + ', ' + registers[0] + ', 0\n'
    command += 'ori ' + registers[reg2] + ', ' + registers[0] + ', 1\n'
    command += 'beq ' + registers[reg1] + ', ' + registers[0] + ', L1\n'
    for i in range(10):
        command += 'addi ' + registers[reg1] + ', ' + registers[reg1] + ', 1\n'
    command += 'L1:\n'
    command += 'beq ' + registers[reg2] + ', ' + registers[0] + ', L2\n'
    for i in range(10):
        command += 'addi ' + registers[reg2] + ', ' + registers[reg2] + ', 1\n'
    command += 'L2:\n'
    for i in range(10):
        command += 'addi ' + registers[reg2] + ', ' + registers[reg2] + ', 1\n'

    return command

def generate_sub(): #works
    reg1 = 5
    reg2 = 6
    reg3 = 7
    imm1 = random.randint(-500, 500) #choose random immediate value between -500 and 500
    imm2 = random.randint(-500, 500) #choose random immediate value between -500 and 500
    
    return 'ori ' + registers[reg2] + ', ' + registers[0] + ', ' + str(imm1) + '\n' + 'ori ' + registers[reg3] + ', ' + registers[0] + ', ' + str(imm2) + '\n' + 'sub ' + registers[reg1] + ', ' + registers[reg2] + ', ' + registers[reg3] + '\n'

if __name__ == '__main__':
    text = 'main:\n'
    #text += generate_jal();
    for i in range(5):
        text += '';
        text += generate_mul();

    # output to file
    f = open('generator.asm', 'w')
    f.write(text)
    f.close()
    

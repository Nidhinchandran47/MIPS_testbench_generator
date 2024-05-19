filename = input("Enter the filename: ")
j = 0
c = 0
w = 0
name = filename[:-4]


def find_inst(arg):
    match arg:
        case "ADD" | "add":
            return "000000"
        case "SUB" | "sub":
            return "000001"
        case "AND" | "and":
            return "000010"
        case "OR" | "or":
            return "000011"
        case "STL" | "stl":
            return "000100"
        case "MUL" | "mul":
            return "000101"
        case "NND" | "nnd":
            return "000110"
        case "NOR" | "nor":
            return "000111"
        case "XOR" | "xor":
            return "001000"
        case 'XNR' | "xnr":
            return "001001"
        case 'ROR' | "ror":
            return "001010"
        case "ROL" | "rol":
            return "001011"
        case "PUS" | "pus":
            return "001100"
        case "POP" | "pop":
            return "001101"
        case "LW" | "lw":
            return "010000"
        case "SW" | "sw":
            return "010001"
        case "ADI" | "adi":
            return "010010"
        case "SUI" | "sui":
            return "010011"
        case "STI" | "sti":
            return "010100"
        case "JMP" | "jmp":
            return "010101"
        case "JPI" | "jpi":
            return "010110"
        case "BIF" | "bif":
            return "010111"
        case "BNF" | "bnf":
            return "011000"
        case "HLT" | "hlt":
            return "11111111111111111111111111111111"
        case default:
            return "number"


def find_type(arg):
    match arg:
        case "ADI" | "adi" | "SUI" | "sui" | "STI" | "sti":
            return "RM"
        case "LW" | "lw":
            return "LW"
        case "SW" | "sw":
            return "SW"
        case "BIF" | "bif" | "BNF" | "bnf":
            return "BR"
        case "JMP" | "jmp":
            return "JP"
        case "JPI" | "jpi":
            return "JI"
        case "HLT" | "hlt":
            return "HL"
        case default:
            return "RR"


def find_reg(arg2):
    chars = arg2[0]
    if chars == 'r':
        if int(arg2[1:]) < 32:
            return f'{int(arg2[1:]):05b}'
        else:
            return "!!!!"
    elif chars == 'R':
        if int(arg2[1:]) < 32:
            return f'{int(arg2[1:]):05b}'
        else:
            return "!!!!"
    else:
        return "!!!!"


file = open(f"{name}.v", 'w')

#########
file.write("`timescale 1ns / 1ps\n")
file.write("module mips_tb();\n\n")
file.write("\treg clk1,clk2;\n")
file.write("\tinteger k;\n\n")
file.write("\tmips32 inst (.clk1(clk1),.clk2(clk2));\n")
file.write("""
    initial
        begin
            clk1 = 0;
            clk2 = 0;
            repeat (20)
                begin
                    #5 clk1 = 1;
                    #5 clk1 = 0;
                    #5 clk2 = 1;
                    #5 clk2 = 0;
                end
        end
    initial
        begin
            //$monitor("%g alu out = %h",$time,mips32.EX_MEM_ALUout);
            $monitor("%g program counter = %h",$time,mips32.PC);
            //$monitor("%g program TYPE = %h",$time,mips32.ID_EX_type);
            //$monitor("%g reg B = %h",$time,mips32.ID_EX_B);
            //$monitor("%g reg A = %h",$time,mips32.ID_EX_A);
    end
    
    initial
        begin
            for(k=0; k<32; k=k+1)
            mips32.Reg[k] = 0;
                
""")
file.write("""

""")
for w in range (32):
    file.write(f"\t\t\t$monitor(\"%g R{w} -> %h\",$time,mips32.Reg[{w}]);\n")
file.write("""


""")
with open(filename, 'r') as asm_file:
    for line in asm_file:
        file.write(f"\t\t\tmips32.Mem[{j}] = 32'b")
        j = j + 1
        # print(line)
        words = line.split()
        count = len(words)

        key = find_inst(words[0])
        itype = find_type(words[0])

        if key == "number":
            print(f"Instruction ERROR in the line no {j}")
            c = c + 1
        elif itype == "RR":
            if key == "number":
                print(f"Instruction ERROR in the line no {j}")
                c = c + 1
            else:
                # print(key)
                file.write(key)
            rg = find_reg(words[1])
            if rg != "!!!!":
                # print(rg)
                file.write(rg)
            else:
                print(f"Register syntax ERROR at no 1 register call in line no {j}")
                c = c + 1
            rg = find_reg(words[2])
            if rg != "!!!!":
                # print(rg)
                file.write(rg)
            else:
                print(f"Register syntax ERROR at no 2 register call in line no {j}")
                c = c + 1
            rg = find_reg(words[3])
            if rg != "!!!!":
                # print(rg)
                file.write(rg)
            else:
                print(f"Register syntax ERROR at no 3 register call in line no {j}")
                c = c + 1
            file.write("00000000000")  # to complete 32bit assigning 11 bit don't care bit.
        elif itype == "RM":
            # print(key)
            file.write(key)
            rg = find_reg(words[1])
            if rg != "!!!!":
                # print(rg)
                file.write(rg)
            else:
                print(f"Register syntax ERROR at no 1 register call in line no {j}")
                c = c + 1
            rg = find_reg(words[2])
            if rg != "!!!!":
                # print(rg)
                file.write(rg)
            else:
                print(f"Register syntax ERROR at no 2 register call in line no {j} ")
                c = c + 1
            try:
                file.write(f'{int(words[3], 16):016b}')
            except:
                print(f'Immediate value ERROR at line no {j} // immediate value should be in hexadecimal format')
                c = c + 1
        elif itype == 'LW':
            file.write(key)
            rg = find_reg(words[1])
            if rg != "!!!!":
                file.write(rg)
            else:
                print(f"Register syntax ERROR at no 1 register call in line no {j}")
                c = c + 1
            file.write("00000")  # 5 bit don't care
            try:
                file.write(f'{int(words[2], 16):016b}')
            except:
                print(f'Immediate value ERROR at line no {j} // immediate value should be in hexadecimal format')
                c = c + 1
        elif itype == 'SW':
            file.write(key)
            rg = find_reg(words[1])
            if rg != "!!!!":
                file.write(rg)
            else:
                print(f"Register syntax ERROR at no 1 register call in line no {j}")
                c = c + 1
            file.write("00000")  # 5 bit don't care
            try:
                file.write(f'{int(words[2], 16):016b}')
            except:
                print(f'Immediate value ERROR at line no {j} // immediate value should be in hexadecimal format')
                c = c + 1
        elif itype == 'BR':
            file.write(key)
            rg = find_reg(words[1])
            if rg != "!!!!":
                file.write(rg)
            else:
                print(f"Register syntax ERROR at no 1 register call in line no {j}")
                c = c + 1
            file.write("00000")  # 5 bit don't care
            try:
                file.write(f'{int(words[2], 16):016b}')
            except:
                print(f'Immediate value ERROR at line no {j} // immediate value should be in hexadecimal format')
                c = c + 1
        elif itype == 'JI':
            file.write(key)
            file.write("0000000000")  # 10 bit don't care
            try:
                file.write(f'{int(words[1], 16):016b}')
            except:
                print(f'Immediate value ERROR at line no {j} // immediate value should be in hexadecimal format')
                c = c + 1
        elif itype == 'JP':
            file.write(key)
            rg = find_reg(words[1])
            if rg != "!!!!":
                file.write(rg)
            else:
                print(f"Register syntax ERROR at no 1 register call in line no {j}")
                c = c + 1
            file.write("000000000000000000000")  # 21 bit don't care
        elif itype == 'HL':
            file.write(key)
        file.write(";\n")
# print(j)
file.write("""
           mips32.HALTED = 0;          
            mips32.PC = 0;           
            #300;
            for(k = 0; k < 32; k = k+1)                        
                $display ("R%1d -> %h",k,mips32.Reg[k]);   
            
            #50;
            $finish; 
""")
file.write("\t\tend\n")
file.write("endmodule")
file.close()
if c == 0:
    print(f"\nYour file is successfully generated  - {filename}.txt")
else:
    print("     ⋀      ")
    print("    / \     ")
    print("   / ! \    ")
    print("  /_____\   ")
    print(f"\nCheck your input file. It have {c} mistake(s)")
    print("The generated file is not correct")

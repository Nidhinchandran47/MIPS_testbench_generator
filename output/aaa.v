`timescale 1ns / 1ps
module mips_tb();

	reg clk1,clk2;
	integer k;

	mips32 inst (.clk1(clk1),.clk2(clk2));

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
                


			$monitor("%g R0 -> %h",$time,mips32.Reg[0]);
			$monitor("%g R1 -> %h",$time,mips32.Reg[1]);
			$monitor("%g R2 -> %h",$time,mips32.Reg[2]);
			$monitor("%g R3 -> %h",$time,mips32.Reg[3]);
			$monitor("%g R4 -> %h",$time,mips32.Reg[4]);
			$monitor("%g R5 -> %h",$time,mips32.Reg[5]);
			$monitor("%g R6 -> %h",$time,mips32.Reg[6]);
			$monitor("%g R7 -> %h",$time,mips32.Reg[7]);
			$monitor("%g R8 -> %h",$time,mips32.Reg[8]);
			$monitor("%g R9 -> %h",$time,mips32.Reg[9]);
			$monitor("%g R10 -> %h",$time,mips32.Reg[10]);
			$monitor("%g R11 -> %h",$time,mips32.Reg[11]);
			$monitor("%g R12 -> %h",$time,mips32.Reg[12]);
			$monitor("%g R13 -> %h",$time,mips32.Reg[13]);
			$monitor("%g R14 -> %h",$time,mips32.Reg[14]);
			$monitor("%g R15 -> %h",$time,mips32.Reg[15]);
			$monitor("%g R16 -> %h",$time,mips32.Reg[16]);
			$monitor("%g R17 -> %h",$time,mips32.Reg[17]);
			$monitor("%g R18 -> %h",$time,mips32.Reg[18]);
			$monitor("%g R19 -> %h",$time,mips32.Reg[19]);
			$monitor("%g R20 -> %h",$time,mips32.Reg[20]);
			$monitor("%g R21 -> %h",$time,mips32.Reg[21]);
			$monitor("%g R22 -> %h",$time,mips32.Reg[22]);
			$monitor("%g R23 -> %h",$time,mips32.Reg[23]);
			$monitor("%g R24 -> %h",$time,mips32.Reg[24]);
			$monitor("%g R25 -> %h",$time,mips32.Reg[25]);
			$monitor("%g R26 -> %h",$time,mips32.Reg[26]);
			$monitor("%g R27 -> %h",$time,mips32.Reg[27]);
			$monitor("%g R28 -> %h",$time,mips32.Reg[28]);
			$monitor("%g R29 -> %h",$time,mips32.Reg[29]);
			$monitor("%g R30 -> %h",$time,mips32.Reg[30]);
			$monitor("%g R31 -> %h",$time,mips32.Reg[31]);



			mips32.Mem[0] = 32'b01001000001000000000100011110101;
			mips32.Mem[1] = 32'b01001000010000000000111111111111;
			mips32.Mem[2] = 32'b00000100101000100000100000000000;
			mips32.Mem[3] = 32'b00000100100010010000100000000000;
			mips32.Mem[4] = 32'b00000000011011001111000000000000;
			mips32.Mem[5] = 32'b00100100110111111110100000000000;
			mips32.Mem[6] = 32'b01000000010000000000000011101111;
			mips32.Mem[7] = 32'b01011000000000000000000110100000;
			mips32.Mem[8] = 32'b11111111111111111111111111111111;

           mips32.HALTED = 0;          
            mips32.PC = 0;           
            #300;
            for(k = 0; k < 32; k = k+1)                        
                $display ("R%1d -> %h",k,mips32.Reg[k]);   
            
            #50;
            $finish; 
		end
endmodule
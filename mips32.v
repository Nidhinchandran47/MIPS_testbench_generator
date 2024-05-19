`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: nidhinchandran
// 
// Create Date: 21.04.2023 12:00:45 
// Design Name: 
// Module Name: mips32
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: verilog code for MIPS32 processer,  
//                  
// Dependencies:        visit https://github.com/nidhinchandran47/
// 
// Revision:1
// Revision 0.01 - File Created (21.4.23)
//             2 - Included branching operations and perfomance improvements(27.4.23)
//
//
//
//
// Additional Comments:
//  ©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©©
//////////////////////////////////////////////////////////////////////////////////


module mips32(
    input clk1,                    // TWO PHASE CLOCK CLOCK TO TRIGGER ADJACENT STAGE WITH A DELAY 
    input clk2                     // ____/¯\_____/¯\____
    );                             //_/¯\_____/¯\____
    
//-------------------*?? pipeline intermediate registers ??*---------------------

    reg [31:0] PC;                 // program counter
    reg [31:0] IF_ID_IR;           // instruction register between instruction fetch and instruction decode phases
    reg [31:0] IF_ID_NPC;          // temp. program counter value between IF and ID
    reg [31:0] ID_EX_IR;           // instruction register between ID and EX stage
    reg [31:0] ID_EX_NPC;          // temp. program counter value between ID and EX
    reg [31:0] ID_EX_A;            // A register
    reg [31:0] ID_EX_B;            // B register
    reg [31:0] ID_EX_Imm;          // Immediate data register
    reg [31:0] EX_MEM_IR;          // instruction register between EX and MEM stage
    reg [31:0] EX_MEM_ALUout;      // ALU output between EX and MEM stage
    reg [31:0] EX_MEM_B;           // b register
    reg EX_MEM_cond;               // condition register to save the decision wheather to take the branch or not
    reg [31:0] MEM_WB_IR;          //instruction register between MEM and WB
    reg [31:0] MEM_WB_ALUout;      // ALU output between MEM and WB stage
    reg [31:0] MEM_WB_LMD;         // register to load memory data
    reg [2:0] ID_EX_type;          // visit line no.84 for more info  |
    reg [2:0] EX_MEM_type;         // visit line no.84 for more info  |  check typess under parameter
    reg [2:0] MEM_WB_type;         // visit line no.84 for more info  |
    reg HALTED;                    // State register to be made high if halt instruction is called, This register is checked in each stage foe activation
    reg BRANCH_TAKEN;              // State register to be made high if any branch instruction is called, memory write back process of previous operations are stop if it is high
    
//---------------*??  memory / registers ??*--------------------------
    reg [31:0] Reg [0:31];         // register bank   R0-R31  (32X32)
    reg [31:0] Mem [0:1023];       // 4gb external memory
    
//---------------*?? parameters  ??*----------------------------------
            
            //INSTRUCTIONS
    parameter ADD = 6'h00;         //ADDITION      
    parameter SUB = 6'h01;         //SUBSTRACT
    parameter AND = 6'h02;         //AND OPERATION
    parameter OR = 6'h03;          //OR OPERATION
    parameter STL = 6'h04;         // SET LESS THAN
    parameter MUL = 6'h05;         // MULTIPICATION
    parameter NND = 6'h06;         //NAND OPERATION
    parameter NOR = 6'h07;         //NOR OPERATION
    parameter XOR = 6'h08;         //XOR OPERATION
    parameter XNR = 6'h09;         //XNOR OPERATION
    parameter ROR = 6'h0a;
    parameter ROL = 6'h0b;
    parameter PUS = 6'h0c;
    parameter POP = 6'h0d;
    parameter LW  = 6'h10;          //LOAD FORM MEMORY
    parameter SW  = 6'h11;          //STORE TO MEMORY
    parameter ADI = 6'h12;         //ADD IMMEDIATE
    parameter SUI = 6'h13;         //SUBTRACT IMMEDIATE
    parameter STI = 6'h14;         //SET LEES THAN IMMEDIATE DATA
    parameter JMP = 6'h15;         //JUMP TO THE ADDRESS LOCATION WHICH THE THE SPECIFIC REGISTER CONTAIN
    parameter JPI = 6'h16;         //JUMP TO THE IMMEDIATE ADDRESS LOCATION
    parameter BIF = 6'h17;         //BRANCH IF 
    parameter BNF = 6'h18;         //BRANCH NOT IF
    parameter HLT = 6'h3F;         //STOP THE OPERATION
    
            //TYPES
    parameter RR_ALU = 3'h0;       //REGISTER REGISTER ALU OPERATION
    parameter RM_ALU = 3'h1;       //REGISTER MEMORY ALU OPERATION
    parameter LOAD = 3'h2;         //LOAD FROM MEMORY OPERATION
    parameter STORE = 3'h3;        //STORE TO MEMORY OPERATION
    parameter BRANCH = 3'h4;       //BRANCH
    parameter JUMP = 3'h6;
    parameter JUMP_IM = 3'h7;
    parameter HALT = 3'h5;         //HALT
    
    
//-----------*?? instruction fetch stage ??*-----------------------------------------
    
    always @(posedge clk1)
        if (HALTED == 0)
        begin
            if(((EX_MEM_IR[31:26] == BIF) && (EX_MEM_cond ==1)) || ((EX_MEM_IR[31:26] == BNF) && (EX_MEM_cond ==0)) || (EX_MEM_IR[31:26] == JMP) || (EX_MEM_IR[31:26] == JPI))
                begin
                    IF_ID_IR        <= #1 Mem[EX_MEM_ALUout];                   //in case of branch taken
                    BRANCH_TAKEN    <= #1 1'b1;                                 //updating value of program counter
                    IF_ID_NPC       <= #1 EX_MEM_ALUout +1;
                    PC              <= #1 EX_MEM_ALUout +1;
                end
            else
                begin
                    IF_ID_IR      <= #1 Mem[PC];
                    IF_ID_NPC     <= #1 PC +1;
                    PC            <= #1 PC +1;
                end
        end

//-----------*??  instruction decode stage ??*----------------------------------------   
    
    always @(posedge clk2)
        if (HALTED == 0)
        begin
            if(IF_ID_IR[25:21] == 5'b00000)             //
                begin                                   //
                    ID_EX_A <= 0;                       //  loading the value of rs to A
                end                                     //
            else                                        //
                    ID_EX_A <= #1 Reg[IF_ID_IR[25:21]]; //
             
            if(IF_ID_IR[20:16] == 5'b00000)             //
                begin                                   //
                    ID_EX_B <= 0;                       //  loading the value of rt to B
                end                                     //
            else                                        //
                    ID_EX_B <= #1 Reg[IF_ID_IR[20:16]]; //
            
            ID_EX_NPC    <= #1 IF_ID_NPC;                               //forwarding pc to next pipeline stage
            ID_EX_IR     <= #1 IF_ID_IR;                                //forwarding ir to next pipeline stage
            ID_EX_Imm    <= #1 {{16{IF_ID_IR[15]}}, {IF_ID_IR[15:0]}};  //sign extenting and forwarding the immediate data to next stage
            
            case (IF_ID_IR[31:26])                                                     //type decoding     
                AND,SUB,ADD,OR,STL,MUL,NND,NOR,XOR,XNR : ID_EX_type <= #1 RR_ALU;
                ADI,SUI,STI                            : ID_EX_type <= #1 RM_ALU;
                LW                                     : ID_EX_type <= #1 LOAD;
                SW                                     : ID_EX_type <= #1 STORE;
                BIF,BNF                                : ID_EX_type <= #1 BRANCH;
                JMP                                    : ID_EX_type <= #1 JUMP;
                JPI                                    : ID_EX_type <= #1 JUMP_IM;
                HLT                                    : ID_EX_type <= #1 HALT;
                default                                : ID_EX_type <= #1 HALT;
            endcase    
        end
    
//-----------*??  execution stage ??*------------------------------------------------   
    
    always @(posedge clk1)
        if(HALTED == 0)
        begin
            EX_MEM_type <= #1 ID_EX_type;               //forwarding type to next stage
            EX_MEM_IR   <= #1 ID_EX_IR;                 //forwarding IR to next stage
            BRANCH_TAKEN <= #1 1'b0;
            
            case (ID_EX_type)                           // ALU
                RR_ALU     :begin
                                case(ID_EX_IR[31:26])
                                    ADD     : begin
                                                    EX_MEM_ALUout <= #1 ID_EX_A + ID_EX_B;
                                                    Reg[ID_EX_IR[15:11]]  <= #1 ID_EX_A + ID_EX_B;
                                              end
                                    SUB     : begin 
                                                    EX_MEM_ALUout <= #1 ID_EX_A - ID_EX_B;
                                                    Reg[ID_EX_IR[15:11]]  <= #1 ID_EX_A - ID_EX_B;
                                              end
                                    AND     : begin 
                                                    EX_MEM_ALUout <= #1 ID_EX_A & ID_EX_B;
                                                    Reg[ID_EX_IR[15:11]]  <= #1 ID_EX_A & ID_EX_B;
                                              end                                    
                                    OR      : begin 
                                                    EX_MEM_ALUout <= #1 ID_EX_A | ID_EX_B;
                                                    Reg[ID_EX_IR[15:11]]  <= #1 ID_EX_A | ID_EX_B;
                                              end         
                                    STL     : begin 
                                                    EX_MEM_ALUout <= #1 ID_EX_A < ID_EX_B;
                                                    Reg[ID_EX_IR[15:11]]  <= #1 ID_EX_A < ID_EX_B;
                                              end         
                                    MUL     : begin 
                                                    EX_MEM_ALUout <= #1 ID_EX_A * ID_EX_B;
                                                    Reg[ID_EX_IR[15:11]]  <= #1 ID_EX_A * ID_EX_B;
                                              end         
                                    NND     : begin 
                                                    EX_MEM_ALUout <= #1 ~(ID_EX_A & ID_EX_B);
                                                    Reg[ID_EX_IR[15:11]]  <= #1 ~(ID_EX_A & ID_EX_B);
                                              end         
                                    NOR     : begin 
                                                    EX_MEM_ALUout <= #1 ~(ID_EX_A | ID_EX_B);
                                                    Reg[ID_EX_IR[15:11]]  <= #1 ~(ID_EX_A | ID_EX_B);
                                              end         
                                    XOR     : begin 
                                                    EX_MEM_ALUout <= #1 ID_EX_A ^ ID_EX_B;
                                                    Reg[ID_EX_IR[15:11]]  <= #1 ID_EX_A ^ ID_EX_B;
                                              end         
                                    XNR     : begin 
                                                    EX_MEM_ALUout <= #1 ~(ID_EX_A ^ ID_EX_B);
                                                    Reg[ID_EX_IR[15:11]]  <= #1 ~(ID_EX_A ^ ID_EX_B);
                                              end         
                                    default : begin 
                                                    EX_MEM_ALUout <= 32'hxxxxxxxx;
                                                    Reg[ID_EX_IR[15:11]]  <= 32'hxxxxxxxx;
                                              end         
                                endcase
                            end
                RM_ALU     :begin
                                case(ID_EX_IR[31:26])
                                    ADI     : begin 
                                                    EX_MEM_ALUout <= #1 ID_EX_B + ID_EX_Imm;
                                                    Reg[ID_EX_IR[25:21]] <= #1 ID_EX_B + ID_EX_Imm;
                                              end
                                    SUI     : begin 
                                                    EX_MEM_ALUout <= #1 ID_EX_B - ID_EX_Imm;
                                                    Reg[ID_EX_IR[25:21]] <= #1 ID_EX_B - ID_EX_Imm;
                                              end
                                    STI     : begin 
                                                    EX_MEM_ALUout <= #1 ID_EX_B < ID_EX_Imm;
                                                    Reg[ID_EX_IR[25:21]] <= #1 ID_EX_B < ID_EX_Imm;
                                              end
                                    default :  begin 
                                                    EX_MEM_ALUout <= 32'hxxxxxxxx;
                                                    Reg[ID_EX_IR[25:21]] <= 32'hxxxxxxxx;
                                              end
                                endcase
                            end
                LOAD,STORE :begin
                                    EX_MEM_ALUout <= #1 ID_EX_A + ID_EX_Imm;
                                    EX_MEM_B      <= #1 ID_EX_B;
                            end                                                                   
                BRANCH     :begin
                                    EX_MEM_ALUout <= #1 ID_EX_NPC + ID_EX_Imm;
                                    EX_MEM_cond   <= #1 (ID_EX_A == 0);
                            end
                JUMP_IM    :        EX_MEM_ALUout <= #1 ID_EX_Imm;
                JUMP       :        EX_MEM_ALUout <= #1 ID_EX_A;

            endcase
            
        end
        
//------------*?? memory access stage ??*--------------------------------------------
  
    always @(posedge clk2)
        if(HALTED == 0)
        begin
            MEM_WB_type   <=  #1 EX_MEM_type;                                   //forwarding type to next stage
            MEM_WB_IR     <=  #1 EX_MEM_IR;                                     //forwarding IR to next stage
        
            case(EX_MEM_type)
               RR_ALU,RM_ALU  :MEM_WB_ALUout      <= #1 EX_MEM_ALUout;          //forwarding ALU output if type is RR or RM
               LOAD           :MEM_WB_LMD         <= #1 Mem[EX_MEM_ALUout];     //taking alu output as address, load the memory to LMD register
               STORE          :if (BRANCH_TAKEN == 0)
                               begin
                                    Mem[EX_MEM_ALUout] <= #1 EX_MEM_B;         //taking alu output as address, load the B register data to memory if branch is not taken
                               end               
           endcase
        end  
        
//-----------*?? write back stage ??*-------------------------------------------------

    always @(posedge clk1)
        begin
        if (BRANCH_TAKEN == 0)
        begin
            case(MEM_WB_type)
                //RR_ALU    :Reg[MEM_WB_IR[15:11]]  <= #1 MEM_WB_ALUout;        //write back the alu output to the destination register // already done in execiution
                //RM_ALU    :Reg[MEM_WB_IR[25:21]]  <= #1 MEM_WB_ALUout;        //write back the alu output to the destination register // already done in execiution
                LOAD      :Reg[MEM_WB_IR[20:16]]  <= #1 MEM_WB_LMD;
                HALT      :HALTED                 <= #1 1'b1;
            endcase
        end
        end
endmodule

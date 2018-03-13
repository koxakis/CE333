module test_alu;

    parameter ADD = 3'b000; //0
    parameter SUB = 3'b001; //1 
    parameter OR  = 3'b010; //2
    parameter AND = 3'b011; //3
    parameter NOT = 3'b100; //4
    parameter MUL = 3'b101; //5
    parameter SLL = 3'b110; //6
    parameter SLR = 3'b111; //7
    
    reg[31:0] inA, inB, out, out_mul;
    reg [2:0] opcode;
    reg       PStart;
    
    wire [31:0] res, extra_res;
    wire zero, PDone;
    
    reg clk;
    
    alu alu0(
        .clk(clk), 
        .inA(inA), 
        .inB(inB), 
        .opcode(opcode), 
        .result(res), 
        .extra_result(extra_res), 
        .PStart(PStart), 
        .PDone(PDone)
        ); 
    
    always #10 clk = ~clk;
    
    initial
    begin
        clk = 1;
        
        //ADDITIONS
        #20 
        PStart = 1'b1;
        inA = 32'b11111111111111111111111111111111;
        inB = 20;
        opcode = ADD;
        
        #20 
        inA = 1256;
        inB = 1453;
        opcode = ADD;
        
        #20 
        inA = 2018;
        inB = 1997;
        opcode = ADD;
        
        #20 
        PStart = 0'b0;
        inA = -8964;
        inB = 78965;
        opcode = ADD;
        
        #20 
        inA = 0;
        inB = 21230;
        opcode = ADD;
        
        //SUBSTRACTIONS
        #20 
        PStart = 1'b1;
        inA = 10;
        inB = 20;
        opcode = SUB;
        
        #20 
        inA = 1256;
        inB = 1453;
        opcode = SUB;
        
        #20 
        inA = 2018;
        inB = 1997;
        opcode = SUB;
        
        #20 
        PStart = 0'b0;
        inA = -8964;
        inB = 78965;
        opcode = SUB;
        
        #20 
        inA = 0;
        inB = 21230;
        opcode = SUB;
        
        //OR
        #20 
        PStart = 1'b1;
        inA = 10;
        inB = 20;
        opcode = OR;
        
        #20 
        inA = 1256;
        inB = 1453;
        opcode = OR;
        
        #20 
        inA = 2018;
        inB = 1997;
        opcode = OR;
        
        #20 
        PStart = 0'b0;
        inA = -1;
        inB = 78965;
        opcode = OR;
        
        #20 
        inA = 0;
        inB = 21230;
        opcode = OR;
        
        //AND
        #20 
        PStart = 1'b1;
        inA = 10;
        inB = 20;
        opcode = AND;
        
        #20 
        inA = 1256;
        inB = 1453;
        opcode = AND;
        
        #20 
        inA = 2018;
        inB = 1997;
        opcode = AND;
        
        #20 
        PStart = 0'b0;
        inA = -1;
        inB = 78965;
        opcode = AND;
        
        #20 
        inA = 0;
        inB = 21230;
        opcode = AND;
        
        //NOT
        #20 
        PStart = 1'b1;
        inA = 10;
        opcode = NOT;
        
        #20 
        inA = 12354;
        opcode = NOT;
        
        #20 
        inA = 1997;
        opcode = NOT;
        
        #20 
        PStart = 0'b0;
        inA = 1994;
        opcode = NOT;
        
        #20 
        inA = 148952;
        opcode = NOT;
        
        //MULTIPLICATIONS
        #20 
        PStart = 1'b1;
        inA = 10;
        inB = 20;
        opcode = MUL;
        
        #20 
        inA = 1256;
        inB = 1453;
        opcode = MUL;
        
        #20 
        inA = 2018;
        inB = 1997;
        opcode = MUL;
        
        #20 
        PStart = 0'b0;
        inA = -8964;
        inB = 78965;
        opcode = MUL;
        
        #20 
        inA = 0;
        inB = 21230;
        opcode = MUL;
        
        //SHIFT LEFT
        #20 
        PStart = 1'b1;
        inA = 10;
        inB = 20;
        opcode = SLL;
        
        #20 
        inA = 1256;
        inB = 32;
        opcode = SLL;
        
        #20 
        inA = 2018;
        inB = 14;
        opcode = SLL;
        
        #20 
        PStart = 0'b0;
        inA = -8964;
        inB = 556;
        opcode = SLL;
        
        #20 
        inA = 0;
        inB = 21230;
        opcode = SLL;
        
        //SHIFT RIGHT
        #20 
        PStart = 1'b1;
        inA = 10;
        inB = 20;
        opcode = SLR;
        
        #20 
        inA = 1256;
        inB = 32;
        opcode = SLR;
        
        #20 
        inA = 2018;
        inB = 14;
        opcode = SLR;
        
        #20 
        inA = -8964;
        inB = 556;
        opcode = SLR;
        
        #20 
        inA = 0;
        inB = 21230;
        opcode = SLR;
        
        
    end
    
endmodule

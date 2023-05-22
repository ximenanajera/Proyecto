
`timescale 1ns/1ns
module ControlUnit (
    input [5:0] instruction,
    output reg regDst,
    output reg branch,
    output reg memRead,
    output reg memToReg,
    output reg [2:0]ALUop,
    output reg memWrite,
    output reg ALUSrc,
    output reg RegWrite
);
    always @(instruction) begin
        if (instruction == 6'b000_000) begin
            /* Formato de instrucciones R
            No almacena datos en memoria, solo en banco de registros*/
            regDst <= 1;
            branch <= 0;
            memRead <= 0;
            memToReg <= 0;
            ALUop <= 010;
            memWrite <= 0;
            ALUSrc <= 0;
            RegWrite <= 1;
        end
	else begin
		/*Formato de instrucciones I*/
		case(instruction)
			6'b001000: begin
				regDst <= 0;
				ALUSrc <= 1;
				memToReg <= 0;
				RegWrite <= 1;
				memRead <= 0;
				memWrite <= 1;
				branch <= 0; 
				ALUop <= 3'b000; //Addw
			end
			6'b001010: begin
				regDst <= 0;
				ALUSrc <= 1;
				memToReg <= 0;
				RegWrite <= 1;
				memRead <= 0;
				memWrite <= 1;
				branch <= 0;
				ALUop <= 3'b001; //Set on Less
			end
			6'b001101: begin
				regDst <= 0;
				ALUSrc <= 1;
				memToReg <= 0;
				RegWrite <= 1;
				memRead <= 0;
				memWrite <= 1;
				branch <= 0;
				ALUop <= 3'b100; //OR
			end
			6'b001100: begin
				regDst <= 0;
				ALUSrc <= 1;
				memToReg <= 0;
				RegWrite <= 1;
				memRead <= 0;
				memWrite <= 1;
				branch <= 0;
				ALUop <= 3'b011; //And 
			end
			6'b101011: begin
				ALUSrc <= 1;
				RegWrite <= 0;
				memRead <= 0;
				memWrite <= 1;
				branch <= 0; 
				ALUop <= 3'b000; //SW
			end
			6'b100011: begin
				regDst <= 0;
				ALUSrc <= 1;
				memToReg <= 1;
				RegWrite <= 1;
				memRead <= 1;
				memWrite <= 0;
				branch <= 0; 
				ALUop <= 3'b000; //LW	
			end
			6'b000100: begin
				ALUSrc <= 0;
				RegWrite <= 0;
				memRead <= 0;
				memWrite <= 0;
				branch <= 1; 
				ALUop <= 3'b101; //BEQ
			end				
		endcase
	    end
    	end
endmodule //ControlUnit
`timescale 1ns/1ns
module ControlUnit (
    input [5:0] instruction,
    output reg regDst,
    output reg branch,
    output reg memRead,
    output reg memToReg,
    output reg [1:0]ALUop,
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
            ALUop <= 10;
            memWrite <= 0;
            ALUSrc <= 0;
            RegWrite <= 1;
        end
    end
endmodule //ControlUnit
`timescale 1ns/1ns
module InstructionFetch (
    input clk,
    input [31:0] pcAdded,
    input [31:0] instruction,
    output reg [31:0] outPcAdded,
    output reg [31:0] outInstruction 
);
    always @(posedge clk) begin
        outPcAdded = pcAdded;
        outInstruction = instruction;
    end 

endmodule //InstructionFetch

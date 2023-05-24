`timescale 1ns/1ns
module InstructionFetch (
    input clk,
    input [31:0] pcAdded,
    input [31:0] instruction,
    output reg [31:0] outPcAdded,
    output reg [31:0] outInstruction 
);
    initial begin
        outPcAdded = 0;
        outInstruction = 0;
    end
    //reg [31:0] bufferpcAdded;
    //reg [31:0] bufferinstruction;

    always @(posedge clk) begin
        outPcAdded <= pcAdded;
        outInstruction <= instruction;
    end 

    //assign outPcAdded = bufferpcAdded;
    //assign outInstruction = bufferinstruction;


endmodule //InstructionFetch

`timescale 1ns/1ns
module PC (
    input [31:0] dataIn,
    input clk,
    output reg[31:0] dataOut
);
    initial begin
        dataOut = 0;
    end
    always @(posedge clk) begin
        dataOut <= dataIn;
    end 
    
endmodule
`timescale 1ns/1ns
module ShiftLeft2 (
    input [31:0] inToShift,
    output reg[31:0] outShifted
);
    reg [31:0] shiftedBits;
    always @(inToShift) begin
        shiftedBits <= inToShift << 2;
        outShifted <= shiftedBits[31:0];
    end
endmodule //ControlBits
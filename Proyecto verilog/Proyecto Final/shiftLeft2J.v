`timescale 1ns/1ns
module shiftLeft2j(
	input[25:0] inToShift,
	output reg[27:0] outShifted 
);

reg[27:0] shiftedBits;

always @ (inToShift) begin
	shiftedBits <= {inToShift, 2'b00};
	outShifted <= shiftedBits[27:0];
end
endmodule //ShiftLeft hacia PC | instrucion j

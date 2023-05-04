`timescale 1ns/1ns
module ALU (
    input [31:0]op1,
    input [31:0]op2,
    input [3:0]selOp,
    output reg [31:0] resultado,
    output reg zeroFlag
);
    initial begin
        resultado <= 0;
        zeroFlag <= 0;
    end
    always @* begin
        case (selOp)
            4'b0000: begin //And 
                resultado <= op1 & op2;
            end
            4'b0001: begin// or
                resultado <= op1 | op2; 
            end
            4'b0010: begin//suma
                resultado <= op1 + op2;
            end
            4'b0110: begin//resta
                resultado <= op1 - op2;
            end
            4'b0111: begin//SLT
                resultado <= op1 < op2
                        ? 32'd1
                        : 32'd0;
            end
            4'b1100: begin//Nor
                resultado <= ~(op1 | op2);
            end
            default:  begin
                
            end

        endcase
        zeroFlag = resultado == 32'd0;
    end
endmodule

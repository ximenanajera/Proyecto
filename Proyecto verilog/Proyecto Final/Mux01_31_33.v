
`timescale 1ns/1ns
module Mux01_31_33 (
    input [31:0] valOnSel0, 
    input [33:0] valOnSel1, 
    input selector,
    output reg [33:0]dataOut
);

    always @(selector) begin
        dataOut <= selector == 1'b1 
                    ? valOnSel1
                    //Esta concatenación es unicamente para igualar a los bits de salida
                    : {2'b00,valOnSel0};
    end
endmodule //Mux01

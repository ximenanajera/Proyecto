`timescale 1ns/1ns
module WriteBack (
    input clk,
    input [31:0] readData,
    input [31:0] aluResult,
    input regWrite,// WB - Obtenido de la unidad control
    input memToReg,// WB - Obtenido de la unidad control
    /* Las salidas estarán relacionadas directamente a la entrada que esta contenida en su nombre */
    output reg [31:0] outReadData,
    output reg [31:0] outAluResult,
    /* Salidas de la unidad de control */
    output reg outRegWrite,
    output reg outMemToReg
);
    always @(posedge clk) begin
        outReadData = readData;
        outAluResult = aluResult;
        /* Salidas de la unidad de control */
        outRegWrite = regWrite;
        outMemToReg = memToReg;
    end

endmodule //WriteBack
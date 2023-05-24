`timescale 1ns/1ns
module InstructionDecode (
    input clk,
    input [31:0] pcAdded,
    input [31:0] Read1,//Obtenido desde banco de registros
    input [31:0] Read2,//Obtenido desde banco de registros
    input [31:0] i16_0Extended,//Obtenido del "sign extend" de los 16 bits menos significativos de lainstrucci�n
    input [4:0] i20_16,
    input [4:0] i15_11,
    input regDst,// EX - Obtenido de la unidad control
    input [2:0] aluOp,// EX - Obtenido de la unidad control
    input aluSrc,// EX - Obtenido de la unidad control
    input branch,// EX MEM- Obtenido de la unidad control
    input memWrite,// EX MEM- Obtenido de la unidad control
    input memRead,// EX MEM- Obtenido de la unidad control
    input regWrite,// WB - Obtenido de la unidad control
    input memToReg,// WB - Obtenido de la unidad control
    /* Las salidas estar�n relacionadas directamente a la entrada que esta contenida en su nombre */
    output reg [31:0] outpcAdded,
    output reg [31:0] outRead1,
    output reg [31:0] outRead2,
    output reg [31:0] outi16_0Extended,
    output reg [4:0] outi20_16,
    output reg [4:0] outi15_11,
    /* Salidas de la unidad de control */
    output reg outRegDst,
    output reg [2:0] outAluOp,
    output reg outAluSrc,
    output reg outBranch,
    output reg outMemWrite,
    output reg outMemRead,
    output reg outRegWrite,
    output reg outMemToReg
);
    initial begin
        outpcAdded = 0;
        outRead1 = 0;
        outRead2 = 0;
        outi16_0Extended = 0;
        outi20_16 = 0;
        outi15_11 = 0;
        outRegDst = 0;
        outAluOp = 0;
        outAluSrc = 0;
        outBranch = 0;
        outMemWrite = 0;
        outMemRead = 0;
        outRegWrite = 0;
        outMemToReg = 0;
    end

    always @(posedge clk) begin
        outpcAdded <= pcAdded;
        outRead1 <= Read1;
        outRead2 <= Read2;
        outi16_0Extended <= i16_0Extended;
        outi20_16 <= i20_16;
        outi15_11 <= i15_11;
        /* Salidas de la unidad de control */
        outRegDst <= regDst;
        outAluOp <= aluOp;
        outAluSrc <= aluSrc;
        outBranch <= branch;
        outMemWrite <= memWrite;
        outMemRead <= memRead;
        outRegWrite <= regWrite;
        outMemToReg <= memToReg;
    end

endmodule //InstructionDecode

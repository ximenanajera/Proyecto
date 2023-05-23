`timescale 1ns/1ns
module Ex_AddresCalc (
    input clk,
    input [31:0] pcAdded,
    input [31:0] zeroFlag,//Obtenido directamente de ALU
    input [31:0] aluResult,//Obtenido directamente de ALU
    input [31:0] writeData,//Proveniente de banco de registros
    input branch,// EX MEM- Obtenido de la unidad control
    input memWrite,// EX MEM- Obtenido de la unidad control
    input memRead,// EX MEM- Obtenido de la unidad control
    input regWrite,// WB - Obtenido de la unidad control
    input memToReg,// WB - Obtenido de la unidad control
    /* Las salidas estarán relacionadas directamente a la entrada que esta contenida en su nombre */
    output reg [31:0] outpcAdded,
    output reg [31:0] outzeroFlag,
    output reg [31:0] outaluResult,
    output reg [31:0] outWriteData,
    /* Salidas de la unidad de control */
    output reg outBranch,
    output reg outMemWrite, 
    output reg outMemRead,
    output reg outRegWrite,
    output reg outMemToReg
);
    always @(posedge clk) begin
        outpcAdded = pcAdded;
        outzeroFlag = zeroFlag;
        outaluResult = aluResult;
        outWriteData = writeData;
        /* Salidas de la unidad de control */
        outBranch = branch;
        outMemWrite = memWrite;
        outMemRead = memRead;
        outRegWrite = regWrite;
        outMemToReg = memToReg;
    end

endmodule //Ex_AddresCalc
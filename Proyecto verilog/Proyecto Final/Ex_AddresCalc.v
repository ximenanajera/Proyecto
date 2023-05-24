`timescale 1ns/1ns
module Ex_AddresCalc (
    input clk,
    input [31:0] pcAdded,
    input zeroFlag,//Obtenido directamente de ALU
    input [31:0] aluResult,//Obtenido directamente de ALU
    input [31:0] writeData,//Proveniente de banco de registros
    input [4:0] muxRegFileData, 
    input branch,// EX MEM- Obtenido de la unidad control
    input memWrite,// EX MEM- Obtenido de la unidad control
    input memRead,// EX MEM- Obtenido de la unidad control
    input regWrite,// WB - Obtenido de la unidad control
    input memToReg,// WB - Obtenido de la unidad control
    /* Las salidas estar�n relacionadas directamente a la entrada que esta contenida en su nombre */
    output reg [31:0] outpcAdded,
    output reg outzeroFlag,
    output reg [31:0] outaluResult,
    output reg [31:0] outWriteData,
    output reg [4:0] outmuxRegFileData,
    /* Salidas de la unidad de control */
    output reg outBranch,
    output reg outMemWrite, 
    output reg outMemRead,
    output reg outRegWrite,
    output reg outMemToReg
);
    initial begin
        outpcAdded = 0;
        outzeroFlag = 0;
        outaluResult = 0;
        outWriteData = 0;
        outmuxRegFileData = 0;
        outBranch = 0;
        outMemWrite = 0;
        outMemRead = 0;
        outRegWrite = 0;
        outMemToReg = 0;
    end

    always @(posedge clk) begin
        outpcAdded <= pcAdded;
        outzeroFlag <= zeroFlag;
        outaluResult <= aluResult;
        outWriteData <= writeData;
        outmuxRegFileData <= muxRegFileData;
        /* Salidas de la unidad de control */
        outBranch <= branch;
        outMemWrite <= memWrite;
        outMemRead <= memRead;
        outRegWrite <= regWrite;
        outMemToReg <= memToReg;
    end

endmodule //Ex_AddresCalc

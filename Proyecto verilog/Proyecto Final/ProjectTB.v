`timescale 1ns/1ns
module ProjectTB ();
//Componentes de pcOne en fetch
    reg clk_tb = 1'b0;
    wire [31:0] outPC;
    //AND entre Branch y ZeroFlag
    wire andBZ; 
    //Componentes de adder en fetch
    wire [31:0] outAdderPC;
    //Componentes para sign extend
    wire [31:0] extendedBits;
    //Componentes de signExtends
    wire [31:0] instruction;
    //Componentes para buffer IF/ID
    wire [31:0] outAdderPCIFID;
    wire [31:0] instructionIFID;
    //Componentes para shift 2
    wire [31:0] shiftedBits;
    //Componentes sumador con shift 2
    wire [31:0] outAdderSignExtend;
    //Componentes shift left 2 Jump
    wire [27:0] shiftedBitsJ;
    //Componentes para mux's
    wire [4:0] muxRegFileDataOut;
    wire [31:0] muxAluOp2DataOut;//Mux para segundo operando de la ALU
    wire [31:0] muxDataReturnToRegister;//Mux de retorno a register file(banco de registros)
    wire [31:0] outMuxToMux;
    wire [31:0] outMuxToPC;
    //Componentes de unidad de control
    wire regDst;
    wire branch;
    wire memRead;
    wire memToReg;
    wire [2:0] ALUop;
    wire memWrite;
    wire ALUSrc;
    wire RegWrite;
    wire Jump;
    //Componentes de regFile
    wire [31:0] BufferDR1;
    wire [31:0] BufferDR2;

    //Componentes para ALU
    wire [31:0] resAlu;
    wire zeroFlagAlu;
    wire [3:0] aluSelector;//salida de ALU control
    //Componentes de dataMem
    wire [31:0] dataReadFromMemory;
    //Componentes para Buffer ID/EX
    wire regDstIDEX;
    wire branchIDEX;
    wire memReadIDEX;
    wire memToRegIDEX;
    wire [2:0] ALUopIDEX;
    wire memWriteIDEX;
    wire ALUSrcIDEX;
    wire RegWriteIDEX;
    wire JumpIDEX;
    wire [31:0]outAdderPCIDEX;
    wire [31:0]aluDR1;
    wire [31:0]aluDR2;
    wire [31:0]extendedBitsIDEX;
    wire [4:0] inst20_16;
    wire [4:0] inst15_11;
    //Componentes para Buffer EX/MEM
    wire [31:0]outAdderPCEXMEM;
    wire zeroFlagEXMEM;
    wire [31:0] resAluEXMEM;
    wire [31:0] writeDataEXMEM;
    wire [4:0] muxRegFileDataEXMEM;
    wire branchEXMEM;
    wire memWriteEXMEM;
    wire memReadEXMEM;
    wire regWriteEXMEM;
    wire memToRegEXMEM;
    //Componentes para Buffer MEM/WB
    wire [31:0] dataReadFromMemoryMEMWB;
    wire [31:0] resAluMEMWB;
    wire [4:0] muxRegFileDataMEMWB;
    wire regWriteMEMWB;
    wire memToRegMEMWB;
    //Condici�n de para mux a PC
    reg selectShiftPC;
    //ejecuci�n indefinida cada 50 unidades de tiempo para clk
    always #50 clk_tb = ~clk_tb;
    
    always @* begin
        selectShiftPC = branchEXMEM & zeroFlagEXMEM;
    end
    /* initial begin
        repeat (1) @(posedge clk_tb);
        $stop;
    end */
    //assign add = 31'd4;
    /* ====================================
        PC
    ==================================== */
    PC pcOne(
        .dataIn(outMuxToPC),
        .clk(clk_tb),
        .dataOut(outPC)
    );
    /* ====================================
    Sumador de PC 
    ====================================*/
    Adder adder(
        .add(4),
        .originalNumber(outPC),
        .out(outAdderPC)
    );
    
    
    /*====================================
    ShiftLeftJ hacia Mux
    ======================================*/
    shiftLeft2j shiftoMuxPC(
   	.inToShift(instructionIFID[25:0]),
	.outShifted(shiftedBitsJ)
    );
    /*==================================== 
    Mux hacia Mux//posiblemente de jump
    ====================================*/
    Mux01_31Bits muxToMux(
        .valOnSel0(outAdderPCEXMEM), 
        .valOnSel1(outAdderSignExtend),
        .selector(selectShiftPC),
        .dataOut(outMuxToMux)
    );

    Mux01_31Bits muxToPC(
	.valOnSel0(outMuxToMux),
	.valOnSel1({outAdderPCEXMEM[31:28], shiftedBitsJ}), 
	.selector(Jump),
	.dataOut(outMuxToPC)
    );
 /* ===================================
    Buffer IF/ID 
    ===================================*/

    InstructionFetch BufferIFID(
	.clk(clk_tb),
	.pcAdded(outAdderPC),
	.instruction(instruction),
	.outPcAdded(outAdderPCIFID),
	.outInstruction(instructionIFID)
    );
    /* ====================================
    Banco de instrucciones 
    ====================================*/
    MInstructions Minst(
        .rdAccess(outAdderPCIFID),
        .data(instruction)
    );
    /* ========================================================================
    ====================================
    Fin de ciclo fetch
    ====================================
    ======================================================================== */
   
    /*  ====================================
    Unidad de control 
     ====================================*/
    ControlUnit controlUnit(
        .instruction(instructionIFID[31:26]),
        .regDst(regDst),
        .branch(branch),
        .memRead(memRead),
        .memToReg(memToReg),
        .ALUop(ALUop),
        .memWrite(memWrite),
        .ALUSrc(ALUSrc),
        .RegWrite(RegWrite),
	    .jump(Jump)
    );
    
    /* ====================================
    Banco de registros 
     ====================================*/
    RegisterFile regFile(
        .regen(RegWriteMEMWB),//region enable, indica que si se guarda o no
        .wd(muxDataReturnToRegister),//write data, datos a escribir
        .RR1(instructionIFID[25:21]),//read registro 1
        .RR2(instructionIFID[20:16]),//read registro 2
        .WA(muxRegFileDataOut),//write Access
        .DR1(BufferDR1),//data read 1
        .DR2(BufferDR2)//data read 2
    );
    /* ====================================
    Recorrido de bits de signExtend
    ====================================*/
    SignExtend signExtend(
        .inputBits(instructionIFID[15:0]),
        .extendedBits(extendedBits)
    );
    /* =====================================
    Buffer ID/EX
    ========================================*/
    InstructionDecode BufferIDEX(
        .clk(clk_tb),
        .pcAdded(outAdderPCIFID),
        .Read1(BufferDR1),
        .Read2(BufferDR2),
        .i16_0Extended(extendedBits),
        .i20_16(instructionIFID[20:16]),
        .i15_11(instructionIFID[15:11]),
        .regDst(regDst),
        .aluOp(ALUop),
        .aluSrc(ALUSrc),
        .branch(branch),
        .memWrite(memWrite),
        .memRead(memRead),
        .regWrite(RegWrite),
        .memToReg(memToReg),
        .outpcAdded(outAdderPCIDEX),
        .outRead1(aluDR1),
        .outRead2(aluDR2),
        .outi16_0Extended(extendedBitsIDEX),
        .outi20_16(inst20_16),
        .outi15_11(inst15_11),
        .outRegDst(regDstIDEX),
        .outAluOp(ALUopIDEX),
        .outAluSrc(ALUSrcIDEX),
        .outBranch(branchIDEX),
        .outMemWrite(memWriteIDEX),
        .outMemRead(memReadIDEX),
        .outRegWrite(RegWriteIDEX),
        .outMemToReg(memToRegIDEX)
    );

    /* ====================================
    Shift de salida de Sign Extend
    ==================================== */
    ShiftLeft2 shiftToMux(
        .inToShift(extendedBitsIDEX),
        .outShifted(shiftedBits)
    );
    /* ====================================
    Sumador de SignExtend 
    ====================================*/
    Adder adderSignExtend(
        .add(shiftedBits),
        .originalNumber(outAdderPCIDEX), 
        .out(outAdderSignExtend)
    );

    /* ====================================
    mux para banco de registros 
     ====================================*/
    Mux01_5Bits muxRegFile(
        .valOnSel0(inst20_16),
        .valOnSel1(inst15_11),
        .selector(regDstIDEX),
        .dataOut(muxRegFileDataOut)
    );
    /*  ====================================
    mux01 con 32 bits hacia ALU 
     ====================================*/
    Mux01_31Bits muxAlu(
        .valOnSel0(aluDR2),
        .valOnSel1(extendedBitsIDEX),//De sign extended
        .selector(ALUSrcIDEX),
        .dataOut(muxAluOp2DataOut)
    );
    /*  ====================================
    Alu Control 
     ====================================*/
    AluControl aluControl(
        .functionField(extendedBitsIDEX[5:0]), 
        .AluOp(ALUopIDEX),
        .operation(aluSelector)
    );
    /*  ====================================
    Alu a Data Memory 
     ====================================*/
    ALU alu(
        .op1(aluDR1),
        .op2(muxAluOp2DataOut),
        .selOp(aluSelector),
        .resultado(resAlu) ,
        .zeroFlag(zeroFlagAlu)
    );
    /* ====================================
    BUFFER EX/MEM
    =======================================*/
    Ex_AddresCalc BufferEXMEM(
        .clk(clk_tb),
        .pcAdded(outAdderSignExtend),
        .zeroFlag(zeroFlagAlu),
        .aluResult(resAlu),
        .writeData(aluDR2),
        .muxRegFileData(muxRegFileDataOut),
        .branch(branchIDEX),
        .memWrite(memWriteIDEX),
        .memRead(memReadIDEX),
        .regWrite(RegWriteIDEX),
        .memToReg(memToRegIDEX),
        .outpcAdded(outAdderPCEXMEM),
        .outzeroFlag(zeroFlagEXMEM),
        .outaluResult(resAluEXMEM),
        .outWriteData(writeDataEXMEM),
        .outmuxRegFileData(muxRegFileDataEXMEM),
        .outBranch(branchEXMEM),
        .outMemWrite(memWriteEXMEM),
        .outMemRead(memReadEXMEM),
        .outRegWrite(regWriteEXMEM),
        .outMemToReg(memToRegEXMEM)
    );
    /* ====================================
    Resultados de la ALU 
    ====================================*/
    DataMemory dataMem(
        .dataEN(resAluEXMEM),//Datos de entrada
        .d(writeDataEXMEM),//Direcci�n de memor�a
        .write(memWriteEXMEM),
        .read(memReadEXMEM),
        .data(dataReadFromMemory)//Datos de salida
    );

    /*======================================
    BUFFER MEM/WB
    ========================================*/
    WriteBack BufferMEMWB(
        .clk(clk_tb),
        .readData(dataReadFromMemory),
        .aluResult(resAluEXMEM),
        .muxRegFileData(muxRegFileDataEXMEM),
        .regWrite(regWriteEXMEM),
        .memToReg(memToRegEXMEM),
        .outReadData(dataReadFromMemoryMEMWB),
        .outAluResult(resAluMEMWB),
        .outmuxRegFileData(muxRegFileDataMEMWB),
        .outRegWrite(regWriteMEMWB),
        .outMemToReg(memToRegMEMWB)
    );

    /* ====================================
    Mux hacia banco de registros (resultados ejecuci�n)
    ====================================*/
    Mux01_31Bits muxReturnToRegister(
        .valOnSel0(resAluMEMWB),
        .valOnSel1(dataReadFromMemoryMEMWB),//De sign extended
        .selector(memToRegMEMWB),
        .dataOut(muxDataReturnToRegister)
    );
    
    
endmodule //ProjectTB

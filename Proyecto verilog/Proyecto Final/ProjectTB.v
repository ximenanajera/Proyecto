`timescale 1ns/1ns
module ProjectTB ();
//Componentes de pcOne en fetch
    reg clk_tb = 1'b0;
    wire [31:0] outPC;
    //AND entre Branch y ZeroFlag
    wire andBZ;
    wire jump;
    //Componentes de adder en fetch
    wire [31:0] outAdderPC;
    //Componentes para sign extend
    wire [31:0] extendedBits;
    //Componentes de signExtends
    wire [31:0] instruction;
    //Componentes para shift 2
    wire [31:0] shiftedBits;
    //Componentes sumador con shift 2
    wire [31:0] outAdderSignExtend;
    //Componentes para mux's
    wire [4:0] muxRegFileDataOut;
    wire [31:0] muxAluOp2DataOut;//Mux para segundo operando de la ALU
    wire [31:0] muxDataReturnToRegister;//Mux de retorno a register file(banco de registros)
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
    //Componentes de regFile
    wire [31:0] aluDR1;
    wire [31:0] aluDR2;

    //Componentes para ALU
    wire [31:0] resAlu;
    wire zeroFlagAlu;
    wire [3:0] aluSelector;//salida de ALU control
    //Componentes de dataMem
    wire [31:0] dataReadFromMemory;
    //Condición de para mux a PC
    reg selectShiftPC;
    //ejecución indefinida cada 50 unidades de tiempo para clk
    always #50 clk_tb = ~clk_tb;
    
    /* Variables para "instruction fetch" */
    wire [31:0] outPcAdded;
    wire [31:0] outInstruction;

    /* Cables para "Instruction decode" */
    wire [31:0] outBIDE_pcAdded;
    wire [31:0] outBIDE_Read1;
    wire [31:0] outBIDE_Read2;
    wire [31:0] outBIDE_i16_0Extended;
    wire [4:0] outBIDE_i20_16;
    wire [4:0] outBIDE_i15_11;
    wire outBIDE_RegDst;
    wire [2:0] outBIDE_AluOp;
    wire outBIDE_AluSrc;
    wire outBIDE_Branch;
    wire outBIDE_MemWrite;
    wire outBIDE_MemRead;
    wire outBIDE_RegWrite;
    wire outBIDE_MemToReg;
    wire outBIDE_Jump;

    /* Cables para buffer "Ex_addresCalc" */
    wire [31:0] outEAddCalcpcAdded;
    wire outEAddCalczeroFlag;
    wire [31:0] outEAddCalcaluResult;
    wire [31:0] outEAddCalcWriteData;
    wire [4:0] outEAddCalcmuxRegFileData;
    wire outEAddCalcBranch;
    wire outEAddCalcMemWrite;
    wire outEAddCalcMemRead;
    wire outEAddCalcRegWrite;
    wire outEAddCalcMemToReg;
    wire outEAddCalcJump;
    /* Cables para "write back" */
    wire [31:0] outBWBackReadData;
    wire [31:0] outBWBackAluResult;
    wire [4:0] outBWBackmuxRegFileData;
    wire outBWBackRegWrite;
    wire outBWBackMemToReg;
    
    always @* begin
        selectShiftPC = branch & zeroFlagAlu;
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
    /* ====================================
    Recorrido de bits de signExtend
    ====================================*/
    SignExtend signExtend(
        .inputBits(outInstruction[15:0]),
        .extendedBits(extendedBits)
    );
    
    
    /*==================================== 
    Mux hacia PC
    ====================================*/
    Mux01_31Bits muxToPC(
        .valOnSel0(outEAddCalcpcAdded),
        .valOnSel1(outAdderSignExtend),
        .selector(selectShiftPC),
        .dataOut(outMuxToPC)
    );
    
    /* ========================================================================
    ====================================
    Fin de ciclo fetch
    ====================================
    ======================================================================== */
    /* ====================================
    Banco de instrucciones 
    ====================================*/
    MInstructions Minst(
        .rdAccess(outPC),
        .data(instruction)
    );
    InstructionFetch bufferIFetch(
        .clk(clk_tb),
        .pcAdded(outAdderPC),
        .instruction(instruction),
        .outPcAdded(outPcAdded),
        .outInstruction(outInstruction) 
    );
    /*  ====================================
    Unidad de control 
     ====================================*/
    ControlUnit controlUnit(
        .instruction(outInstruction[31:26]),
        .regDst(regDst),
        .branch(branch),
        .memRead(memRead),
        .memToReg(memToReg),
        .ALUop(ALUop),
        .memWrite(memWrite),
        .ALUSrc(ALUSrc),
        .RegWrite(RegWrite),
        .jump(jump)
    );
    /* ====================================
    Banco de registros 
     ====================================*/
    RegisterFile regFile(
        .regen(RegWrite),//region enable, indica que si se guarda o no
        .wd(muxDataReturnToRegister),//write data, datos a escribir
        .RR1(outInstruction[25:21]),//read registro 1
        .RR2(outInstruction[20:16]),//read registro 2
        .WA(outBWBackmuxRegFileData),//write Access
        .DR1(aluDR1),//data read 1
        .DR2(aluDR2)//data read 2
    );    
    /* Buffer para "Instruction decode" */
    InstructionDecode bufferIDecode(
        .clk(clk_tb),
        .pcAdded(outPcAdded),
        .Read1(aluDR1),//Obtenido desde banco de registros
        .Read2(aluDR2),//Obtenido desde banco de registros
        .i16_0Extended(extendedBits),//Obtenido del "sign extend" de los 16 bits menos significativos de lainstrucci�n
        .i20_16(outInstruction[20:16]),
        .i15_11(outInstruction[15:11]),
        .regDst(regDst),// EX - Obtenido de la unidad control
        .aluOp(ALUop),// EX - Obtenido de la unidad control
        .aluSrc(ALUSrc),// EX - Obtenido de la unidad control
        .branch(branch),// EX MEM- Obtenido de la unidad control
        .memWrite(memWrite),// EX MEM- Obtenido de la unidad control
        .memRead(memRead),// EX MEM- Obtenido de la unidad control
        .regWrite(RegWrite),// WB - Obtenido de la unidad control
        .memToReg(memToReg),// WB - Obtenido de la unidad control
        .jump(jump),
        /* Las salidas estar�n relacionadas directamente a la entrada que esta contenida en su nombre */
        .outpcAdded(outBIDE_pcAdded),
        .outRead1(outBIDE_Read1),
        .outRead2(outBIDE_Read2),
        .outi16_0Extended(outBIDE_i16_0Extended),
        .outi20_16(outBIDE_i20_16),
        .outi15_11(outBIDE_i15_11),
        .outRegDst(outBIDE_RegDst),
        .outAluOp(outBIDE_AluOp),
        .outAluSrc(outBIDE_AluSrc),
        .outBranch(outBIDE_Branch),
        .outMemWrite(outBIDE_MemWrite),
        .outMemRead(outBIDE_MemRead),
        .outRegWrite(outBIDE_RegWrite),
        .outMemToReg(outBIDE_MemToReg),
        .outJump(outBIDE_Jump)
    );
    /* ====================================
    Shift de salida de Sign Extend
    ==================================== */
    ShiftLeft2 shiftToMuxPC(
        .inToShift(outBIDE_i16_0Extended),
        .outShifted(shiftedBits)
    );
    /* ====================================
    Sumador de SignExtend 
    ====================================*/
    Adder adderSignExtend(
        .add(shiftedBits),
        .originalNumber(outBIDE_pcAdded),
        .out(outAdderSignExtend)
    );
    /*  ====================================
    mux01 con 32 bits hacia ALU 
     ====================================*/
    Mux01_31Bits muxAlu(
        .valOnSel0(outBIDE_Read2),
        .valOnSel1(outBIDE_i16_0Extended),//De sign extended
        .selector(outBIDE_AluSrc),
        .dataOut(muxAluOp2DataOut)
    );
    /*  ====================================
    Alu Control 
     ====================================*/
    AluControl aluControl(
        .functionField(outBIDE_i16_0Extended[5:0]),
        .AluOp(outBIDE_AluOp),
        .operation(aluSelector)
    );
    /*  ====================================
    Alu a Data Memory 
     ====================================*/
    ALU alu(
        .op1(outBIDE_Read1),
        .op2(muxAluOp2DataOut),
        .selOp(aluSelector),
        .resultado(resAlu) ,
        .zeroFlag(zeroFlagAlu)
    );
    /* ====================================
    mux para banco de registros 
     ====================================*/
    Mux01_5Bits muxRegFile(
        .valOnSel0(outInstruction[20:16]),
        .valOnSel1(outInstruction[15:11]),
        .selector(outBIDE_RegDst),
        .dataOut(muxRegFileDataOut)
    );

    

    Ex_AddresCalc bufferExAddCalc(
        .clk(clk_tb),
        .pcAdded(outBIDE_pcAdded),
        .zeroFlag(zeroFlagAlu),//Obtenido directamente de ALU
        .aluResult(resAlu),//Obtenido directamente de ALU
        .writeData(outBIDE_Read2),//Proveniente de banco de registros
        .muxRegFileData(muxRegFileDataOut), //Multiplexor hacia banco de registros
        .branch(outBIDE_Branch),// EX MEM- Obtenido de la unidad control
        .memWrite(outBIDE_MemWrite),// EX MEM- Obtenido de la unidad control
        .memRead(outBIDE_MemRead),// EX MEM- Obtenido de la unidad control
        .regWrite(outBIDE_RegWrite),// WB - Obtenido de la unidad control
        .memToReg(outBIDE_MemToReg),// WB - Obtenido de la unidad control
        .jump(outBIDE_Jump),
        /* Las salidas estar�n relacionadas directamente a la entrada que esta contenida en su nombre */
        .outpcAdded(outEAddCalcpcAdded),
        .outzeroFlag(outEAddCalczeroFlag),
        .outaluResult(outEAddCalcaluResult),
        .outWriteData(outEAddCalcWriteData),
        .outmuxRegFileData(outEAddCalcmuxRegFileData),
        /* Salidas de la unidad de control */
        .outBranch(outEAddCalcBranch),
        .outMemWrite(outEAddCalcMemWrite), 
        .outMemRead(outEAddCalcMemRead),
        .outRegWrite(outEAddCalcRegWrite),
        .outMemToReg(outEAddCalcMemToReg),
        .outJump(outEAddCalcJump)
    );

    /* ====================================
    Resultados de la ALU 
    ====================================*/
    DataMemory dataMem(
        .dataEN(outBIDE_Read2),//Datos de entrada
        .d(outEAddCalcaluResult),//Dirección de memoría
        .write(outBIDE_MemWrite),
        .read(outBIDE_MemRead),
        .data(dataReadFromMemory)//Datos de salida
    );

    WriteBack bufferWBack(
        .clk(clk_tb),
        .readData(dataReadFromMemory),
        .aluResult(outEAddCalcaluResult),
        .muxRegFileData(outEAddCalcmuxRegFileData),
        .regWrite(outEAddCalcRegWrite),// WB - Obtenido de la unidad control
        .memToReg(outEAddCalcMemToReg),// WB - Obtenido de la unidad control
        /* Las salidas estar�n relacionadas directamente a la entrada que esta contenida en su nombre */
        .outReadData(outBWBackReadData),
        .outAluResult(outBWBackAluResult),
        .outmuxRegFileData(outBWBackmuxRegFileData),
        /* Salidas de la unidad de control */
        .outRegWrite(outBWBackRegWrite),
        .outMemToReg(outBWBackMemToReg)
    );
    /* ====================================
    Mux hacia banco de registros (resultados ejecución)
    ====================================*/
    Mux01_31Bits muxReturnToRegister(
        .valOnSel0(outBWBackAluResult),
        .valOnSel1(outBWBackReadData),//De sign extended
        .selector(outBWBackMemToReg),
        .dataOut(muxDataReturnToRegister)
    );
    
    
endmodule //ProjectTB

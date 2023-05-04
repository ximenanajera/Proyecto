`timescale 1ns/1ns
module ProjectTB ();
//Componentes de pcOne en fetch
    reg [31:0] dataIn = 31'd0;
    reg clk_tb = 1'b0;
    wire [31:0] outPC;
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
    wire [1:0] ALUop;
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
        .inputBits(instruction[15:0]),
        .extendedBits(extendedBits)
    );
    /* ====================================
    Shift de salida de Sign Extend
    ==================================== */
    ShiftLeft2 shiftToMuxPC(
        .inToShift(extendedBits),
        .outShifted(shiftedBits)
    );
    /* ====================================
    Sumador de SignExtend 
    ====================================*/
    Adder adderSignExtend(
        .add(shiftedBits),
        .originalNumber(outAdderPC),
        .out(outAdderSignExtend)
    );
    /*==================================== 
    Mux hacia PC
    ====================================*/
    Mux01_31Bits muxToPC(
        .valOnSel0(outAdderPC),
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
    /*  ====================================
    Unidad de control 
     ====================================*/
    ControlUnit controlUnit(
        .instruction(instruction[31:26]),
        .regDst(regDst),
        .branch(branch),
        .memRead(memRead),
        .memToReg(memToReg),
        .ALUop(ALUop),
        .memWrite(memWrite),
        .ALUSrc(ALUSrc),
        .RegWrite(RegWrite)
    );
    /* ====================================
    mux para banco de registros 
     ====================================*/
    Mux01_5Bits muxRegFile(
        .valOnSel0(instruction[20:16]),
        .valOnSel1(instruction[15:11]),
        .selector(regDst),
        .dataOut(muxRegFileDataOut)
    );
    /* ====================================
    Banco de registros 
     ====================================*/
    RegisterFile regFile(
        .regen(RegWrite),//region enable, indica que si se guarda o no
        .wd(muxDataReturnToRegister),//write data, datos a escribir
        .RR1(instruction[25:21]),//read registro 1
        .RR2(instruction[20:16]),//read registro 2
        .WA(muxRegFileDataOut),//write Access
        .DR1(aluDR1),//data read 1
        .DR2(aluDR2)//data read 2
    );
    /*  ====================================
    mux01 con 32 bits hacia ALU 
     ====================================*/
    Mux01_31Bits muxAlu(
        .valOnSel0(aluDR2),
        .valOnSel1(extendedBits),//De sign extended
        .selector(ALUSrc),
        .dataOut(muxAluOp2DataOut)
    );
    /*  ====================================
    Alu Control 
     ====================================*/
    AluControl aluControl(
        .functionField(instruction[5:0]),
        .AluOp(ALUop),
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
    Resultados de la ALU 
    ====================================*/
    DataMemory dataMem(
        .dataEN(resAlu),//Datos de entrada
        .d(resAlu),//Dirección de memoría
        .write(memWrite),
        .read(memRead),
        .data(dataReadFromMemory)//Datos de salida
    );
    /* ====================================
    Mux hacia banco de registros (resultados ejecución)
    ====================================*/
    Mux01_31Bits muxReturnToRegister(
        .valOnSel0(resAlu),
        .valOnSel1(dataReadFromMemory),//De sign extended
        .selector(memToReg),
        .dataOut(muxDataReturnToRegister)
    );
    
    
endmodule //ProjectTB

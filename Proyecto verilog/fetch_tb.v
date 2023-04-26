`timescale 1ns/1ns
module fetch_tb ();
    //Componentes de pcOne en fetch
    reg [31:0] dataIn = 31'd0;
    reg clk_tb = 1'b0;
    wire [31:0] outPC;
    //Componentes de adder en fetch
    wire [31:0] outFirstAdder;
    //Componentes de Minst en fetch
    reg [8:0] d = 0;
    reg le = 1'b0;
    wire [31:0] data;
    //ejecución indefinida cada 50 unidades de tiempo para clk
    always #50 clk_tb = ~clk_tb;
    //Solo para pruebas
    //assign add = 31'd4;
    PC pcOne(
        .dataIn(outFirstAdder),
        .clk(clk_tb),
        .dataOut(outPC)
    );

    Adder adder(
        .add(4),
        .originalNumber(outPC),
        .out(outFirstAdder)
    );

    MInstructions Minst(
        .rdAccess(outPC),
        .data(data)
    );

endmodule
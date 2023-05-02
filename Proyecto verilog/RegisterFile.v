`timescale 1ns/1ns
module RegisterFile(
    input regen,//region enable, indica que si se guarda o no
    input [31:0]wd,//write data, datos a escribir
    input [4:0]RR1,//read registro 1
    input [4:0]RR2,//read registro 2
    input [4:0]WA,//write Access
    output reg[31:0] DR1,//data read 1
    output reg[31:0] DR2//data read 2
);

    reg [31:0] banco[0:31];

    initial begin
        //Lectura de datos del archivo
        $readmemb("br.txt", banco);
        DR1 <= 0;
        DR2 <= 0;
    end

    always @* begin
        if (regen == 1'b1) begin
            //Escribir
            banco[WA] <= wd;
        end
        //Salida de datos
        DR1 <= banco[RR1];
        DR2 <= banco[RR2];   
    end
endmodule

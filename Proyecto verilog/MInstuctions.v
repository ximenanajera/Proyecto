`timescale 1ns/1ns
module MInstructions(
    input [31:0] rdAccess,
    output reg[31:0] data
);
    reg [7:0] ram [0:255];
    initial begin
        //Lectura de datos del archivo
        $readmemb("Mem_inst.txt", ram);
    end

    always @* begin
        //leer
        data <= {ram[rdAccess], ram[rdAccess+1],ram[rdAccess+2], ram[rdAccess+3]};
    end
endmodule

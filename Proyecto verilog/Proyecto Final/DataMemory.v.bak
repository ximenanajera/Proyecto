`timescale 1ns/1ns
module DataMemory(
    input [31:0] dataEN,
    input [31:0] d,
    input write,
    input read,
    output reg[31:0] data
);
    reg [31:0] ram [0:63];
    always @* begin
        if (write == 1'b1) begin
            //Escribir
            data <= ram[d];
        end
        if (read == 1'b1) begin
            //leer
            data <= ram[d];
        end    
    end


endmodule
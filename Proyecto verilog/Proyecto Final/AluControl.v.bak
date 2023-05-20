/* Todo el desarrollo de este modulo esta basado en el libro 
"Computer organization and design" página 260 Figura 4.12.
Esta sujeto a cambios para complemtenar las funcionalidades */
`timescale 1ns/1ns
module AluControl (
    input [5:0] functionField, //Obtenida directamente de la insturcción actual
    input [2:0] AluOp,//Obtenido desde la unidad de control
    output reg [3:0] operation//Operación que debe realizar ahora la ALU
);
    initial operation = 4'd0;
    /* 
    Cuando AluOp en su indice 1 contenga 1, será una instrucción de tipo R, por ello solo evaluamos ese campo
     */
    always @* begin
        if (AluOp == 3'b010) begin
            case (functionField)
                6'b100000: begin//Add operation
                    operation <= 4'b0010;
                end
                6'b100010: begin//subtract operation
                    operation <= 4'b0110;
                end
                6'b100100: begin//And operation
                    operation <= 4'b0000;
                end
                6'b100101: begin//Or operation
                    operation <= 4'b0001;
                end
                6'b101010: begin//Set on less
                    operation <= 4'b0111;
                end
                6'b000000: begin//Nop operation (no operation)
                    operation <= 4'b1000;
                end
            endcase
        end 
        /* en los siguientes campos, el campo "functionField" no
        tiene relevancia, es parte de una condición "don´t care" */
	else if(AluOp == 3'b000)begin
		operation <= 4'b0010; //Add operation
	end
	else if(AluOp == 3'b001)begin
		operation <= 4'b0111; //Set on less operation
	end
	else if(AluOp == 3'b011)begin
		operation <= 4'b0000; //And operation
	end
	else if(AluOp == 3'b100)begin
		operation <= 4'b0001; //Or operation
	end
	else if(AluOp == 3'b101)begin
                operation <= 4'b0110; //subtract operation
        end	
        else begin
            /* Cuando AluOp en su indice 0 tiene 1 */
            if (AluOp[0] == 1'b1) begin
                
            end 
	    else begin
                /* Cuado no se cumpla ninguna condición anterior,
                entonces es una instrucción LW, SW */
            end
        end 
    end
endmodule
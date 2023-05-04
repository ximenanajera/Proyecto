# ALU 
ALU realiza la operación que se le haya indicado con los dos operandos que reciba, dentro del procesador dará salida a un valor,producto de la ejecución realizada.
## Contemplaciones 
Enviar los datos de salida a una unidad de memoría directamente y a un multiplexor que decidirá si se envíarán los datos de la memoría o si se devolverán los resultados de **ALU** al banco de registros.

- Los datos envíados a la unidad de memoría son una dirección de memoría, para cumplir este caso, la instrucción ejecutada no es de **tipo R**.
- Cuando la instrucción ejecutada es de **tipo R** no se almacenarán datos en la unidad de almacenamiento inmediata al procesador y el resultado a escribir en el banco de registros es practicamente el resultado de ALU.
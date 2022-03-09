//Enock Bezerra Ferreira de Souza
//Tabela de HDL: Lógica combinatória e display de 7 segmentos
//Exercício 1


// DESCRIPTION: Verilator: Systemverilog example module
// with interface to switch buttons, LEDs, LCD and register display

parameter divide_by=100000000;  // divisor do clock de referência
// A frequencia do clock de referencia é 50 MHz.
// A frequencia de clk_2 será de  50 MHz / divide_by

parameter NBITS_INSTR = 32;
parameter NBITS_TOP = 8, NREGS_TOP = 32, NBITS_LCD = 64;
module top(input  logic clk_2,
            input  logic [NBITS_TOP-1:0] SWI,
            output logic [NBITS_TOP-1:0] LED,
            output logic [NBITS_TOP-1:0] SEG,
            output logic [NBITS_LCD-1:0] lcd_a, lcd_b,
            output logic [NBITS_INSTR-1:0] lcd_instruction,
            output logic [NBITS_TOP-1:0] lcd_registrador [0:NREGS_TOP-1],
            output logic [NBITS_TOP-1:0] lcd_pc, lcd_SrcA, lcd_SrcB,
                lcd_ALUResult, lcd_Result, lcd_WriteData, lcd_ReadData, 
            output logic lcd_MemWrite, lcd_Branch, lcd_MemtoReg, lcd_RegWrite);

    always_comb begin
    /*LED <= SWI;*/
    /*SEG <= SWI;*/
    lcd_WriteData <= SWI;
    lcd_pc <= 'h12;
    lcd_instruction <= 'h34567890;
    lcd_SrcA <= 'hab;
    lcd_SrcB <= 'hcd;
    lcd_ALUResult <= 'hef;
    lcd_Result <= 'h11;
    lcd_ReadData <= 'h33;
    lcd_MemWrite <= SWI[0];
    lcd_Branch <= SWI[1];
    lcd_MemtoReg <= SWI[2];
    lcd_RegWrite <= SWI[3];
    for(int i=0; i<NREGS_TOP; i++)
        if(i != NREGS_TOP/2-1) lcd_registrador[i] <= i+i*16;
        else                   lcd_registrador[i] <= ~SWI;
    lcd_a <= {56'h1234567890ABCD, SWI};
    lcd_b <= {SWI, 56'hFEDCBA09876543};
    end


    //---------------------------------------------------------
    // Exercício 1 - SITUAÇÃO DO ALUNO
    //---------------------------------------------------------

    //Declarando variável de entrada
    wire [3:0] nota;

    //Colocando o valor de entrada em uma variável
    always_comb begin
        nota[0] <= SWI[0];
        nota[1] <= SWI[1];
        nota[2] <= SWI[2];
        nota[3] <= SWI[3];
    end

    //Conexões de segmentos fixos
    always_comb begin
        SEG[0] <= 1;
        SEG[3] <= 0;
        SEG[4] <= 1;
        SEG[5] <= 1;
        SEG[6] <= 1;
    end

    //Lógica dos segmentos variáveis
    always_comb begin
        SEG[1] <= (nota < 4) || (nota > 6);
        SEG[2] <= (nota > 6);
    end

endmodule

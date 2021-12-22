//Enock Bezerra Ferreira de Souza
//Tabela de HDL: Lógica Combinatória


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
    SEG <= SWI;
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
  
//--------------------------------------------------------------------------
// Exercício 1 - FIM DE EXPEDIENTE
//--------------------------------------------------------------------------

//Declarando variáveis de entrada
logic noite, paradas, sexta, producao;

//Declaração da variável de saída
logic sirene;

//Declarando conexões das variáveis de entrada com as chaves
always_comb begin
	noite <= SWI[4];
	paradas <= SWI[5];
	sexta <= SWI[6];
	producao <= SWI[7];
end

//Conexão da saída
always_comb LED[2] <= sirene;


//Lógica do sistema (em lógica combinacional)
always_comb
	sirene <= (noite && paradas) || (sexta && producao && paradas);
/*
Ou seja, o LED de indice 2 (da direita para a equerda no simulador)
deverá ser ativado se, e somente se, ocorrer ao menos uma das seguintes
combinações de switchs ativados: 4 e 5; ou 5, 6 e 7.
*/

endmodule

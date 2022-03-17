//Enock Bezerra Ferreira de Souza
//FSM: Bobina de Papel


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
        //LED <= SWI;
        //SEG <= SWI;
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

    //Índices usados para entradas e saídas
    parameter SWI_RESET = 7;
    parameter SWI_NOVA = 0;
    parameter SWI_VELOCIDADE = 1;
    parameter SWI_VAZIO = 2;
    parameter LED_CLOCK = 7;
    parameter LED_ACELERAR = 0;
    parameter LED_COLAR = 1;
    parameter LED_CORTAR = 2;
    parameter LED_ALARME = 3;

    //Constantes
    parameter QTD_BITS_ESTADO = 3;

    //Declarando entradas
    logic reset, nova, velocidade, vazio;

    //Definindo conexões de entrada
    always_comb begin
        reset <= SWI[SWI_RESET];
        nova <= SWI[SWI_NOVA];
        velocidade <= SWI[SWI_VELOCIDADE];
        vazio <= SWI[SWI_VAZIO];
    end

    //Declarando saídas
    logic clock, acelerar, colar, cortar, alarme;

    //Atribuindo valor real do clock à variável "clock"
    always_comb clock <= clk_2;

    //Definindo conexões de saída
    always_comb begin
        LED[LED_CLOCK] <= clock;
        LED[LED_ACELERAR] <= acelerar;
        LED[LED_COLAR] <= colar;
        LED[LED_CORTAR] <= cortar;
        LED[LED_ALARME] <= alarme;
    end

    //Definindo estados
    enum logic [QTD_BITS_ESTADO - 1 : 0] {
        STAND_BY,
        ERRO,
        ACELERANDO,
        COLANDO,
        CORTANDO,
        TROCA_EFETUADA
    } estado_atual;
    
    
    always_ff @(posedge clk_2) begin
        //Caso em que o switch de reset está ativado
        if (reset) begin
            erro <= 0;
            //estado_atual <= STAND_BY;
        end

        //Caso o switch de reset esteja desativado, checar o estado atual
        else
            erro <= 1;
    end

endmodule
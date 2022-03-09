//Enock Bezerra Ferreira de Souza
//FSM: Porta Rolante 


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
    parameter SWI_FECHAR = 0;
    parameter SWI_ABRIR = 1;
    parameter SWI_BAIXO = 2;
    parameter SWI_CIMA = 4;
    parameter SWI_RESET = 7;
    parameter LED_CLK = 7;
    parameter LED_MOTOR_ABRINDO = 0;
    parameter LED_MOTOR_FECHANDO = 1;
    parameter LED_ALARME = 3;

    //Constantes
    parameter QTD_BITS_ESTADO = 2;

    //Declarando entradas
    logic reset, fechar, abrir, em_baixo, em_cima;

    //Definindo conexões de entrada
    always_comb begin
        reset <= SWI[SWI_RESET];
        fechar <= SWI[SWI_FECHAR];
        abrir <= SWI[SWI_ABRIR];
        em_baixo <= SWI[SWI_BAIXO];
        em_cima <= SWI[SWI_CIMA];
    end

    //Declarando saídas
    logic clock, motor_abrindo, motor_fechando, alarme;

    //Definindo conexões de saída
    always_comb begin
        LED[LED_CLK] <= clock;
        LED[LED_MOTOR_ABRINDO] <= motor_abrindo;
        LED[LED_MOTOR_FECHANDO] <= motor_fechando;
        LED[LED_ALARME] <= alarme;
    end

    //Definindo estados
    enum logic [QTD_BITS_ESTADO - 1 : 0] {
        RESET_ESTADO,
        FECHADO,
        ABERTO
    } estado_atual;
    
    
    always_ff @(posedge clk_2) begin
        //Caso em que o circuito reseta
        if (reset) begin
            estado_atual <= RESET_ESTADO;
            motor_fechando <= 1;
        end

        //Caso default
        else
            unique case (estado_atual)
                RESET_ESTADO: if (em_cima) estado_atual <= ABERTO;
                ABERTO: motor_fechando <= 0;
            endcase

    end
    

    /*
    always_comb begin
        if (reset) begin
            SEG [NBITS_TOP-1:0] <= 0;
            LED [NBITS_TOP-1:0] <= 0;
        end
        
        else begin
            SEG [NBITS_TOP-1:0] <= 3;
            LED [NBITS_TOP-1:0] <= 'b01010101;
        end
    end
    */

endmodule
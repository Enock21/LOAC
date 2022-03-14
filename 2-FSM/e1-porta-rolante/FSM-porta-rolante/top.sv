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
    parameter SWI_MEIO = 3;
    parameter SWI_RESET = 7;
    parameter LED_CLK = 7;
    parameter LED_MOTOR_ABRINDO = 0;
    parameter LED_MOTOR_FECHANDO = 1;
    parameter LED_ALARME = 3;
    parameter SWI_PROG_MAX = 6;
    parameter SWI_PROG_MIN = 5;

    //Constantes
    parameter QTD_BITS_ESTADO = 2;
    parameter INCREMENTO_COUNT = 1;

    //Declarando entradas
    logic reset, fechar, abrir, em_baixo, em_cima, no_meio;
    logic [1:0] prog;
    
    //Contador para o sistema de prog
    integer count;

    //Variável que indica se a execução atual faz parte do ciclo de reset ou não
    logic ciclo_reset;

    //Definindo conexões de entrada
    always_comb begin
        reset <= SWI[SWI_RESET];
        fechar <= SWI[SWI_FECHAR];
        abrir <= SWI[SWI_ABRIR];
        em_baixo <= SWI[SWI_BAIXO];
        em_cima <= SWI[SWI_CIMA];
        no_meio <= SWI[SWI_MEIO];
        prog <= SWI[SWI_PROG_MAX:SWI_PROG_MIN];
    end

    //Declarando saídas
    logic clock, motor_abrindo, motor_fechando, alarme;

    //Atribuindo valor real do clock à variável "clock"
    always_comb clock <= clk_2;

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
        ENTREABERTO,
        ABERTO
    } estado_atual;
    
    
    always_ff @(posedge clk_2) begin
        //Caso em que o switch de reset está ativado
        if (reset) begin
            estado_atual <= RESET_ESTADO;
        end

        //Caso o switch de reset esteja desativado, checar o estado atual
        else
            unique case (estado_atual)
                //Caso o estado seja o de reset
                RESET_ESTADO: begin
                    if (em_cima) begin
                        alarme <= 0;
                        motor_fechando <= 1;
                        ciclo_reset <= 1;
                        estado_atual <= ENTREABERTO;
                    end

                    else if (no_meio) begin
                        alarme <= 0;
                        motor_fechando <= 1;
                        estado_atual <= FECHADO;
                    end

                    else if (em_baixo) begin
                        alarme <= 0;
                        motor_fechando <= 0;
                        estado_atual <= FECHADO;
                    end

                    else begin
                        alarme <= 1;
                        estado_atual <= RESET_ESTADO;
                    end
                    
                    count <= 0;
                    motor_abrindo <= 0;
                end

                //Estado em que a porta esteja totalmente fechada
                FECHADO: begin
                    //Caso apenas o comando para abrir seja executado
                    if (abrir && !fechar) begin
                        //Programando uma abertura com retardo de clock
                        if ((prog > 0) && (prog > count)) begin
                            count <= count + INCREMENTO_COUNT;
                        end

                        //Abrindo porta
                        else begin
                            count <= 0;
                            motor_abrindo <= 1;
                            estado_atual <= ENTREABERTO;
                        end
                    end

                    //Parando o motor
                    else begin
                        motor_abrindo <= 0;
                        motor_fechando <= 0;
                    end
                end

                //Caso em que a porta esteja no meio
                ENTREABERTO: begin
                    //Condição de fechamento como parte do ciclo de reset, que sobrepõe todos os switches
                    if (ciclo_reset) begin
                        ciclo_reset <= 0;
                        motor_fechando <= 1;
                        estado_atual <= FECHADO;
                    end

                    //Caso especial em que o sistema apresenta mal funcionamento
                    else if (em_cima || em_baixo) begin
                        alarme <= 1;
                        motor_abrindo <= 0;
                        motor_fechando <= 0;
                        estado_atual <= RESET_ESTADO;
                    end

                    //Parando o motor caso os botões de abrir e fechar estejam na mesma posição
                    else if ((abrir && fechar) || (!abrir && !fechar)) begin
                        motor_abrindo <= 0;
                        motor_fechando <= 0;
                    end

                    else begin
                        //Comando de abertura
                        if (abrir) begin
                            //Programando uma abertura com retardo de clock
                            if ((prog > 0) && (prog > count)) begin
                                motor_abrindo <= 0;
                                count <= count + INCREMENTO_COUNT;
                            end

                            //Porta abrindo
                            else begin
                                count <= 0;
                                motor_abrindo <= 1;
                                estado_atual <= ABERTO;
                            end
                        end

                        //Comando de fechamento
                        else if (fechar) begin
                            //Programando um fechamento com retardo de clock
                            if ((prog > 0) && (prog > count)) begin
                                motor_fechando <= 0;
                                count <= count + INCREMENTO_COUNT;
                            end

                            //Fechando porta
                            else begin
                                count <= 0;
                                motor_fechando <= 1;
                                estado_atual <= FECHADO;
                            end
                        end
                    end
                end

                //Caso em que a porta esteja totalmente aberta
                ABERTO: begin
                    //Caso apenas o comando para fechar seja executado
                    if (fechar && !abrir) begin
                        //Programando um fechamento com retardo de clock
                        if ((prog > 0) && (prog > count)) begin
                            count <= count + INCREMENTO_COUNT;
                        end

                        //Fechando porta
                        else begin
                            count <= 0;
                            motor_fechando <= 1;
                            estado_atual <= ENTREABERTO;
                        end
                    end

                    //Parando o motor
                    else begin
                        motor_abrindo <= 0;
                        motor_fechando <= 0;
                    end
                end
            endcase
    end

endmodule
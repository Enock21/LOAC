//Enock Bezerra Ferreira de Souza
//Tabela de HDL: Display de 7 segmentos


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
        for(i=0; i<NREGS_TOP; i++)
            if(i != NREGS_TOP/2-1) lcd_registrador[i] <= i+i*16;
            else                   lcd_registrador[i] <= ~SWI;
        lcd_a <= {56'h1234567890ABCD, SWI};
        lcd_b <= {SWI, 56'hFEDCBA09876543};
    end

    //Declarando variáveis
    logic [5:0] entrada;
    logic [3:0] nota;
    int i;

    //Declarando conexões
    always_comb begin
        SEG[0] <= 0;
        SEG[1] <= 0;
        SEG[2] <= 0;
        SEG[3] <= 0;
        SEG[4] <= 0;
        SEG[5] <= 0;
        SEG[6] <= 0;
        SEG[7] <= 0;
    end

    //Atribuindo valor dos 4 primeiros bits de input para a variavel "entrada"
    always_comb begin
        entrada <= SWI[5:0];
    end

    always_comb begin
        //Atribuindo conexões à variável "nota"
        nota[0] <= SWI[0];
        nota[1] <= SWI[1];
        nota[2] <= SWI[2];
        nota[3] <= SWI[3];
    end

    always_comb begin
        //Ativando exibição de números
        if (SWI[7] == 0) begin
            //Configurando o "0" no display:
            if (entrada == 0)
                for (i = 0; i < 7; i++)
                   SEG[i] <= (i != 6);
            
            //Configurando o "1" no display:
            else if (entrada == 1) begin
                for ( i = 0; i < 7; i++) begin
                    SEG[i] <= (i == 1 || i == 2);
                end
            end

            //Configurando o "2" no display:
            else if (entrada == 2) begin
                for (i = 0; i < 7; i++) begin
                    SEG[i] <= (i != 2 && i != 5);
                end
            end

            //Configurando o "3" no display:
            else if (entrada == 3) begin
                for (i = 0; i < 7; i++) begin
                    SEG[i] <= (i != 4 && i != 5);
                end
            end

            //Configurando o "4" no display:
            else if (entrada == 4) begin
                for (i = 0; i < 7; i++) begin
                    SEG[i] <= (i != 0 && i != 3 && i != 4);
                end
            end

            //Configurando o "5" no display:
            else if (entrada == 5) begin
                for (i = 0; i < 7; i++) begin
                    SEG[i] <= (i != 1 && i != 4);
                end
            end

            //Configurando o "6" no display:
            else if (entrada == 6) begin
                for (i = 0; i < 7; i++) begin
                    SEG[i] <= (i != 1);
                end
            end

            //Configurando o "7" no display:
            else if (entrada == 7) begin
                for (i = 0; i < 7; i++) begin
                    SEG[i] <= (i == 0 || i == 1 || i == 2);
                end
            end

            //Configurando o "8" no display:
            else if (entrada == 8) begin
                for (i = 0; i < 7; i++) begin
                    SEG[i] <= 1;
                end
            end

            //Configurando o "9" no display:
            else if (entrada == 9) begin
                for (i = 0; i < 7; i++) begin
                    SEG[i] <= (i != 4);
                end
            end


            //---------------------------------------
            //NÚMEROS HEXADECIMAIS
            //---------------------------------------

            //Configurando o "A" no display:
            else if (entrada == 10) begin
                for (i = 0; i < 7; i++) begin
                    SEG[i] <= (i != 3);
                end
            end

            //Configurando o "B" no display:
            else if (entrada == 11) begin
                for (i = 0; i < 7; i++) begin
                    SEG[i] <= (i != 0 && i != 1);
                end
            end

            //Configurando o "C" no display:
            else if (entrada == 12) begin
                for (i = 0; i < 7; i++) begin
                    SEG[i] <= (i != 1 && i != 2 && i != 6);
                end
            end

            //Configurando o "D" no display:
            else if (entrada == 13) begin
                for (i = 0; i < 7; i++) begin
                    SEG[i] <= (i != 0 && i != 5);
                end
            end

            //Configurando o "E" no display:
            else if (entrada == 14) begin
                for (i = 0; i < 7; i++) begin
                    SEG[i] <= (i != 1 && i != 2);
                end
            end

            //Configurando o "F" no display:
            else if (entrada == 15) begin
                for (i = 0; i < 7; i++) begin
                    SEG[i] <= (i != 1 && i != 2 && i != 3);
                end
            end


            //---------------------------------------
            //LETRAS E SÍMBOLOS
            //---------------------------------------

            //Configurando o "A" no display:
            else if (entrada == 16) begin
                for (i = 0; i < 7; i++) begin
                    SEG[i] <= (i != 3);
                end
            end

            //Configurando o "b" no display:
            else if (entrada == 17) begin
                for (i = 0; i < 7; i++) begin
                    SEG[i] <= (i != 0 && i != 1);
                end
            end

            //Configurando o "C" no display:
            else if (entrada == 18) begin
                for (i = 0; i < 7; i++) begin
                    SEG[i] <= (i != 1 && i != 2 && i != 6);
                end
            end

            //Configurando o "c" no display:
            else if (entrada == 19) begin
                for (i = 0; i < 7; i++) begin
                    SEG[i] <= (i == 3 || i == 4 || i == 6);
                end
            end

            //Configurando o "d" no display:
            else if (entrada == 20) begin
                for (i = 0; i < 7; i++) begin
                    SEG[i] <= (i != 0 && i != 5);
                end
            end

            //Configurando o "E" no display:
            else if (entrada == 21) begin
                for (i = 0; i < 7; i++) begin
                    SEG[i] <= (i != 1 && i != 2);
                end
            end

            //Configurando o "F" no display:
            else if (entrada == 22) begin
                for (i = 0; i < 7; i++) begin
                    SEG[i] <= (i != 1 && i != 2 && i != 3);
                end
            end

            //Configurando o "g" no display:
            else if (entrada == 23) begin
                for (i = 0; i < 7; i++) begin
                    SEG[i] <= (i != 4);
                end
            end

            //Configurando o "x" no display:
            else if (entrada == 24) begin
                for (i = 0; i < 7; i++) begin
                    SEG[i] <= (i != 0 && i != 3);
                end
            end

            //Configurando o "h" no display:
            else if (entrada == 25) begin
                for (i = 0; i < 7; i++) begin
                    SEG[i] <= (i != 0 && i != 1 && i != 3);
                end
            end

            //Configurando o "i" no display:
            else if (entrada == 26) begin
                for (i = 0; i < 7; i++) begin
                    SEG[i] <= (i == 2);
                end
            end

            //Configurando o "I" no display:
            else if (entrada == 27) begin
                for (i = 0; i < 7; i++) begin
                    SEG[i] <= (i == 1 || i == 2);
                end
            end

            //Configurando o "J" no display:
            else if (entrada == 28) begin
                for (i = 0; i < 7; i++) begin
                    SEG[i] <= (i != 0 && i != 5 && i != 6);
                end
            end

            //Configurando o "L" no display:
            else if (entrada == 29) begin
                for (i = 0; i < 7; i++) begin
                    SEG[i] <= (i == 3 || i == 4 || i == 5);
                end
            end

            //Configurando o "n" no display:
            else if (entrada == 30) begin
                for (i = 0; i < 7; i++) begin
                    SEG[i] <= (i == 2 || i == 4 || i == 6);
                end
            end

            //Configurando o "O" no display:
            else if (entrada == 31) begin
                for (i = 0; i < 7; i++) begin
                    SEG[i] <= (i != 6);
                end
            end

            //Configurando o "o" no display:
            else if (entrada == 32) begin
                for (i = 0; i < 7; i++) begin
                    SEG[i] <= (i != 0 && i != 1 && i != 5);
                end
            end

            //Configurando o "P" no display:
            else if (entrada == 33) begin
                for (i = 0; i < 7; i++) begin
                    SEG[i] <= (i != 2 && i != 3);
                end
            end

            //Configurando o "q" no display:
            else if (entrada == 34) begin
                for (i = 0; i < 7; i++) begin
                    SEG[i] <= (i != 3 && i != 4);
                end
            end

            //Configurando o "r" no display:
            else if (entrada == 35) begin
                for (i = 0; i < 7; i++) begin
                    SEG[i] <= (i == 4 || i == 6);
                end
            end

            //Configurando o "S" no display:
            else if (entrada == 36) begin
                for (i = 0; i < 7; i++) begin
                    SEG[i] <= (i != 1 && i != 4);
                end
            end

            //Configurando o "t" no display:
            else if (entrada == 37) begin
                for (i = 0; i < 7; i++) begin
                    SEG[i] <= (i != 0 && i != 1 && i != 2);
                end
            end

            //Configurando o "U" no display:
            else if (entrada == 38) begin
                for (i = 0; i < 7; i++) begin
                    SEG[i] <= (i != 0 && i != 6);
                end
            end

            //Configurando o "u" no display:
            else if (entrada == 39) begin
                for (i = 0; i < 7; i++) begin
                    SEG[i] <= (i == 2 || i == 3 || i == 4);
                end
            end

            //Configurando o "y" no display:
            else if (entrada == 40) begin
                for (i = 0; i < 7; i++) begin
                    SEG[i] <= (i != 0 && i != 4);
                end
            end

            //Configurando o "°" no display:
            else if (entrada == 41) begin
                for (i = 0; i < 7; i++) begin
                    SEG[i] <= (i != 2 && i != 3 && i != 4);
                end
            end

            //Desativando o display para qualquer outra entrada
            else begin
                for (i = 0; i < 7; i++) begin
                    SEG[i] <= 0;
                end
            end
        end


        //---------------------------------------
        //SITUAÇÃO DO ALUNO
        //---------------------------------------

        //Ativando exibição da situação do aluno
        else begin
            //Conexões de segmentos fixos
            SEG[0] <= 1;
            SEG[3] <= 0;
            SEG[4] <= 1;
            SEG[5] <= 1;
            SEG[6] <= 1;

            //Lógica dos segmentos variáveis
            SEG[1] <= (nota < 4) || (nota > 6);
            SEG[2] <= (nota > 6);
        end
    end
    
endmodule
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

    //Declarando variável de entrada
    logic [5:0] entrada;

    //Atribuindo valor dos 4 primeiros bits de input para a variavel "entrada"
    always_comb begin
        entrada <= SWI[5:0];
    end

    always_latch begin
        //Ativando exibição de números
        if (SWI[7] == 0) begin
            //Configurando o "0" no display:
            if (entrada == 0) begin
                for (int i = 0; i < 7; i++) begin
                    SEG[i] <= (i != 6);
                end
            end

            //Configurando o "1" no display:
            if (entrada == 1) begin
                for (int i = 0; i < 7; i++) begin
                    SEG[i] <= (i == 1 || i == 2);
                end
            end

            //Configurando o "2" no display:
            if (entrada == 2) begin
                for (int i = 0; i < 7; i++) begin
                    SEG[i] <= (i != 2 && i != 5);
                end
            end

            //Configurando o "3" no display:
            if (entrada == 3) begin
                for (int i = 0; i < 7; i++) begin
                    SEG[i] <= (i != 4 && i != 5);
                end
            end

            //Configurando o "4" no display:
            if (entrada == 4) begin
                for (int i = 0; i < 7; i++) begin
                    SEG[i] <= (i != 0 && i != 3 && i != 4);
                end
            end

            //Configurando o "5" no display:
            if (entrada == 5) begin
                for (int i = 0; i < 7; i++) begin
                    SEG[i] <= (i != 1 && i != 4);
                end
            end

            //Configurando o "6" no display:
            if (entrada == 6) begin
                for (int i = 0; i < 7; i++) begin
                    SEG[i] <= (i != 1);
                end
            end

            //Configurando o "7" no display:
            if (entrada == 7) begin
                for (int i = 0; i < 7; i++) begin
                    SEG[i] <= (i == 0 || i == 1 || i == 2);
                end
            end

            //Configurando o "8" no display:
            if (entrada == 8) begin
                for (int i = 0; i < 7; i++) begin
                    SEG[i] <= 1;
                end
            end

            //Configurando o "9" no display:
            if (entrada == 9) begin
                for (int i = 0; i < 7; i++) begin
                    SEG[i] <= (i != 4);
                end
            end


            //---------------------------------------
            //NÚMEROS HEXADECIMAIS
            //---------------------------------------

            //Configurando o "A" no display:
            if (entrada == 10) begin
                for (int i = 0; i < 7; i++) begin
                    SEG[i] <= (i != 3);
                end
            end

            //Configurando o "B" no display:
            if (entrada == 11) begin
                for (int i = 0; i < 7; i++) begin
                    SEG[i] <= (i != 0 && i != 1);
                end
            end

            //Configurando o "C" no display:
            if (entrada == 12) begin
                for (int i = 0; i < 7; i++) begin
                    SEG[i] <= (i != 1 && i != 2 && i != 6);
                end
            end

            //Configurando o "D" no display:
            if (entrada == 13) begin
                for (int i = 0; i < 7; i++) begin
                    SEG[i] <= (i != 0 && i != 5);
                end
            end

            //Configurando o "E" no display:
            if (entrada == 14) begin
                for (int i = 0; i < 7; i++) begin
                    SEG[i] <= (i != 1 && i != 2);
                end
            end

            //Configurando o "F" no display:
            if (entrada == 15) begin
                for (int i = 0; i < 7; i++) begin
                    SEG[i] <= (i != 1 && i != 2 && i != 3);
                end
            end

        end


        //---------------------------------------
        //LETRAS E SÍMBOLOS
        //---------------------------------------

        //Configurando o "A" no display:
        if (entrada == 16) begin
            for (int i = 0; i < 7; i++) begin
                SEG[i] <= (i != 3);
            end
        end

        //Configurando o "b" no display:
        if (entrada == 17) begin
            for (int i = 0; i < 7; i++) begin
                SEG[i] <= (i != 0 && i != 1);
            end
        end

        //Configurando o "C" no display:
        if (entrada == 18) begin
            for (int i = 0; i < 7; i++) begin
                SEG[i] <= (i != 1 && i != 2 && i != 6);
            end
        end

        //Configurando o "c" no display:
        if (entrada == 19) begin
            for (int i = 0; i < 7; i++) begin
                SEG[i] <= (i == 3 || i == 4 || i == 6);
            end
        end

        //Configurando o "d" no display:
        if (entrada == 20) begin
            for (int i = 0; i < 7; i++) begin
                SEG[i] <= (i != 0 && i != 5);
            end
        end

        //Configurando o "E" no display:
        if (entrada == 21) begin
            for (int i = 0; i < 7; i++) begin
                SEG[i] <= (i != 1 && i != 2);
            end
        end

        //Configurando o "F" no display:
        if (entrada == 22) begin
            for (int i = 0; i < 7; i++) begin
                SEG[i] <= (i != 1 && i != 2 && i != 3);
            end
        end

        //Configurando o "g" no display:
        if (entrada == 23) begin
            for (int i = 0; i < 7; i++) begin
                SEG[i] <= (i != 4);
            end
        end

        //Configurando o "x" no display:
        if (entrada == 24) begin
            for (int i = 0; i < 7; i++) begin
                SEG[i] <= (i != 0 && i != 3);
            end
        end

        //Configurando o "h" no display:
        if (entrada == 25) begin
            for (int i = 0; i < 7; i++) begin
                SEG[i] <= (i != 0 && i != 1 && i != 3);
            end
        end

        //Configurando o "i" no display:
        if (entrada == 26) begin
            for (int i = 0; i < 7; i++) begin
                SEG[i] <= (i == 2);
            end
        end

        //Configurando o "I" no display:
        if (entrada == 27) begin
            for (int i = 0; i < 7; i++) begin
                SEG[i] <= (i == 1 || i == 2);
            end
        end

        //Configurando o "J" no display:
        if (entrada == 28) begin
            for (int i = 0; i < 7; i++) begin
                SEG[i] <= (i != 0 && i != 5 && i != 6);
            end
        end

        //Configurando o "L" no display:
        if (entrada == 29) begin
            for (int i = 0; i < 7; i++) begin
                SEG[i] <= (i == 3 || i == 4 || i == 5);
            end
        end

        //Configurando o "n" no display:
        if (entrada == 30) begin
            for (int i = 0; i < 7; i++) begin
                SEG[i] <= (i == 2 || i == 4 || i == 6);
            end
        end

        //Configurando o "O" no display:
        if (entrada == 31) begin
            for (int i = 0; i < 7; i++) begin
                SEG[i] <= (i != 6);
            end
        end

        //Configurando o "o" no display:
        if (entrada == 32) begin
            for (int i = 0; i < 7; i++) begin
                SEG[i] <= (i != 0 && i != 1 && i != 5);
            end
        end

        //Configurando o "P" no display:
        if (entrada == 33) begin
            for (int i = 0; i < 7; i++) begin
                SEG[i] <= (i != 2 && i != 3);
            end
        end

        //Configurando o "q" no display:
        if (entrada == 34) begin
            for (int i = 0; i < 7; i++) begin
                SEG[i] <= (i != 3 && i != 4);
            end
        end

        //Configurando o "r" no display:
        if (entrada == 35) begin
            for (int i = 0; i < 7; i++) begin
                SEG[i] <= (i == 4 || i == 6);
            end
        end

        //Configurando o "S" no display:
        if (entrada == 36) begin
            for (int i = 0; i < 7; i++) begin
                SEG[i] <= (i != 1 && i != 4);
            end
        end

        //Configurando o "t" no display:
        if (entrada == 37) begin
            for (int i = 0; i < 7; i++) begin
                SEG[i] <= (i != 0 && i != 1 && i != 2);
            end
        end

        //Configurando o "U" no display:
        if (entrada == 38) begin
            for (int i = 0; i < 7; i++) begin
                SEG[i] <= (i != 0 && i != 6);
            end
        end

        //Configurando o "u" no display:
        if (entrada == 39) begin
            for (int i = 0; i < 7; i++) begin
                SEG[i] <= (i == 2 || i == 3 || i == 4);
            end
        end

        //Configurando o "y" no display:
        if (entrada == 40) begin
            for (int i = 0; i < 7; i++) begin
                SEG[i] <= (i != 0 && i != 4);
            end
        end

        //Configurando o "°" no display:
        if (entrada == 41) begin
            for (int i = 0; i < 7; i++) begin
                SEG[i] <= (i != 2 && i != 3 && i != 4);
            end
        end


        //---------------------------------------
        //SITUAÇÃO DO ALUNO
        //---------------------------------------

        //Ativando exibição da situação do aluno
        if (SWI[7] == 1) begin
            //Declarando variável de entrada
            logic [3:0] nota;

            //Colocando o valor de entrada em uma variável
            nota[0] <= SWI[0];
            nota[1] <= SWI[1];
            nota[2] <= SWI[2];
            nota[3] <= SWI[3];

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

//Enock Bezerra Ferreira de Souza
//Tabela de HDL: Soma e Multiplicação


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

    //Declarações
    logic num, sinal_negativo;
    int i;

    //Definindo nums
    always_comb begin
        num <= SWI[2:0];
        sinal_negativo <= SWI[3];
    end

    always_comb begin
        //Verificando se o quarto bit de num que representa o sinal se encontra ativado
        if (sinal_negativo)
            SEG[7] <= 1;
        else
            SEG[7] <= 0;
    end

    always_comb begin
        //Configurando o "0" no display:
        if (num == 0)
            for (i = 0; i < 7; i++)
                SEG[i] <= (i != 6);
        
        //Configurando o "1" no display:
        else if (num == 1) begin
            for ( i = 0; i < 7; i++) begin
                SEG[i] <= (i == 1 || i == 2);
            end
        end

        //Configurando o "2" no display:
        else if (num == 2) begin
            for (i = 0; i < 7; i++) begin
                SEG[i] <= (i != 2 && i != 5);
            end
        end

        //Configurando o "3" no display:
        else if (num == 3) begin
            for (i = 0; i < 7; i++) begin
                SEG[i] <= (i != 4 && i != 5);
            end
        end

        //Configurando o "4" no display:
        else if (num == 4) begin
            for (i = 0; i < 7; i++) begin
                SEG[i] <= (i != 0 && i != 3 && i != 4);
            end
        end

        //Configurando o "5" no display:
        else if (num == 5) begin
            for (i = 0; i < 7; i++) begin
                SEG[i] <= (i != 1 && i != 4);
            end
        end

        //Configurando o "6" no display:
        else if (num == 6) begin
            for (i = 0; i < 7; i++) begin
                SEG[i] <= (i != 1);
            end
        end

        //Configurando o "7" no display:
        else if (num == 7) begin
            for (i = 0; i < 7; i++) begin
                SEG[i] <= (i == 0 || i == 1 || i == 2);
            end
        end
    end




endmodule
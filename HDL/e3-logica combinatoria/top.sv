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
  // Exercício X - MODELO DE COMENTÁRIO
  //---------------------------------------------------------

  //Declarando variáveis de entrada

  //Declarando variáveis de saída

  //Conexões de entrada

  //Conexões de saída

  //Lógica do sistema


  //---------------------------------------------------------
  // Exercício 1 - FIM DE EXPEDIENTE
  //---------------------------------------------------------

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


  //Lógica do sistema (em estrutura condicional)
  always_comb
    /*sirene <= (noite && paradas) || (sexta && producao && paradas);*/

    if (paradas)
      if (noite) sirene <= 1;
      else if (producao)
        if (sexta) sirene <= 1;
        else sirene <= 0;
      else sirene <= 0;
    else sirene <= 0;

  //Ou seja, o LED de indice 2 (da direita para a equerda no simulador) deverá ser ativado se, e somente se, ocorrer ao menos uma das seguintes combinações de switchs ativados: 4 e 5; ou 5, 6 e 7.


  //---------------------------------------------------------
  // Exercício 2 - AGÊNCIA BANCÁRIA
  //---------------------------------------------------------

  //Declarando variáveis de entrada
  logic porta_cofre, relogio, interruptor;

  //Declarando variáveis de saída
  logic alarme;

  //Conexões de entrada
  always_comb begin
    porta_cofre <= SWI[0];
    relogio <= SWI[1];
    interruptor <= SWI[2];
  end

  //Conexões de saída
  always_comb
    SEG[0] <= alarme;

  //Lógica do sistema (hibrido com esturura condicional e lógica combinacional)
  always_comb
    if ( (porta_cofre && interruptor) ||
          (porta_cofre && !relogio) )
          alarme <= 1;
    else alarme <= 0;


  //Ou seja, o segmento 0 (alarme) será ativado se e somente se ao menos uma das seguintes combinações ocorrer: SWI[0] = 1 e SWI[2] = 1; ou SWI[0] = 1 e SWI[1] = 0.


  //---------------------------------------------------------
  // Exercício 3 - ESTUFA
  //---------------------------------------------------------

  //Declarando variáveis de entrada
  logic t1, t2;

  //Declarando variáveis de saída
  logic aquecedor, resfriador, inconsistencia;

  //Conexões de entrada
  always_comb begin
    t1 <= SWI[3];
    t2 <= SWI[4];
  end

  //Conexões de saída
  always_comb begin
    LED[6] <= aquecedor;
    LED[7] <= resfriador;
    SEG[7] <= inconsistencia;
  end

  //Lógica do sistema (em lógica combinacional)
  always_comb begin
    aquecedor <= !t1 && !t2; //Se a temperatura estiver abaixo de 15 e 20 graus simultaneamente (SWI[3] = 0 e SWI[4] = 0) o aquecedor (LED[6]) será ativado.
    resfriador <= t1 && t2; //Se a temperatura estiver igual ou maior que 15 e 20 graus simultaneamente (SWI[3] = 1 e SWI[4] = 1) o resfriador (LED[7]) será ativado.
    inconsistencia <= !t1 && t2; //Se a temperatura estiver igual ou maior que 20 graus (SWI[4] = 1) e ao mesmo tempo estiver menor que 15 graus (SWI[3] = 0), então o indicador de insconsistência (SEG[7]) será ativado.
  end


  //---------------------------------------------------------
  // Exercício 4 - AERONAVE
  //---------------------------------------------------------

  //Declarando variáveis de entrada
  logic trancaF, trancaM1, trancaM2;

  //Declarando variáveis de saída
  logic livreF, livreM;

  //Conexões de entrada
  always_comb begin
    trancaF <= SWI[0];
    trancaM1 <= SWI[1];
    trancaM2 <= SWI[2];
  end

  //Conexões de saída
  always_comb begin
    LED[0] <= livreF;
    LED[1] <= livreM;
  end

  //Lógica do sistema (em lógica combinacional)
  always_comb begin
    livreF <= !trancaF || !trancaM1 || !trancaM2; //Se e somente se a tranca de pelo menos um dos banheiros (seja exclusivamente feminino ou não) estiver desativada (SWI[0] = 0 ou SWI[1] = 0 ou SWI[2] = 0), então haverá lavatório feminino livre (LED[0] = 1).
    livreM <= !trancaM1 || !trancaM2; //Se e somente se a tranca de pelo menos um dos dois banheiros masculinos estiver desativada (SWI[1] = 0 ou SWI[2] = 0), o lavatório masculino estará livre (LED[1] = 1).
  end

  //Obs: este exercício foi feito considerando que há um banheiro esclusivamente feminino, porém não um exclusivamente masculino

endmodule

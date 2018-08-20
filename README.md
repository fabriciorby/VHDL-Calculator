# VHDL
Projeto de uma Calculadora na linguagem VHDL.

## Introdução

### Equipamentos Utilizados no Projeto

* Teclado PS2
* Cyclone II: EP2C20F484C7

### Software Utilizado no Projeto
* Quartus II 13.0sp1

## Funcionalidades

* Capaz de realizar soma e subtração.

* Capacidade de utilização do último resultado como operando da próxima operação.

* Capacidade de realizar operações com operandos de até 12 bits.

* Capacidade de operar com números inteiros positivos e negativos no formato de complemento de 2.

* Indicação de overflow e underflow.

* Apresentação do resultado nos 4 displays de 7 segmentos.
* Controle de brilho dos displays de 7 segmentos.

* Entrada de dados pelo teclado com interface PS2.

## Manual de Utilização

Entre com um operando de até 12 bits (-2048 até 2047), então entre com um operador (+ ou -) e pressione “enter” para ver o resultado.

Ao entrar com um operador logo após uma operação é possível utilizar o valor retornado pela operação previamente realizada.

Caso o “enter” seja pressionado após uma operação ele a repetirá com último valor recebido.

É possível controlar o brilho do display com as chaves da placa (SW0 até SW7).

Caso o número seja negativo, luzes LEDG0 ao LEDG7 irão acender.

Caso a operação realizada resulte em overflow ou underflow, luzes LEDR0 ao LEDR9 irão acender, e será necessário resetar a placa.

Aperte KEY1 para resetar a placa.

## Organização do Projeto

O projeto foi dividido em 8 arquivos .vhd diferentes.

### calculadora.vhd

    Implementa a lógica da calculadora e importa todos os componentes, além de executar toda parte de IO.
    
    Entrada: todo mapeamento de input do pin planner.

    Saída: todo mapeamento de output pin planner.

### binary_to_bcd.vhd
    Conversão de número binário para binary-coded decimal (BCD), utilizando-se o algoritmo double dabble.
    
    Entrada: um número binário de 12 bits (STD_LOGIC_VECTOR).

    Saída: quatro números binários de 4 bits (STD_LOGIC_VECTOR).

### conv_7seg.vhd
    Conversão de um número binário para * representação no display de 7 segmentos.
    
    Entrada: um número binário de 4 bits (STD_LOGIC_VECTOR).

    Saída: um vetor de 7 bits (STD_LOGIC_VECTOR) com as informações para o HEX[0~3] da placa.

### conv_calc.vhd
    Conversão da entrada do teclado PS2 para número/comando/operador.
    
    Entrada: um vetor de 8 bits (STD_LOGIC_VECTOR), que * representa parte do scancode do teclado PS2.
    
    Saída: um vetor de 4 bits (STD_LOGIC_VECTOR), relacionado ao número/comando/operador digitado.

### PWM.vhd
    Controlador da intensidade do brilho do display de 7 segmentos.

    Entrada: 
        1. bit (STD_LOGIC), que representa o clock.
        2. bit (STD_LOGIC), que representa o reset.
        3. bit (STD_LOGIC), que representa o enable.
        4. vetor de 8 bits (STD_LOGIC_VECTOR), que representa o DUTY, relacionado diretamente ao SW[0~7] da placa.
        5. vetor de 16 bits (STD_LOGIC_VECTOR), que representa os 4 dígitos de 4 bits que irão aparecer no display de 7 segmentos.
    
    Saída: um vetor de 16 bits (STD_LOGIC_VECTOR), que representa os 4 dígitos de 4 bits que irão aparecer no display de 7 segmentos, porém com o brilho controlado de acordo com o DUTY.

Para utilização do teclado foi importado uma biblioteca compostas pelos seguintes arquivos:

        kbdex_ctrl.vhd
        keyboard.vhd
        ps2_iobase.vhd
 
## Algoritmos implementados, porém não integrados

### testaSomador.vhd
    Componente que recebe duas entradas, retorna sua soma e se houve overflow/underflow.

    Entrada: dois números binários de 12 bits (STD_LOGIC_VECTOR) e um GENERIC (tamanho do vetor de bits).

    Saída: um número binário de 12 bits (STD_LOGIC_VECTOR) e um bit (STD_LOGIC) que indica se houve overflow/underflow.

    Obersvação: este componente importa os seguintes outros:
        SomadorBinarioParalelo.vhd
        SomadorBinarioCompleto.vhd


Pela falta de integração, hoje o projeto executa sua soma de forma interna com a biblioteca STD_LOGIC_UNSIGNED.

## Pin Planner

Ver .pdf disponível na raiz do projeto.

## Problemas Identificados e Não Resolvidos

A soma atualmente é feita via biblioteca STD_LOGIC_UNSIGNED, pois não obtive sucesso ao integrar o meu algoritmo de SomadorBinarioParalelo. Este que está funcionando perfeitamente de forma isolada, com implementação de GENERIC, inclusive indicando overflow e underflow, comprovado por testes.

Era possível fazer multiplicação e subtração com a utilização de SIGNED, entretanto, ao tentar aplicar o multiplicador com algoritmo de Booth, essa funcionalidade foi retirada da calculadora. E, infelizmente, até o momento (20 de agosto) não consegui finalizar a implementação do algoritmo de Booth. 

Aparentemente o sistema do distribuidor do software Quartus II 13.0sp1 está fora do ar até hoje para recuperação de senha, me impossibilitando de fazer o download do software na minha casa em São Paulo, tendo apenas em meu notebook, que fica em Santo André, o que me atrapalhou consideravelmente durante um final de semana inteiro, que codifiquei apenas utilizando um editor de texto.

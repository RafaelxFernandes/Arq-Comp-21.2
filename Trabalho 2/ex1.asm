;---------------------------------------------------------------------------------------------
;
; Programa:Escrever uma rotina para somar ou para multiplicar
;          dois números de 8 bits em complemento a dois,
;          cujos endereços são passados como parâmetros na pilha.
;          O resultado deve ser devolvido no endereço de uma variável de 16 bits
;          também passado como parâmetro na pilha.
;          Já no acumulador a rotina recebe um parâmetro indicando a operação a ser realizada
;          e retorna a informação se houve overflow.
;          Indique claramente as opções escolhidas para o parâmetro passado e
;          retornado no acumulador, além da ordem dos parâmetros na pilha.
;
; Falta:
; - tratar números cujo resultado é maior do que 16 bits
; - resultado deve ser devolvido no endereço de uma variável de 16 bits também passada na pilha
; - retornar a informação se houve overflow
; - jeito inteligente para a multiplicação
;
;---------------------------------------------------------------------------------------------

ORG 0
    ; Armazena o endereço de NUM1 na pilha
    LDA PTR
    PUSH

    ; Armazena o endereço de NUM2 na pilha
    ADD #1
    PUSH

    ; Armazena o endereço de DECISOR na pilha
    LDA PTR_DECISOR
    PUSH

    JSR ROTINA

    HLT


ROTINA:
       ; Salva o valor de retorno da rotina
       POP
       STA ROTINA_RET

       ; Salva NUM2 em VAR2
       POP
       STA PTR_AUX
       LDA @PTR_AUX
       STA VAR2

       ; Salva NUM1 em VAR1
       POP
       STA PTR_AUX
       LDA @PTR_AUX
       STA VAR1

       ; Salva DECISOR em VAR_DECISOR
       POP
       STA PTR_AUX
       LDA @PTR_AUX
       STA VAR_DECISOR

       JMP TESTES

       ; Coloca os endereços de retorno para serem utilizados no final
       LDA ROTINA_RET
       PUSH


TESTES:
       ; Se der 0, VAR1 é positivo
       LDA VAR1
       AND #128
       JNZ NEGATIVO

       ; Se der 0, VAR2 é positivo
       LDA VAR2
       AND #128
       JNZ NEGATIVO


NEGATIVO:
         ; Se der 0, VAR2 é positivo
         LDA VAR1
         AND #128
         STA VAR1

         ; Se der 0, VAR2 é positivo
         LDA VAR2
         AND #128
         STA VAR2

         ; Se DECISOR != 0 vai para SOMA
         LDA DECISOR
         SUB #1
         JNZ SOMA


MULTIPLICA:
           LDA PTR_SOMARESULT
           PUSH

           ; Se o multiplicador está zerado retorna
           LDA NUM1
           OR NUM1 + 1
           OR #0
           JZ RETORNA

           LDA MULTRESULT            ; Pega o byte menos significativo
           ADD NUM2                  ; Soma o byte menos significativo com o multiplicando
           STA MULTRESULT            ; Guarda o resultado

           LDA NUM2 + 1

           ; Pega o byte mais significativo
           ; e soma o carry (1 caso a soma anterior dê overflow)
           ADC MULTRESULT + 1
           STA MULTRESULT + 1

           ; Subtrai 1 do multiplicador
           LDA NUM1
           SUB #1
           STA NUM1

           ; Pega o byte mais significativo do multiplicador
           ; e subtrai o carry (1 caso a soma anterior dê overflow)
           LDA NUM1 + 1

           SBC #0
           STA NUM1 + 1

           JMP MULTIPLICA


SOMA:
     LDA SOMARESULT
     ADD NUM1
     STA SOMARESULT

     LDA SOMARESULT
     ADD NUM2
     STA SOMARESULT

     HLT


; Retona para o PC onde a rotina foi chamada
RETORNA:
        HLT



; |================================================|
; | Declaração das variáveis do programa principal |
; |================================================|
ORG 100h

; Números a serem calculados (intervalo de -128 a 255)
NUM1: DW -4
NUM2: DW 3

; Decide se o cálculo efetuado será soma (0) ou multiplicação (1)
DECISOR: DW 0
;DECISOR: DW 1

; Ponteiro para armazenar o endereço dos números
PTR: DW NUM1
PTR_DECISOR: DW DECISOR

; Variáveis da rotina
VAR1: DW 0
VAR2: DW 0
VAR_DECISOR: DW 0

; Ponteiro auxiliar
PTR_AUX: DS 1

; Variável para armazenar o SP
ROTINA_RET: DS 2

; Variáveis auxiliares para realizar a soma
SOMARESULT: DS 3

; Variáveis auxiliares para realizar a multiplicação
MULTRESULT: DS 4
MULTCOUNTER: DS 4

; Ponteiro para armazenar o endereço dos resultados
PTR_SOMARESULT: DW SOMARESULT
PTR_MULTRESULT: DW MULTRESULT













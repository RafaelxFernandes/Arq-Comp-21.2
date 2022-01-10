;---------------------------------------------------------------------------------------------
;
; Programa:Escrever um programa para calcular o produto interno de dois vetores
; com elementos de 8 bits em complemento a dois. O resultado final deve ser armazenado
; em uma variável de 16 bits e impresso no banner, indicando se houve overflow.
;
;---------------------------------------------------------------------------------------------

ORG 0
    ; Limpa o banner
    OUT 3

    JSR MULTIPLICA

    HLT


MULTIPLICA:
           ; Calcula o endereço de VET1[I1]
           LDA #VET1
           ADD I1
           STA PT_VET1
           LDA @PT_VET1
           OUT 0

           ; Se o multiplicador está zerado, inicia a soma
           OR @PT_VET1 + 1
           OR #0
           JZ SOMA

           ; Calcula o endereço de VET2[I2]
           LDA #VET2
           ADD I2
           STA PT_VET2
           LDA @PT_VET2

           LDA MULTRESULT            ; Pega o byte menos significativo
           ADD @PT_VET2              ; Soma o byte menos significativo com o multiplicando
           STA MULTRESULT            ; Guarda o resultado

           LDA @PT_VET2 + 1

           ; Pega o byte mais significativo
           ; e soma o carry (1 caso a soma anterior dê overflow)
           ADC MULTRESULT + 1
           STA MULTRESULT + 1

           ; Subtrai 1 do multiplicador
           LDA @PT_VET1
           SUB #1
           STA @PT_VET1

           ; Pega o byte mais significativo do multiplicador
           ; e subtrai o carry (1 caso a soma anterior dê overflow)
           LDA @PT_VET1 + 1

           SBC #0
           STA @PT_VET1 + 1

           JC OVERFLOW

           JMP MULTIPLICA


SOMA:
     LDA PRODINTRESULT
     ADD MULTRESULT
     STA PRODINTRESULT

     JC OVERFLOW

     ; Incrementa o índice I1
     LDA I1
     ADD #1
     STA I1

     ; Incrementa o índice I2
     LDA I2
     ADD #1
     STA I2

     ; Repete até que I1 = 3
     LDA I1
     SUB #3
     JNZ MULTIPLICA

     HLT


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


OVERFLOW:
     LDA     @PTR_MSG

     OR      #0
     JZ      RETORNA

     OUT     2

     LDA     PTR_MSG
     ADD     #1
     STA     PTR_MSG

     LDA     PTR_MSG + 1
     ADC     #0
     STA     PTR_MSG + 1

     JMP     OVERFLOW


; Retona para o PC onde a rotina foi chamada
RETORNA:
        ; Mostra o total do produto interno no visor
        LDA PRODINTRESULT
        OUT 0

        HLT


; |================================================|
; | Declaração das variáveis do programa principal |
; |================================================|
ORG 100h

; Vetores
VET1: DB 1, 2, 3
VET2: DB 2, 3, 4

; Variáveis de índice
I1: DB 0
I2: DB 0

; Ponteiros dos vetores
PT_VET1: DB 0
PT_VET2: DB 0

; Variáveis da rotina
VAR1: DW 0
VAR2: DW 0

; Variáveis auxiliares para realizar a soma
SOMARESULT: DS 2

; Variáveis auxiliares para realizar a multiplicação
MULTRESULT: DS 3

; Variável que armazena o resultado final do produto interno
PRODINTRESULT: DS 4

; Mensagem de overflow e ponteiro correspondente
MSG: STR "Houve overflow"
PTR_MSG: DW MSG




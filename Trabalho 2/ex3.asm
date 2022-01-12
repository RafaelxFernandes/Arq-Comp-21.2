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
           ; Calcula o endereço do elemento atual de VET1
           LDA @PT_VET1

           ; Se o multiplicador está zerado, inicia a soma
           OR #0
           JZ SOMA

           LDA PRODINTRESULT            ; Pega o byte menos significativo
           ADD @PT_VET2                 ; Soma o byte menos significativo com o multiplicando
           STA PRODINTRESULT            ; Guarda o resultado

           JC OVERFLOW

           ; Pega o byte mais significativo
           ; e soma o carry (1 caso a soma anterior dê overflow)
           LDA @PT_VET2 + 1
           ADC PRODINTRESULT + 1
           STA PRODINTRESULT + 1

           ; Subtrai 1 do multiplicador
           LDA @PT_VET1
           SUB #1
           STA @PT_VET1

           JMP MULTIPLICA


SOMA:
     LDA PRODINTRESULT
     JC OVERFLOW

     ; Itera sobre o PT_VET1
     LDA PT_VET1
     ADD #1
     STA PT_VET1

     ; Itera sobre o PT_VET2
     LDA PT_VET2
     ADD #1
     STA PT_VET2

     ; Incrementa o índice CONT
     LDA CONT
     ADD #1
     STA CONT

     ; Repete até que CONT = 20
     LDA CONT
     SUB #20
     JNZ MULTIPLICA

     JMP RETORNA


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
; Exemplo sem overflow
;VET1: DB 1, 2, 3
;VET2: DB 4, 5, 6

; Exemplo com overflow
VET1: DB 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20
VET2: DB 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21

; Ponteiros dos vetores
PT_VET1: DW VET1
PT_VET2: DW VET2

; Contador para o loop
CONT: DB 0

; Variável que armazena o resultado final do produto interno
PRODINTRESULT: DS 2

; Mensagem de overflow e ponteiro correspondente
MSG: STR "Houve overflow"
PTR_MSG: DW MSG




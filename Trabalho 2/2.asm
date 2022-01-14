;-------------------------------------
; Programa para escrever uma cadeia no banner
; Autor: José Antonio Borges
; Data:  2017
;---------------------------------------
ORG 0
BINARIO:  DW    1487
          DW    3050

CONT_BINARIO: DB 4

PTR_BINARIO: DW BINARIO

NUMERO:  DS     4
         DB     0                    ; Termina com NULL
PTR_NUMERO:     DW     NUMERO


INICIO:
        OUT     CLEARBANNER

ESCREVE_EM_NUMERO:
        LDA     @PTR_BINARIO
        STA     @PTR_NUMERO
        LDA     PTR_BINARIO
        ADD     #1
        STA     PTR_BINARIO
        LDA     PTR_NUMERO
        ADD     #1
        STA     PTR_NUMERO
        LDA     CONT_BINARIO
        SUB     #1
        STA     CONT_BINARIO
        OR      #0
        JZ      RESETA_PTR
        JMP     ESCREVE_EM_NUMERO

RESETA_PTR:
        LDA     #NUMERO
        STA     PTR_NUMERO

LOOP:
        LDA     @PTR_NUMERO             ; Le um caractere
        OR      #0               ; Se for NULL
        JZ      FIM              ; Termina
        OUT     BANNER           ; Senão escreve no banner
        LDA     #CONSOLEWRITE    ;
        TRAP    @PTR_NUMERO             ; Escreve também na console
; Incrementa o ponteiro
        LDA     PTR_NUMERO
        ADD     #1
        STA     PTR_NUMERO
; Vai para o laço
        JMP     LOOP
FIM:    HLT
        END     INICIO



;------------------------------------------------------
; constantes de hardware
CLEARBANNER   EQU 3
BANNER        EQU 2
; constantes de trap
CONSOLEWRITE  EQU 2
;------------------------------------------------------

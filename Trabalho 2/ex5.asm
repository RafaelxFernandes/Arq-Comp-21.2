;-------------------------------------
; Programa para inserir uma cadeia de caracteres em uma lista encadeada ordenada
; Autores: Rafael Fernandes e Ronald Albert
; Data:  2021
;---------------------------------------
ORG 0
SP: DW 0


PTR_STRUCT: DW  PALAVRA1
PTR_ANTERIOR: DW 0

PALAVRA1: STR "ABCDEFGH"
          DW  PALAVRA2

PALAVRA2: STR "BCDEFGHI"
          DW  PALAVRA3

PALAVRA3: STR "CDEFGHIJ"
          DW  PALAVRA4

PALAVRA4: STR "DEFGHIJK"
          DW  0

PALAVRA:  STR "Aonald A"
          DW  0
PTR:      DW  PALAVRA

TAM_PALAVRA EQU 8
PARAM1:   DW     0
PARAM2:   DW     0


INICIO:
          LDA PTR
          PUSH
          LDA PTR_STRUCT
          PUSH
          JSR COMPARA_CADEIAS
          JZ  INSERE_PALAVRA
          LDA PTR_STRUCT
          STA PTR_ANTERIOR
          ADD #TAM_PALAVRA
          STA PTR_STRUCT
          LDA @PTR_STRUCT
          STA PTR_STRUCT
          OR  #0
          JZ  FIM
          JMP INICIO
          HLT

INSERE_PALAVRA:
          LDA PTR_ANTERIOR
          ADD #TAM_PALAVRA
          STA PTR_ANTERIOR
          LDA PTR
          STA @PTR_ANTERIOR
          LDA PTR
          ADD #TAM_PALAVRA
          STA PTR
          LDA PTR_STRUCT
          STA @PTR

FIM:      HLT

COMPARA_CADEIAS:
        STS SP
        POP
        POP
        POP
        STA PARAM2
        POP
        STA PARAM1

        CHECA_FIM:                       ; Primeira etapa: checa se uma das duas strings chegou ao fim, o programa só vai cair em um desses dois
                                         ; casos, se lermos todos os caracteres de ambas as strings e eles forem todos iguais, assim consideramos
                                         ; que a cadeia que acaba primeiro é menor na comparação alfabética.
                LDA     @PARAM1            ; Lê um caractere da primeira string
                OR      #0               ; Checa se a primeira string chegou ao fim
                JZ      FIM1             ; Se sim, assumimos que a primeira string está na frente na ordenação
                LDA     @PARAM2            ; Lê um caractere da segunda string
                OR      #0               ; Checa se a segunda string chegou ao fim
                JZ      FIM2             ; Se sim, assumimos que a segunda string está na frente na ordenação

        CHECA_ORDEM:                     ; Segunda etapa: checa a ordenação das strings usando a tabela ascii, se o código ascii do atual caractere
                                         ; da primeira cadeia for menor que o código ascii do atual caractere da segunda cadeia, retornamos que a primeira
                                         ; cadeia está é menor na comparação alfabética, e vice-versa.
                LDA     @PARAM1          ; Lê o corrente caractere da primeira string
                SUB     @PARAM2          ; Subtrai do corrente caractere da segunda string
                JN      FIM1             ; Checa se o resultado da subtração é negativo
                LDA     @PARAM2          ; Lê o corrente caractere da segunda string
                SUB     @PARAM1          ; Subtrai do corrente caractere da primeira string
                JN      FIM2             ;Checa se o resultado da subtração é negativo

        INCREMENTA:                      ; Terceira etapa: incrementamos os apontadores de ambas as cadeias de caracteres e voltamos para a
                                         ; primeira etapa.
                LDA     PARAM1
                ADD     #1
                STA     PARAM1
                LDA     PARAM2
                ADD     #1
                STA     PARAM2
                JMP     CHECA_FIM


        FIM1:   LDA     #0
                LDS SP
                RET

        FIM2:   LDA     #1
                LDS SP
                RET

END INICIO


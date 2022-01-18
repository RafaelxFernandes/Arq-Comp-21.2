;-------------------------------------
; Programa para inserir uma cadeia de caracteres em uma lista encadeada ordenada
; Autores: Rafael Fernandes e Ronald Albert
; Data:  2021
;---------------------------------------
ORG 0
SP: DW 0                                ; Stack Pointer


PTR_STRUCT: DW  PALAVRA1                ; Ponteiro da estrutura
PTR_ANTERIOR: DW 0                      ; Ponteiro que aponta para a palavra anterior à palavra apontada por PTR_STRUCT

PALAVRA1: STR "ABCDEFGH"                ; Primeira palavra da estrutura
          DW  PALAVRA2                  ; Endereço da segunda palavra na estrutura

PALAVRA2: STR "BCDEFGHI"                ; Segunda palavra da estrutura
          DW  PALAVRA3                  ; Endereço da terceira palavra na estrutura

PALAVRA3: STR "CDEFGHIJ"                ; Terceira palavra na estrutura
          DW  PALAVRA4                  ; Endereço da quarta palavra na estrutura

PALAVRA4: STR "DEFGHIJK"                ; Quarta palavra na estrutura
          DW  0                         ; Fim da estrutura

PALAVRA:  STR "DDnald A"                ; Palavra a ser inserida na lista encadeada
          DW  0                         ; Fim da palavra (ao final será o fim da estrutura ao terá o endereço da palavra seguinte)

PTR:      DW  PALAVRA                   ; Ponteiro da palavra a ser inserida na estrutura

TAM_PALAVRA EQU 8                       ; Variável que armazena o tamanho das palavras da estrutura 8 caracteres (8 bytes)

PARAM1:   DW     0                      ; Parâmetro 1 da função de comparar cadeias de caracteres
PARAM2:   DW     0                      ; Parâmetro 2 da função de comparar cadeias de caracteres


INICIO:
          LDA PTR                       ; Carregando o ponteiro da palavra a ser inserida no acumulador
          PUSH                          ; Damos push do ponteiro da palavra na pilha
          LDA PTR_STRUCT                ; Carregando o ponteiro da estrutura no acumulador
          PUSH                          ; Damos push do ponteiro da estrutura na pilha
          JSR COMPARA_CADEIAS           ; Comparamos a palavra da iteração atual na estrutura com a palavra a ser inserida na estrutura
                                        ; usando a função construída no exercício 4.
          JZ  INSERE_PALAVRA            ; Caso o retorno de COMPARA_CADEIAS seja zero, temos a palavra a ser inserida fica na frente
                                        ; da palavra atual na ordenação alfabética, ou seja, desviamos para INSERE_PALAVRA
          LDA PTR_STRUCT                ; Caso contrário, carregamos o PTR_STRUCT no acumulador
          STA PTR_ANTERIOR              ; Atualizamo o valor de PTR_ANTERIOR com o valor de PTR_STRUCT para mover para a próxima palavra
          ADD #TAM_PALAVRA              ; Somamos o tamanho da palavara ao acumulador, dessa forma, agora temos no acumulador o endereço
                                        ; que armazena o endereço da próxima palavra
          STA PTR_STRUCT                ; Armazenamos tal endereço em PTR_STRUCT
          LDA @PTR_STRUCT               ; Carregamos o endereço apontado por PTR_STRUCT no acumulador
          STA PTR_STRUCT                ; E agora, de fato, PTR_STRUCT aponta para a próxima palavra na estrutura
          OR  #0                        ; Testa se é o fim da estrutura
          JZ  FIM                       ; Caso a estrutura tenha chegado ao fim, desvia para FIM
          JMP INICIO                    ; Caso contrário, vamos para a próxima iteração

INSERE_PALAVRA:                         ; Rotina de inserção da palavara na estrutura
          LDA PTR_ANTERIOR              ; Carregamos PTR_ANTERIOR
          ADD #TAM_PALAVRA              ; Adicionamos do tamanho da palavra
          STA PTR_ANTERIOR              ; E armazenamos em PTR_ANTERIOR, dessa forma, PTR_ANTERIOR, aponta para o apontador
                                        ; da palavra que foi checada na iteração corrente
          LDA PTR                       ; Carregamos o ponteiro para a palavra a ser inserida na estrutura no acumulador
          STA @PTR_ANTERIOR             ; e armazenamos o endereço dela no apontador da palavra anterior na estrutura
          ADD #TAM_PALAVRA              ; Somamos o valor de tamanho palavra
          STA PTR                       ; armazenado esse valor no ponteiro e então PTR aponta para o final da palavra a ser adicionada
          LDA PTR_STRUCT                ; o apontador para a seguinte na palavra na estrutura é carregador no acumulador
          STA @PTR                      ; e armazenado no endereço do final da palavra a ser adicionada.
          HLT

FIM:
          LDA PTR_ANTERIOR              ; Carregamos PTR_ANTERIOR
          ADD #TAM_PALAVRA              ; Adicionamos do tamanho da palavra
          STA PTR_ANTERIOR              ; E armazenamos em PTR_ANTERIOR, dessa forma, PTR_ANTERIOR, aponta para o apontador
                                        ; da palavra que foi checada na iteração corrente
          LDA PTR                       ; Carregamos o ponteiro para a palavra a ser inserida na estrutura no acumulador
          STA @PTR_ANTERIOR             ; e armazenamos o endereço dela no apontador da palavra anterior na estrutura
          HLT

COMPARA_CADEIAS:
        STS SP                           ; Carregamento dos parâmetros da função em PARAM1 e PARAM2
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


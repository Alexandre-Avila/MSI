


;######################################################################
;########## Programa para placa de sensores Com display 20X4 ##########
;######################################################################

;########## Declaração de variáveis ###########

; Declaração de variáveis para o display 80 caracteres, sendo 20 colunas X 4 linhas
;Linha 1



CARAC01	 EQU	32				; Caracter 1
CARAC02  EQU	33
CARAC03  EQU	34
CARAC04  EQU	35
CARAC05  EQU	36
CARAC06  EQU	37
CARAC07  EQU	38
CARAC08  EQU	39
CARAC09  EQU	40
CARAC10  EQU	41
CARAC11  EQU	42
CARAC12  EQU	43
CARAC13  EQU	44
CARAC14  EQU	45
CARAC15  EQU	46
CARAC16  EQU	47
CARAC17  EQU	48
CARAC18  EQU	49
CARAC19  EQU	50
CARAC20  EQU	51				; Caracter 20

TVAL1  	  EQU	52				; Variável genérica 1
TVAL2	  EQU	53				; Variável genérica 2
TVAL3	  EQU	54				; Variável genérica 3
VALAD	  EQU	55				; Variável que guarda o valor de leitura do A\D
NAD	  EQU	56				; Variável que guarda a seleção do A\D
VALAD01	  EQU   57				; Variável que guarda o primeiro algarismo relativo do A/D
VALAD02   EQU   58				; Variável que guarda o segundo  algarismo relativo do A/D
VALAD03   EQU   59				; Variável que guarda o terceiro algarismo relativo do A/D

;###################################################
;########## Inicio da memória de programa ##########
;###################################################

	ORG 	0000H				; Inicio da memória de programa

        LJMP    INICIO				; Desvia processamento para o inicio do programa (salta por cima das interrupções)
	
	ORG	0003H				; Endereço de desvio para interrupção externa0 
	RETI					; Retorna de subrotina de interrupção


	ORG	000BH				; Endereço de desvio para interrupção interna0 
	MOV	R7, #0FFH			; Move FF para o registrador
	


	RETI					; Retorna de subrotina de interrupção


	ORG	0013H				; Endereço de desvio para interrupção externa1
	RETI					; Retorna de subrotina de interrupção


	ORG	001BH				; Endereço de desvio para interrupção interna1
	RETI					; Retorna de subrotina de interrupção


	ORG	0023H				; Endereço de desvio de interrupção do canal serial
	RETI					; Retorna de subrotina de interrupção




;###########################################################
;##########  Início do programa propriamente dito ##########
;###########################################################


	
	ORG	30h				; Organiza memória apartir do endereço indicado, onde o programa começa, logo após as interrupções				



INICIO:						


;########## Inicialização da porta para A/D ##########
	CLR	P0.3
	CLR	P0.4
	CLR	P0.6
	MOV	NAD, #00
	MOV	VALAD01, #0
	MOV	VALAD02, #0	
	MOV	VALAD03, #0
;########## Configuração dos timers ##########

	MOV     089h, #00100010b		; Configura TMOD ( 2 timers com recarga automática)			
	SETB	EA				; Habilita todas as Interrupções
;	SETB	ET0				; Ativa timer 0
	SETB	PT0				; Ativa prioridade para temporizador 0
	MOV	TH0, #155			; Move valor de recarga do temporizador			
	MOV	TL0, #155			; Move valor de contagem do temporizador
;	SETB	TR0				; Ativa contagem no teporizador 0
	MOV	R7, #0				; Move valor imediato para o registrador
	CLR	RS0				; Zera valor da interrupção interna 0
	CLR	RS1				; Zera valor da interrupção interna 1


;####################  ROTINA DE INICIALIZAÇÃO DO DISPLAY ##################

INICDISPLAY:
	
	MOV     P1,#38H         		; Configura display com 2 linhas 5X7 8 bits
	CALL    FUNCDIS         		; Delay de 10ms
	
	MOV     P1,#38H   		      	; Configura display com 2 linhas 5X7 8 bits
	CALL    FUNCDIS         		; Delay de 10ms

	MOV     P1,#06H         		; Escreve deslocando o cursor para a direita
	CALL    FUNCDIS         		; Delay de 10ms
	
	MOV     P1,#0CH         		; Display aceso sem cursor
	CALL    FUNCDIS         		; Delay de 10ms
	
	MOV     P1,#01H         		; Limpa display e retorna o cursor para o inicio
	CALL    FUNCDIS         		; Delay de 10ms
	
	MOV     P1,#80H         		; Posiciona o cursor do display no primeiro caracter da primeira linha
	CALL    FUNCDIS         		; Delay de 10ms
	

        JMP     TELA11				; Salta para rotina endereçada



;#######################################################
;########## Subrotina de funções para display ##########
;#######################################################

LIMPDIS:
	MOV	P1, #01H
	CALL	FUNCDIS

LINHA01:
	MOV	P1, #080H
	CALL	FUNCDIS
	RET

LINHA02:
	MOV	P1, #0C0H
	CALL	FUNCDIS
	RET

LINHA03:
	MOV	P1, #094H
	CALL	FUNCDIS
	RET

LINHA04:
	MOV	P1, #0D4H
	CALL	FUNCDIS
	RET


FUNCDIS:					; Temporizador de 10ms para display

	MOV	R0, #170			; Define temporizador de display
	MOV	R1, #100			; Move valor imediato para o registrador 			
	MOV	R2, #100			; Move valor imediato para o registrador
	MOV	R3, #0				; Move valor imediato para o registrador
	CLR	P3.0				; Zera pino 0 da prota 3	
	SETB	P3.1				; Seta pino 1 da porta 3
	SETB	ET0				; Ativa interrupção interna 0
	SETB	TR0				; Ativa funcionamento do contador 0
	JMP	PRINCIPAL			; Salta para rotina endereçada

IMPDIS:						; Define temporizador de 50µs para display	
	MOV	R0, #170			; Define temporizador de display
	MOV	R1, #50				; Move valor imediato do temporizador para o registrador
  	MOV	R2, #0				; Move valor imediato do temporizador para o registrador
	MOV	R3, #0				; Move valor imediato do temporizador para o registrador
	SETB	P3.0				; Seta pino 0 da porta 3		
	SETB	P3.1				; seta pino 1 da porta 3
	SETB	ET0				; Ativa interrupção de temporizador
	SETB	TR0				; Dispara contagem
	JMP	PRINCIPAL			; Salta para rotina endereçada
		
	
DECTR1:
	MOV	R7, #0				; Move valor imediato para o registrador (desativa interrupção de software)	
	CJNE	R1, #0	,DECTR2			; Copara o onteúdo imediato com o registrador desvia se for diferente 
	CLR	P3.1				; Zera o pino 1 da porta P3 do processador
	CLR	ET0				; Desativa interrupção de temporirador
	CLR	TR0				; Pára temporizador
	MOV	R0, #0				; Desconfigura interrupção de temporizador de display
	RET					; Retorna da chamada da subrotina

DECTR2:
	CJNE	R2, #0	,DECTR3			; Copara o registrador ao dado imediato e desvia para subrotina
	DEC	R1				; Decrementa o registrador 
	JMP	PRINCIPAL			; Salta para rotina endereçada 

DECTR3:	
	CJNE	R3, #0	,DECTR4			; Copara o registrador ao dado imediato e desvia para subrotina
	DEC	R2				; Decrementa o registrador
	JMP	PRINCIPAL			; Salta para rotina endereçada
						
DECTR4:
	DEC	R3				; Decrementa o registrador
	JMP	PRINCIPAL			; Salta para rotina endereçada



;########## temporizador puro ##########


DEL1SEG:
	MOV	R0, #0FFH			; Define temporizador puro
	MOV	TVAL1, #100			; Carrega valor inicial imediato para temporizador
	MOV	TVAL2, #10			; Carrega valor inicial imediato para temporizador
	MOV	TVAL3, #0			; Carrega valor inicial imediato para temporizador
	MOV	R4, TVAL1			; Move valor inicial do temporizador para o registrador
	MOV	R5, TVAL2			; Move valor inicial do temporizador para o registrador
	MOV	R6, TVAL3			; Move valor inicial do temporizador para o registrador
	SETB	ET0				; Ativa temporizador 0 
	SETB	TR0				; Ativa contagem do temporizador
	JMP	DECTRX				; Salta para rotina

DEL02SEG:
	MOV	R0, #0FFH			; Define temporizador puro
	MOV	TVAL1, #100			; Carrega valor inicial imediato para temporizador
	MOV	TVAL2, #1			; Carrega valor inicial imediato para temporizador
	MOV	TVAL3, #1			; Carrega valor inicial imediato para temporizador
	MOV	R4, TVAL1			; Move valor inicial do temporizador para o registrador
	MOV	R5, TVAL2			; Move valor inicial do temporizador para o registrador
	MOV	R6, TVAL3			; Move valor inicial do temporizador para o registrador
	SETB	ET0				; Ativa temporizador 0 
	SETB	TR0				; Ativa contagem do temporizador
	JMP	DECTRX				; Salta para rotina

DECTRX:	
		
	MOV	R7, #0				; Move valor imediato para o registrador (desativa interrupção de software)			; 
	CJNE	R4, #0	,DECTRX1		; Copara o onteúdo imediato com o registrador desvia se for diferente
	MOV	R0, #0				; Desconfigura interrupção de temporizador de puro
	CLR	ET0				; Desativa interrupção de temporirador
	CLR	TR0				; Pára temporizador
	RET					; Retorna da chamada da subrotina

DECTRX1:
	CJNE    R5, #0	,DECTRX2	        ; Copara o onteúdo imediato com o registrador desvia se for diferente 
	DEC	R4				; Decrementa o registrador 
	MOV	R5, TVAL2			; Carrega valor inicial do registrador
	JMP	PRINCIPAL			; Salta para rotina principal

DECTRX2:
	CJNE	R6, #0	,DECTRX3		; Move valor imediato para o registrador (desativa interrupção de software)
	DEC	R5				; Decrementa o registrador
	MOV	R6, TVAL2			; Carrega valor inicial do registrador
	JMP	PRINCIPAL			; Salta para rotina endereçada
		
						
DECTRX3:
	DEC	R6				; Decrementa o registrador
	JMP	PRINCIPAL			; Salta para rotina endereçada



TNOP:						; Rotina para não fazer nada
	JMP	TNOP2

TNOP2:						; Laço de rotina para não fazer nada
	JMP	TNOP



DEFTEMP:					; Subrotina para determinar se é rotina de display ou temporizador puro
	CJNE	R0, #0,  TST2			; Copara o onteúdo imediato com o registrador desvia se for diferente ( se for =0 não foi acionada, se for =170 display, se for =FF teporizador puro) 		
	JMP	PRINCIPAL			; Salta para rotina endereçada


TST2:
	CJNE	R0, #170, TST3			; Copara o onteúdo imediato com o registrador desvia se for diferente ( se for =0 não foi acionada, se for =170 display, se for =FF teporizador puro) 
	JMP	DECTR1				; Salta para rotina de temporização de display

TST3
	CJNE	R0, #0FFH, PRINCIPAL		; Copara o onteúdo imediato com o registrador desvia se for diferente ( se for =0 não foi acionada, se for =170 display, se for =FF teporizador puro) 
	JMP	DECTRX				; Salta para rotina de temporização pura


;===============================
;########## Principal ##########
;===============================

Principal:
	
	
	CJNE	R7, #0, DEFTEMP			; Compara o registrador R7 (nesse caso diferente de zero existe pedido de interrupçaõ de software) e salta se estiver setado
	JNB	TR0, TECLADO			; Desvia para rotina de teclado se estiver zerado
	JMP	PRINCIPAL			; Salta para rotina endereçada

TECLADO:					; Rotina de atendimento de teclado
	

TEC1:
	JNB	P3.7, MENU1			; Verifica se tem tecla do teclado apertada e salta estiver
	
TEC2:	
	JNB	P3.6, MENU2			; Verifica se tem tecla do teclado apertada e salta estiver
            	
TEC3:
	JNB	P3.5, MENU3			; Verifica se tem tecla do teclado apertada e salta estiver
  
	JNB	P0.5, RAD			; Salta para Rotina de captura do valor do A/D se o EOC resetar o pino


	JMP	PRINCIPAL			; Salta para rotina endereçada




RAD:
	JMP	RVALAD


MENU1:						; Link para saltar mais de 128 bytes	
	JMP	BOTAO1				; Salta para rotina endereçada

MENU2:						; Link para saltar mais de 128 bytes
	JMP	BOTAO2				; Salta para rotina endereçada

MENU3:						; Link para saltar mais de 128 bytes
	JMP	BOTAO3				; Salta para rotina endereçada

	
BOTAO1:						; Rotina do botão 1	
	CALL	LINHA01				;12345678901234567890
	MOV	CARAC01, #'#'			;#### BOTAO "1" ##### 		
	MOV	CARAC02, #'#'
	MOV	CARAC03, #'#'
	MOV	CARAC04, #'#'
	MOV	CARAC05, #'#'
	MOV	CARAC06, #' '
	MOV	CARAC07, #'M'
	MOV	CARAC08, #'E'
	MOV	CARAC09, #'N'
	MOV	CARAC10, #'U'
	MOV	CARAC11, #' '			
	MOV	CARAC12, #'"'
	MOV	CARAC13, #'1'
	MOV	CARAC14, #'"'
	MOV	CARAC15, #' '
	MOV	CARAC16, #'#'
	MOV	CARAC17, #'#'
	MOV	CARAC18, #'#'
	MOV	CARAC19, #'#'
	MOV	CARAC20, #'#'
	CALL	VAREDIS

	CALL	LINHA02				;12345678901234567890
	MOV	CARAC01, #' '			;     PRECIONADO
	MOV	CARAC02, #'L'
	MOV	CARAC03, #'E'
	MOV	CARAC04, #'I'
	MOV	CARAC05, #'T'
	MOV	CARAC06, #'U'
	MOV	CARAC07, #'R'
	MOV	CARAC08, #'A'
	MOV	CARAC09, #' '
	MOV	CARAC10, #'D'
	MOV	CARAC11, #'E'			
	MOV	CARAC12, #' '
	MOV	CARAC13, #'S'
	MOV	CARAC14, #'E'
	MOV	CARAC15, #'N'
	MOV	CARAC16, #'S'
	MOV	CARAC17, #'O'
	MOV	CARAC18, #'R'
	MOV	CARAC19, #'E'
	MOV	CARAC20, #'S'
	CALL	VAREDIS	

	CALL	LIMPALINHA

	JMP	INICAD


	JMP	PRINCIPAL

BOTAO2:	
	CALL	LIMPDIS				; Rotina do botão 2
	CALL	LINHA01				;12345678901234567890
	MOV	CARAC01, #'#'			;#### BOTAO "2" ##### 		
	MOV	CARAC02, #'#'
	MOV	CARAC03, #'#'
	MOV	CARAC04, #'#'
	MOV	CARAC05, #' '
	MOV	CARAC06, #'B'
	MOV	CARAC07, #'O'
	MOV	CARAC08, #'T'
	MOV	CARAC09, #'A'
	MOV	CARAC10, #'O'
	MOV	CARAC11, #' '			
	MOV	CARAC12, #'"'
	MOV	CARAC13, #'2'
	MOV	CARAC14, #'"'
	MOV	CARAC15, #' '
	MOV	CARAC16, #'#'
	MOV	CARAC17, #'#'
	MOV	CARAC18, #'#'
	MOV	CARAC19, #'#'
	MOV	CARAC20, #'#'
	CALL	VAREDIS
	
	CALL 	LINHA02				;12345678901234567890
	MOV	CARAC01, #' '			;     PRECIONADO
	MOV	CARAC02, #' '
	MOV	CARAC03, #' '
	MOV	CARAC04, #' '
	MOV	CARAC05, #' '
	MOV	CARAC06, #'P'
	MOV	CARAC07, #'R'
	MOV	CARAC08, #'E'
	MOV	CARAC09, #'C'
	MOV	CARAC10, #'I'
	MOV	CARAC11, #'O'			
	MOV	CARAC12, #'N'
	MOV	CARAC13, #'A'
	MOV	CARAC14, #'D'
	MOV	CARAC15, #'O'
	MOV	CARAC16, #' '
	MOV	CARAC17, #' '
	MOV	CARAC18, #' '
	MOV	CARAC19, #' '
	MOV	CARAC20, #' '
	CALL	VAREDIS		
	JMP	PRINCIPAL

BOTAO3:						; Rotina do botão 3
	CALL	LINHA01				;12345678901234567890
	MOV	CARAC01, #'#'			;#### BOTAO "3" ##### 		
	MOV	CARAC02, #'#'
	MOV	CARAC03, #'#'
	MOV	CARAC04, #'#'
	MOV	CARAC05, #' '
	MOV	CARAC06, #'B'
	MOV	CARAC07, #'O'
	MOV	CARAC08, #'T'
	MOV	CARAC09, #'A'
	MOV	CARAC10, #'O'
	MOV	CARAC11, #' '			
	MOV	CARAC12, #'"'
	MOV	CARAC13, #'3'
	MOV	CARAC14, #'"'
	MOV	CARAC15, #' '
	MOV	CARAC16, #'#'
	MOV	CARAC17, #'#'
	MOV	CARAC18, #'#'
	MOV	CARAC19, #'#'
	MOV	CARAC20, #'#'
	CALL	VAREDIS
	
	CALL	LINHA02				;12345678901234567890
	MOV	CARAC01, #' '			;     PRECIONADO
	MOV	CARAC02, #' '
	MOV	CARAC03, #' '
	MOV	CARAC04, #' '
	MOV	CARAC05, #' '
	MOV	CARAC06, #'P'
	MOV	CARAC07, #'R'
	MOV	CARAC08, #'E'
	MOV	CARAC09, #'C'
	MOV	CARAC10, #'I'
	MOV	CARAC11, #'O'			
	MOV	CARAC12, #'N'
	MOV	CARAC13, #'A'
	MOV	CARAC14, #'D'
	MOV	CARAC15, #'O'
	MOV	CARAC16, #' '
	MOV	CARAC17, #' '
	MOV	CARAC18, #' '
	MOV	CARAC19, #' '
	MOV	CARAC20, #' '
	CALL	VAREDIS	
	JMP	PRINCIPAL

TELA11:						; Rotina de tela inicial
	CALL	LINHA01				; 12345678901234567890
	MOV	CARAC01, #' '			;    INICIALIZANDO			
	MOV	CARAC02, #' '
	MOV	CARAC03, #' '
	MOV	CARAC04, #'I'
	MOV	CARAC05, #'N'
	MOV	CARAC06, #'I'
	MOV	CARAC07, #'C'
	MOV	CARAC08, #'I'
	MOV	CARAC09, #'A'
	MOV	CARAC10, #'L'
	MOV	CARAC11, #'I'			
	MOV	CARAC12, #'Z'
	MOV	CARAC13, #'A'
	MOV	CARAC14, #'N'
	MOV	CARAC15, #'D'
	MOV	CARAC16, #'O'
	MOV	CARAC17, #' '
	MOV	CARAC18, #' '
	MOV	CARAC19, #' '
	MOV	CARAC20, #' '
	CALL	VAREDIS


TELA12:
;	CALL 	DEL02SEG
	CALL	LINHA03			; 12345678901234567890
	MOV	CARAC01, #' '			;  
	MOV	CARAC02, #124
	MOV	CARAC03, #' '
	MOV	CARAC04, #126
	MOV	CARAC05, #'.'
	MOV	CARAC06, #' '
	MOV	CARAC07, #' '
	MOV	CARAC08, #' '
	MOV	CARAC09, #' '
	MOV	CARAC10, #' '
	MOV	CARAC11, #' '			
	MOV	CARAC12, #' '
	MOV	CARAC13, #' '
	MOV	CARAC14, #' '
	MOV	CARAC15, #' '
	MOV	CARAC16, #' '
	MOV	CARAC17, #' '
	MOV	CARAC18, #' ' 
	MOV	CARAC19, #' '
	MOV	CARAC20, #' '	
	CALL 	VAREDIS
	
TELA13:
	CALL	DEL02SEG
	CALL	LINHA03
	MOV	CARAC01, #' '			
	MOV	CARAC02, #47
	MOV	CARAC03, #' '
	MOV	CARAC04, #126
	MOV	CARAC05, #'.'
	MOV	CARAC06, #' '
	MOV	CARAC07, #' '	
	CALL 	VAREDIS

TELA14:
	CALL	DEL02SEG
	CALL	LINHA03
	MOV	CARAC01, #' '			
	MOV	CARAC02, #45
	MOV	CARAC03, #' '
	MOV	CARAC04, #126
	MOV	CARAC05, #'.'
	MOV	CARAC06, #' '
	MOV	CARAC07, #' '	
	CALL 	VAREDIS

TELA15:
	CALL	DEL02SEG
	CALL	LINHA03	
	MOV	CARAC01, #' '			
	MOV	CARAC02, #205
	MOV	CARAC03, #' '
	MOV	CARAC04, #126
	MOV	CARAC05, #'.'
	MOV	CARAC06, #'.'
	MOV	CARAC07, #' '	
	CALL 	VAREDIS

TELA16:
	CALL	DEL02SEG
	CALL	LINHA03	
	MOV	CARAC01, #' '			
	MOV	CARAC02, #124
	MOV	CARAC03, #' '
	MOV	CARAC04, #126
	MOV	CARAC05, #'.'
	MOV	CARAC06, #'.'
	MOV	CARAC07, #' '	
	MOV	CARAC08, #' '
	CALL 	VAREDIS

TELA17:
	CALL	DEL02SEG
	CALL	LINHA03	
	MOV	CARAC01, #' '			
	MOV	CARAC02, #47
	MOV	CARAC03, #' '
	MOV	CARAC04, #126
	MOV	CARAC05, #'.'
	MOV	CARAC06, #'.'
	MOV	CARAC07, #' '	
	MOV	CARAC08, #' '
	CALL 	VAREDIS

TELA18:
	CALL	DEL02SEG
	CALL	LINHA03	
	MOV	CARAC01, #' '			
	MOV	CARAC02, #45
	MOV	CARAC03, #' '
	MOV	CARAC04, #126
	MOV	CARAC05, #'.'
	MOV	CARAC06, #'.'
	MOV	CARAC07, #'.'
	MOV	CARAC08, #' '
	MOV	CARAC09, #' '
	CALL 	VAREDIS
TELA19:
	CALL	DEL02SEG
	CALL	LINHA03	
	MOV	CARAC01, #' '			
	MOV	CARAC02, #205
	MOV	CARAC03, #' '
	MOV	CARAC04, #126
	MOV	CARAC05, #'.'
	MOV	CARAC06, #'.'
	MOV	CARAC07, #'.'
	MOV	CARAC08, #' '
	MOV	CARAC09, #' '
	CALL 	VAREDIS
TELA20:
	CALL	DEL02SEG
	CALL	LINHA03	
	MOV	CARAC01, #' '			
	MOV	CARAC02, #124
	MOV	CARAC03, #' '
	MOV	CARAC04, #126
	MOV	CARAC05, #'.'
	MOV	CARAC06, #'.'
	MOV	CARAC07, #'.'
	MOV	CARAC08, #'.'
	MOV	CARAC09, #' '
	CALL 	VAREDIS

TELA21:
	CALL	DEL02SEG
	CALL	LINHA03
	MOV	CARAC01, #' '			
	MOV	CARAC02, #47
	MOV	CARAC03, #' '
	MOV	CARAC04, #126
	MOV	CARAC05, #'.'
	MOV	CARAC06, #'.'
	MOV	CARAC07, #'.'
	MOV	CARAC08, #'.'
	MOV	CARAC09, #' '
	MOV	CARAC10, #' '
	CALL 	VAREDIS
TELA22:
	CALL	DEL02SEG
	CALL	LINHA03	
	MOV	CARAC01, #' '			
	MOV	CARAC02, #45
	MOV	CARAC03, #' '
	MOV	CARAC04, #126
	MOV	CARAC05, #'.'
	MOV	CARAC06, #'.'
	MOV	CARAC07, #'.'
	MOV	CARAC08, #'.'
	MOV	CARAC09, #' '
	MOV	CARAC10, #' '
	CALL 	VAREDIS

TELA23:
	CALL	DEL02SEG
	CALL	LINHA03	
	MOV	CARAC01, #' '			
	MOV	CARAC02, #205
	MOV	CARAC03, #' '
	MOV	CARAC04, #126
	MOV	CARAC05, #'.'
	MOV	CARAC06, #'.'
	MOV	CARAC07, #'.'
	MOV	CARAC08, #'.'
	MOV	CARAC09, #'.'
	MOV	CARAC10, #'.'
	CALL 	VAREDIS

TELA24:
	CALL	DEL02SEG
	CALL	LINHA03	
	MOV	CARAC01, #' '			
	MOV	CARAC02, #'*'
	MOV	CARAC03, #' '
	MOV	CARAC04, #126
	MOV	CARAC05, #'.'
	MOV	CARAC06, #'.'
	MOV	CARAC07, #'.'
	MOV	CARAC08, #'.'
	MOV	CARAC09, #'.'
	MOV	CARAC10, #'.'
	MOV	CARAC11, #'.'
	MOV	CARAC12, #' '
	MOV	CARAC13, #'O'
	MOV	CARAC14, #'K'
 	CALL 	VAREDIS

	CALL	DEL1SEG
	CALL	LIMPDIS


TELA31:	
	CALL	LINHA03				; Terceira linha (menu de navegação)			
	MOV	CARAC01, #'*'			
	MOV	CARAC02, #'*'
	MOV	CARAC03, #'*'
	MOV	CARAC04, #'*'
	MOV	CARAC05, #'*'
	MOV	CARAC06, #'N'
	MOV	CARAC07, #'A'
	MOV	CARAC08, #'V'
	MOV	CARAC09, #'E'
	MOV	CARAC10, #'G'
	MOV	CARAC11, #'A'			
	MOV	CARAC12, #'C'
	MOV	CARAC13, #'A'
	MOV	CARAC14, #'O'
	MOV	CARAC15, #'*'
	MOV	CARAC16, #'*'
	MOV	CARAC17, #'*'
	MOV	CARAC18, #'*'
	MOV	CARAC19, #'*'
	MOV	CARAC20, #'*'
	CALL	VAREDIS

	CALL	DEL02SEG
	CALL	LINHA04							; Quarta linha (funções do teclado)
	MOV	CARAC01, #' '			
	MOV	CARAC02, #' '
	MOV	CARAC03, #' '
	MOV	CARAC04, #'1'
	MOV	CARAC05, #'='
	MOV	CARAC06, #'M'
	MOV	CARAC07, #'E'
	MOV	CARAC08, #'N'
	MOV	CARAC09, #'U'
	MOV	CARAC10, #' '
	MOV	CARAC11, #'2'			
	MOV	CARAC12, #'='
	MOV	CARAC13, #'+'
	MOV	CARAC14, #' '
	MOV	CARAC15, #'3'
	MOV	CARAC16, #'='
	MOV	CARAC17, #'-'
	MOV	CARAC18, #' '
	MOV	CARAC19, #' '
	MOV	CARAC20, #' '
	CALL	VAREDIS
	JMP	PRINCIPAL



INITELAOK:

	JMP	TNOP




;####################  ROTINA DE ESCRITA NO DISPLAY ##################



;80 81 82 83 84 85 86 87 88 89 8A 8B 8C 8D 8E 8F 90 91 92 93	primeira linha do display
;C0 C1 C2 C3 C4 C5 C6 C7 C8 C9 CA CB CC CD CE CF D0 D1 D2 D3	segunda linha do display
;94 95 96 97 98 99 9A 9B 9C 9E 9D 9F A0 A1 A2 A3 A4 A5 A6 A7	terceira linha do display
;D4 D5 D6 D7 D8 D9 DA DB DC DD DE DF E0 E1 E2 E3 E4 E5 E6 E7	quarta linha do display


VAREDIS:					; Varredura de display1

	MOV	P1, CARAC01			; Move caracter 1 para a porta P1			
	CALL	IMPDIS				; Chama subrotina de impressão no display (50us)
	MOV	P1, CARAC02
	CALL	IMPDIS
	MOV	P1, CARAC03
	CALL	IMPDIS
	MOV	P1, CARAC04
	CALL	IMPDIS
	MOV	P1, CARAC05
	CALL	IMPDIS
	MOV	P1, CARAC06
	CALL	IMPDIS
	MOV	P1, CARAC07
	CALL	IMPDIS
	MOV	P1, CARAC08
	CALL	IMPDIS
	MOV	P1, CARAC09
	CALL	IMPDIS
	MOV	P1, CARAC10
	CALL	IMPDIS
	MOV	P1, CARAC11
	CALL	IMPDIS
	MOV	P1, CARAC12
	CALL	IMPDIS
	MOV	P1, CARAC13
	CALL	IMPDIS
	MOV	P1, CARAC14
	CALL	IMPDIS
	MOV	P1, CARAC15
	CALL	IMPDIS
	MOV	P1, CARAC16
	CALL	IMPDIS
	MOV	P1, CARAC17
	CALL	IMPDIS
	MOV	P1, CARAC18
	CALL	IMPDIS
	MOV	P1, CARAC19
	CALL	IMPDIS
	MOV	P1, CARAC20
	CALL	IMPDIS	
	RET	
	
	JMP	PRINCIPAL


LIMPALINHA:
	MOV	CARAC01, #' '			 ; LIMPA LINHA		
	MOV	CARAC02, #' '
	MOV	CARAC03, #' '
	MOV	CARAC04, #' '
	MOV	CARAC05, #' '
	MOV	CARAC06, #' '
	MOV	CARAC07, #' '
	MOV	CARAC08, #' '
	MOV	CARAC09, #' '
	MOV	CARAC10, #' '
	MOV	CARAC11, #' '			
	MOV	CARAC12, #' '
	MOV	CARAC13, #' '
	MOV	CARAC14, #' '
	MOV	CARAC15, #' '
	MOV	CARAC16, #' '
	MOV	CARAC17, #' '
	MOV	CARAC18, #' '
	MOV	CARAC19, #' '
	MOV	CARAC20, #' '
	RET
	







;################################################################
;########## Rotina de LEitura de Conversor A/D 8 Portas #########
;################################################################

INICAD:
	CLR	P0.3				; Desativa ALE
	NOP
	NOP
	CLR	P0.4				; Desativa START
	NOP
	NOP
	CLR	P0.0				; Primeiro bit de seleção da entrada do A/D
	CLR	P0.1				; Segundo  bit de seleção da entrada do A/D
	CLR	P0.2				; Terceiro bit de seleção da entrada do A/D
	SETB	P0.3				; Ativa ALE

	SETB	P0.4				; Ativa	START
						; Não faz nada durante um ciclo de máquina
	CLR	P0.4				; Desativa START
	CLR	P0.3				; ALE
	MOV	NAD, #00
	JMP	PRINCIPAL








LERAD:
	MOV	A, NAD
COMPNAD0:
	CJNE	A, #00, COMPNAD1
	JMP	AD00

COMPNAD1:
	CJNE	A, #01, COMPNAD2
	JMP	AD01

COMPNAD2:
	CJNE	A, #02, COMPNAD3
	JMP	AD02

COMPNAD3:
	CJNE	A, #03, COMPNAD4
	JMP	AD03

COMPNAD4:
	CJNE	A, #04, COMPNAD5
	JMP	AD04

COMPNAD5:
	CJNE	A, #05, COMPNAD6
	JMP	AD05

COMPNAD6:
	CJNE	A, #06, COMPNAD7
	JMP	AD06

COMPNAD7:	
	CJNE	A, #07, RESAD
	JMP	AD07
RESAD:
	MOV	NAD, #00
	JMP	PRINCIPAL





RVALAD:
	NOP
	NOP
	NOP
	NOP
	NOP
	JB	P0.5, LDADO
	JMP 	RVALAD
LDADO:
	SETB	P0.6				; Ativa o Output Enable
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	MOV	VALAD, P2			; Captura o valor do A/D (na P2) na variável VALAD
	CLR	P0.6				; Destiva o Output Enable
	JMP	COMPVAL





AD00:

	CALL	LINHA03
	MOV	CARAC01, #'M'			;MAP:..........   100
	MOV	CARAC02, #'A'			
	MOV	CARAC03, #'P'
	MOV	CARAC04, #':'
	MOV	CARAC05, VALAD01		; Move valor primeiro valor absoluto do A/D
	MOV	CARAC06, VALAD02		; Move valor segundo  valor absoluto do A/D
	MOV	CARAC07, VALAD03		; Move valor terceiro valor absoluto do A/D

	CLR	P0.3				; Desativa ALE
	CLR	P0.4				; Desativa START

	CLR	P0.0				; Primeiro bit de seleção da entrada do A/D
	SETB	P0.1				; Segundo  bit de seleção da entrada do A/D
	CLR	P0.2				; Terceiro bit de seleção da entrada do A/D

	SETB	P0.3				; Ativa ALE
	SETB	P0.4				; Ativa	START
	CLR	P0.4				; Desativa START
	CLR	P0.3				; ALE
	MOV	NAD, #01
	JMP	PRINCIPAL

AD01:
	CALL	LINHA03
	MOV	CARAC14, #'T'			;TAR:  Valor da temperatura do ar
	MOV	CARAC15, #'A'			
	MOV	CARAC16, #'R'
	MOV	CARAC17, #':'
	MOV	CARAC18, VALAD01		; Move valor primeiro valor absoluto do A/D
	MOV	CARAC19, VALAD02		; Move valor segundo  valor absoluto do A/D
	MOV	CARAC20, VALAD03		; Move valor terceiro valor absoluto do A/D
	CALL	VAREDIS 			; Varredura de display

	CLR	P0.3				; Desativa ALE
	CLR	P0.4				; Desativa START

	SETB	P0.0				; Primeiro bit de seleção da entrada do A/D
	CLR	P0.1				; Segundo  bit de seleção da entrada do A/D
	CLR	P0.2				; Terceiro bit de seleção da entrada do A/D

	SETB	P0.3				; Ativa ALE
	SETB	P0.4				; Ativa	START
	CLR	P0.4				; Desativa START
	CLR	P0.3				; ALE
	MOV	NAD, #02
	JMP	PRINCIPAL

AD02:
	CALL	LINHA04
	MOV	CARAC01, #' '			;MAP:..........   100
	MOV	CARAC02, #'A'			
	MOV	CARAC03, #'R'
	MOV	CARAC04, #':'
	MOV	CARAC05, VALAD01		; Move valor primeiro valor absoluto do A/D
	MOV	CARAC06, VALAD02		; Move valor segundo  valor absoluto do A/D
	MOV	CARAC07, VALAD03		; Move valor terceiro valor absoluto do A/D

	CLR	P0.3				; Desativa ALE
	NOP
	NOP
	CLR	P0.4				; Desativa START
	NOP
	NOP
	CLR	P0.0				; Primeiro bit de seleção da entrada do A/D
	SETB	P0.1				; Segundo  bit de seleção da entrada do A/D
	SETB	P0.2				; Terceiro bit de seleção da entrada do A/D

	SETB	P0.3				; Ativa ALE
	SETB	P0.4				; Ativa	START	
	CLR	P0.4				; Desativa START
	CLR	P0.3				; ALE
	MOV	NAD, #03
	JMP	PRINCIPAL
	
AD03:
	CALL	LINHA04
	MOV	CARAC14, #'T'			;MAP:   valor da temperatura do óleo
	MOV	CARAC15, #'O'			
	MOV	CARAC16, #'L'
	MOV	CARAC17, #':'
	MOV	CARAC18, VALAD01		; Move valor primeiro valor absoluto do A/D
	MOV	CARAC19, VALAD02		; Move valor segundo  valor absoluto do A/D
	MOV	CARAC20, VALAD03		; Move valor terceiro valor absoluto do A/D
	CALL	VAREDIS	 			; Varredura de display
	CLR	P0.3				; Desativa ALE
	CLR	P0.4				; Desativa START

	CLR	P0.0				; Primeiro bit de seleção da entrada do A/D
	CLR	P0.1				; Segundo  bit de seleção da entrada do A/D
	CLR	P0.2				; Terceiro bit de seleção da entrada do A/D

	SETB	P0.3				; Ativa ALE
	SETB	P0.4				; Ativa	START
	CLR	P0.4				; Desativa START
	CLR	P0.3				; ALE
	MOV	NAD, #00
	JMP	PRINCIPAL
AD04:
	MOV 	NAD, #00
	JMP	LERAD

	CLR	P0.3				; Desativa ALE
	CLR	P0.4				; Desativa START
	SETB	P0.0				; Primeiro bit de seleção da entrada do A/D
	CLR	P0.1				; Segundo  bit de seleção da entrada do A/D
	CLR	P0.2				; Terceiro bit de seleção da entrada do A/D
	SETB	P0.3				; Ativa ALE
	SETB	P0.4				; Ativa	START
	NOP					; Não faz nada durante um ciclo de máquina
	CLR	P0.4				; Desativa START
	CLR	P0.3				; ALE
	JMP	PRINCIPAL

AD05:
	JMP 	AD01

	CLR	P0.3				; Desativa ALE
	CLR	P0.4				; Desativa START
	SETB	P0.0				; Primeiro bit de seleção da entrada do A/D
	CLR	P0.1				; Segundo  bit de seleção da entrada do A/D
	SETB	P0.2				; Terceiro bit de seleção da entrada do A/D
	SETB	P0.3				; Ativa ALE
	SETB	P0.4				; Ativa	START
	NOP					; Não faz nada durante um ciclo de máquina
	CLR	P0.4				; Desativa START
	CLR	P0.3				; ALE
	JMP	PRINCIPAL

AD06:
	JMP 	AD00

	CLR	P0.3				; Desativa ALE
	CLR	P0.4				; Desativa START
	SETB	P0.0				; Primeiro bit de seleção da entrada do A/D
	SETB	P0.1				; Segundo  bit de seleção da entrada do A/D
	CLR	P0.2				; Terceiro bit de seleção da entrada do A/D
	SETB	P0.3				; Ativa ALE
	SETB	P0.4				; Ativa	START
	NOP					; Não faz nada durante um ciclo de máquina
	CLR	P0.4				; Desativa START
	CLR	P0.3				; ALE
	JMP	PRINCIPAL

AD07:
	JMP 	AD01

	CLR	P0.3				; Desativa ALE
	CLR	P0.4				; Desativa START
	SETB	P0.0				; Primeiro bit de seleção da entrada do A/D
	SETB	P0.1				; Segundo  bit de seleção da entrada do A/D
	SETB	P0.2				; Terceiro bit de seleção da entrada do A/D
	SETB	P0.3				; Ativa ALE
	SETB	P0.4				; Ativa	START
	NOP					; Não faz nada durante um ciclo de máquina
	CLR	P0.4				; Desativa START
	CLR	P0.3				; ALE
	JMP	PRINCIPAL





COMPVAL:
	MOV	A, VALAD	

COMP0:
	CJNE	A, #0, COMP1			; Compara o valor e desvia se for diferente
	JMP	I000	

COMP1:
	CJNE	A, #1, COMP2			; Compara o valor e desvia se for diferente
	JMP	I001

COMP2:
	CJNE	A, #2, COMP3			; Compara o valor e desvia se for diferente
	JMP	I002

COMP3:
	CJNE	A, #3, COMP4			; Compara o valor e desvia se for diferente
	JMP	I003	

COMP4:
	CJNE	A, #4, COMP5			; Compara o valor e desvia se for diferente
	JMP	I004

COMP5:
	CJNE	A, #5, COMP6			; Compara o valor e desvia se for diferente
	JMP	I005

COMP6:
	CJNE	A, #6, COMP7			; Compara o valor e desvia se for diferente
	JMP	I006

COMP7:
	CJNE	A, #7, COMP8			; Compara o valor e desvia se for diferente
	JMP	I007

COMP8:
	CJNE	A, #8, COMP9			; Compara o valor e desvia se for diferente
	JMP	I008	

COMP9:
	CJNE	A, #9, COMP10			; Compara o valor e desvia se for diferente
	JMP	I009

COMP10:
	CJNE	A, #10, COMP11			; Compara o valor e desvia se for diferente
	JMP	I010

COMP11:
	CJNE	A, #11, COMP12			; Compara o valor e desvia se for diferente
	JMP	I011	

COMP12:
	CJNE	A, #12, COMP13			; Compara o valor e desvia se for diferente
	JMP	I012

COMP13:
	CJNE	A, #13, COMP14			; Compara o valor e desvia se for diferente
	JMP	I013

COMP14:
	CJNE	A, #14, COMP15			; Compara o valor e desvia se for diferente
	JMP	I014	

COMP15:
	CJNE	A, #15, COMP16			; Compara o valor e desvia se for diferente
	JMP	I015

COMP16:
	CJNE	A, #16, COMP17			; Compara o valor e desvia se for diferente
	JMP	I016

COMP17:
	CJNE	A, #17, COMP18			; Compara o valor e desvia se for diferente
	JMP	I017

COMP18:
	CJNE	A, #18, COMP19			; Compara o valor e desvia se for diferente
	JMP	I018

COMP19:
	CJNE	A, #19, COMP20			; Compara o valor e desvia se for diferente
	JMP	I019	

COMP20:
	CJNE	A, #20, COMP21			; Compara o valor e desvia se for diferente
	JMP	I020

COMP21:
	CJNE	A, #21, COMP22			; Compara o valor e desvia se for diferente
	JMP	I021

COMP22:
	CJNE	A, #22, COMP23			; Compara o valor e desvia se for diferente
	JMP	I022	

COMP23:
	CJNE	A, #23, COMP24			; Compara o valor e desvia se for diferente
	JMP	I023

COMP24:
	CJNE	A, #24, COMP25			; Compara o valor e desvia se for diferente
	JMP	I024

COMP25:
	CJNE	A, #25, COMP26			; Compara o valor e desvia se for diferente
	JMP	I025	

COMP26:
	CJNE	A, #26, COMP27			; Compara o valor e desvia se for diferente
	JMP	I026

COMP27:
	CJNE	A, #27, COMP28			; Compara o valor e desvia se for diferente
	JMP	I027

COMP28:
	CJNE	A, #28, COMP29			; Compara o valor e desvia se for diferente
	JMP	I028

COMP29:
	CJNE	A, #29, COMP30			; Compara o valor e desvia se for diferente
	JMP	I029

COMP30:
	CJNE	A, #30, COMP31			; Compara o valor e desvia se for diferente
	JMP	I030	

COMP31:
	CJNE	A, #31, COMP32			; Compara o valor e desvia se for diferente
	JMP	I031

COMP32:
	CJNE	A, #32, COMP33			; Compara o valor e desvia se for diferente
	JMP	I032

COMP33:
	CJNE	A, #33, COMP34			; Compara o valor e desvia se for diferente
	JMP	I033	

COMP34:
	CJNE	A, #34, COMP35			; Compara o valor e desvia se for diferente
	JMP	I034

COMP35:
	CJNE	A, #35, COMP36			; Compara o valor e desvia se for diferente
	JMP	I035

COMP36:
	CJNE	A, #36, COMP37			; Compara o valor e desvia se for diferente
	JMP	I036	

COMP37:
	CJNE	A, #37, COMP38			; Compara o valor e desvia se for diferente
	JMP	I037

COMP38:
	CJNE	A, #38, COMP39			; Compara o valor e desvia se for diferente
	JMP	I038

COMP39:
	CJNE	A, #39, COMP40			; Compara o valor e desvia se for diferente
	JMP	I039

COMP40:
	CJNE	A, #40, COMP41			; Compara o valor e desvia se for diferente
	JMP	I040

COMP41:
	CJNE	A, #41, COMP42			; Compara o valor e desvia se for diferente
	JMP	I041	

COMP42:
	CJNE	A, #42, COMP43			; Compara o valor e desvia se for diferente
	JMP	I042

COMP43:
	CJNE	A, #43, COMP44			; Compara o valor e desvia se for diferente
	JMP	I043

COMP44:
	CJNE	A, #44, COMP45			; Compara o valor e desvia se for diferente
	JMP	I044	

COMP45:
	CJNE	A, #45, COMP46			; Compara o valor e desvia se for diferente
	JMP	I045

COMP46:
	CJNE	A, #46, COMP47			; Compara o valor e desvia se for diferente
	JMP	I046

COMP47:
	CJNE	A, #47, COMP48			; Compara o valor e desvia se for diferente
	JMP	I047	

COMP48:
	CJNE	A, #48, COMP49			; Compara o valor e desvia se for diferente
	JMP	I048

COMP49:
	CJNE	A, #49, COMP50			; Compara o valor e desvia se for diferente
	JMP	I049

COMP50:
	CJNE	A, #50, COMP51			; Compara o valor e desvia se for diferente
	JMP	I050

COMP51:
	CJNE	A, #51, COMP52			; Compara o valor e desvia se for diferente
	JMP	I051

COMP52:
	CJNE	A, #52, COMP53			; Compara o valor e desvia se for diferente
	JMP	I052	

COMP53:
	CJNE	A, #53, COMP54			; Compara o valor e desvia se for diferente
	JMP	I053

COMP54:
	CJNE	A, #54, COMP55			; Compara o valor e desvia se for diferente
	JMP	I054

COMP55:
	CJNE	A, #55, COMP56			; Compara o valor e desvia se for diferente
	JMP	I055	

COMP56:
	CJNE	A, #56, COMP57			; Compara o valor e desvia se for diferente
	JMP	I056

COMP57:
	CJNE	A, #57, COMP58			; Compara o valor e desvia se for diferente
	JMP	I057

COMP58:
	CJNE	A, #58, COMP59			; Compara o valor e desvia se for diferente
	JMP	I058	

COMP59:
	CJNE	A, #59, COMP60			; Compara o valor e desvia se for diferente
	JMP	I059

COMP60:
	CJNE	A, #60, COMP61			; Compara o valor e desvia se for diferente
	JMP	I060

COMP61:
	CJNE	A, #61, COMP62			; Compara o valor e desvia se for diferente
	JMP	I061

COMP62:
	CJNE	A, #62, COMP63			; Compara o valor e desvia se for diferente
	JMP	I062	

COMP63:
	CJNE	A, #63, COMP64			; Compara o valor e desvia se for diferente
	JMP	I063

COMP64:
	CJNE	A, #64, COMP65			; Compara o valor e desvia se for diferente
	JMP	I064

COMP65:
	CJNE	A, #65, COMP66			; Compara o valor e desvia se for diferente
	JMP	I065	

COMP66:
	CJNE	A, #66, COMP67			; Compara o valor e desvia se for diferente
	JMP	I066

COMP67:
	CJNE	A, #67, COMP68			; Compara o valor e desvia se for diferente
	JMP	I067

COMP68:
	CJNE	A, #68, COMP69			; Compara o valor e desvia se for diferente
	JMP	I068	

COMP69:
	CJNE	A, #69, COMP70			; Compara o valor e desvia se for diferente
	JMP	I069

COMP70:
	CJNE	A, #70, COMP71			; Compara o valor e desvia se for diferente
	JMP	I070

COMP71:
	CJNE	A, #71, COMP72			; Compara o valor e desvia se for diferente
	JMP	I071

COMP72:
	CJNE	A, #72, COMP73			; Compara o valor e desvia se for diferente
	JMP	I072	

COMP73:
	CJNE	A, #73, COMP74			; Compara o valor e desvia se for diferente
	JMP	I073

COMP74:
	CJNE	A, #74, COMP75			; Compara o valor e desvia se for diferente
	JMP	I074

COMP75:
	CJNE	A, #75, COMP76			; Compara o valor e desvia se for diferente
	JMP	I075	

COMP76:
	CJNE	A, #76, COMP77			; Compara o valor e desvia se for diferente
	JMP	I076

COMP77:
	CJNE	A, #77, COMP78			; Compara o valor e desvia se for diferente
	JMP	I077

COMP78:
	CJNE	A, #78, COMP79			; Compara o valor e desvia se for diferente
	JMP	I078	

COMP79:
	CJNE	A, #79, COMP80			; Compara o valor e desvia se for diferente
	JMP	I079

COMP80:
	CJNE	A, #80, COMP81			; Compara o valor e desvia se for diferente
	JMP	I080

COMP81:
	CJNE	A, #81, COMP82			; Compara o valor e desvia se for diferente
	JMP	I081

COMP82:
	CJNE	A, #82, COMP83			; Compara o valor e desvia se for diferente
	JMP	I082	

COMP83:
	CJNE	A, #83, COMP84			; Compara o valor e desvia se for diferente
	JMP	I083

COMP84:
	CJNE	A, #84, COMP85			; Compara o valor e desvia se for diferente
	JMP	I084

COMP85:
	CJNE	A, #85, COMP86			; Compara o valor e desvia se for diferente
	JMP	I085	

COMP86:
	CJNE	A, #86, COMP87			; Compara o valor e desvia se for diferente
	JMP	I086

COMP87:
	CJNE	A, #87, COMP88			; Compara o valor e desvia se for diferente
	JMP	I087

COMP88:
	CJNE	A, #88, COMP89			; Compara o valor e desvia se for diferente
	JMP	I088	

COMP89:
	CJNE	A, #89, COMP90			; Compara o valor e desvia se for diferente
	JMP	I089

COMP90:
	CJNE	A, #90, COMP91			; Compara o valor e desvia se for diferente
	JMP	I090

COMP91:
	CJNE	A, #91, COMP92			; Compara o valor e desvia se for diferente
	JMP	I091

COMP92:
	CJNE	A, #92, COMP93			; Compara o valor e desvia se for diferente
	JMP	I092	

COMP93:
	CJNE	A, #93, COMP94			; Compara o valor e desvia se for diferente
	JMP	I093

COMP94:
	CJNE	A, #94, COMP95			; Compara o valor e desvia se for diferente
	JMP	I094

COMP95:
	CJNE	A, #95, COMP96			; Compara o valor e desvia se for diferente
	JMP	I095	

COMP96:
	CJNE	A, #96, COMP97			; Compara o valor e desvia se for diferente
	JMP	I096

COMP97:
	CJNE	A, #97, COMP98			; Compara o valor e desvia se for diferente
	JMP	I097

COMP98:
	CJNE	A, #98, COMP99			; Compara o valor e desvia se for diferente
	JMP	I098	

COMP99:
	CJNE	A, #99, COMP100			; Compara o valor e desvia se for diferente
	JMP	I099

COMP100:
	CJNE	A, #100, COMP101		; Compara o valor e desvia se for diferente
	JMP	I100	

COMP101:
	CJNE	A, #101, COMP102		; Compara o valor e desvia se for diferente
	JMP	I101

COMP102:
	CJNE	A, #102, COMP103		; Compara o valor e desvia se for diferente
	JMP	I102

COMP103:
	CJNE	A, #103, COMP104		; Compara o valor e desvia se for diferente
	JMP	I103	

COMP104:
	CJNE	A, #104, COMP105		; Compara o valor e desvia se for diferente
	JMP	I104

COMP105:
	CJNE	A, #105, COMP106		; Compara o valor e desvia se for diferente
	JMP	I105

COMP106:
	CJNE	A, #106, COMP107		; Compara o valor e desvia se for diferente
	JMP	I106

COMP107:
	CJNE	A, #107, COMP108		; Compara o valor e desvia se for diferente
	JMP	I107

COMP108:
	CJNE	A, #108, COMP109		; Compara o valor e desvia se for diferente
	JMP	I108	

COMP109:
	CJNE	A, #109, COMP110		; Compara o valor e desvia se for diferente
	JMP	I109

COMP110:
	CJNE	A, #110, COMP111		; Compara o valor e desvia se for diferente
	JMP	I110

COMP111:
	CJNE	A, #111, COMP112		; Compara o valor e desvia se for diferente
	JMP	I111	

COMP112:
	CJNE	A, #112, COMP113		; Compara o valor e desvia se for diferente
	JMP	I112

COMP113:
	CJNE	A, #113, COMP114		; Compara o valor e desvia se for diferente
	JMP	I113

COMP114:
	CJNE	A, #114, COMP115		; Compara o valor e desvia se for diferente
	JMP	I114	

COMP115:
	CJNE	A, #115, COMP116		; Compara o valor e desvia se for diferente
	JMP	I115

COMP116:
	CJNE	A, #116, COMP117		; Compara o valor e desvia se for diferente
	JMP	I116

COMP117:
	CJNE	A, #117, COMP118		; Compara o valor e desvia se for diferente
	JMP	I117

COMP118:
	CJNE	A, #118, COMP119		; Compara o valor e desvia se for diferente
	JMP	I118

COMP119:
	CJNE	A, #119, COMP120		; Compara o valor e desvia se for diferente
	JMP	I119	

COMP120:
	CJNE	A, #120, COMP121		; Compara o valor e desvia se for diferente
	JMP	I120

COMP121:
	CJNE	A, #121, COMP122		; Compara o valor e desvia se for diferente
	JMP	I121

COMP122:
	CJNE	A, #122, COMP123		; Compara o valor e desvia se for diferente
	JMP	I122	

COMP123:
	CJNE	A, #123, COMP124		; Compara o valor e desvia se for diferente
	JMP	I123

COMP124:
	CJNE	A, #124, COMP125		; Compara o valor e desvia se for diferente
	JMP	I124

COMP125:
	CJNE	A, #125, COMP126		; Compara o valor e desvia se for diferente
	JMP	I125	

COMP126:
	CJNE	A, #126, COMP127		; Compara o valor e desvia se for diferente
	JMP	I126

COMP127:
	CJNE	A, #127, COMP128		; Compara o valor e desvia se for diferente
	JMP	I127

COMP128:
	CJNE	A, #128, COMP129		; Compara o valor e desvia se for diferente
	JMP	I128

COMP129:
	CJNE	A, #129, COMP130		; Compara o valor e desvia se for diferente
	JMP	I129

COMP130:
	CJNE	A, #130, COMP131		; Compara o valor e desvia se for diferente
	JMP	I130	

COMP131:
	CJNE	A, #131, COMP132		; Compara o valor e desvia se for diferente
	JMP	I131

COMP132:
	CJNE	A, #132, COMP133		; Compara o valor e desvia se for diferente
	JMP	I132

COMP133:
	CJNE	A, #133, COMP134		; Compara o valor e desvia se for diferente
	JMP	I133	

COMP134:
	CJNE	A, #134, COMP135		; Compara o valor e desvia se for diferente
	JMP	I134

COMP135:
	CJNE	A, #135, COMP136		; Compara o valor e desvia se for diferente
	JMP	I135

COMP136:
	CJNE	A, #136, COMP137		; Compara o valor e desvia se for diferente
	JMP	I136	

COMP137:
	CJNE	A, #137, COMP138		; Compara o valor e desvia se for diferente
	JMP	I137

COMP138:
	CJNE	A, #138, COMP139		; Compara o valor e desvia se for diferente
	JMP	I138

COMP139:
	CJNE	A, #139, COMP140		; Compara o valor e desvia se for diferente
	JMP	I139

COMP140:
	CJNE	A, #140, COMP141		; Compara o valor e desvia se for diferente
	JMP	I140

COMP141:
	CJNE	A, #141, COMP142		; Compara o valor e desvia se for diferente
	JMP	I141	

COMP142:
	CJNE	A, #142, COMP143		; Compara o valor e desvia se for diferente
	JMP	I142

COMP143:
	CJNE	A, #143, COMP144		; Compara o valor e desvia se for diferente
	JMP	I143

COMP144:
	CJNE	A, #144, COMP145		; Compara o valor e desvia se for diferente
	JMP	I144	

COMP145:
	CJNE	A, #145, COMP146		; Compara o valor e desvia se for diferente
	JMP	I145

COMP146:
	CJNE	A, #146, COMP147		; Compara o valor e desvia se for diferente
	JMP	I146

COMP147:
	CJNE	A, #147, COMP148		; Compara o valor e desvia se for diferente
	JMP	I147	

COMP148:
	CJNE	A, #148, COMP149		; Compara o valor e desvia se for diferente
	JMP	I148

COMP149:
	CJNE	A, #149, COMP150		; Compara o valor e desvia se for diferente
	JMP	I149

COMP150:
	CJNE	A, #150, COMP151		; Compara o valor e desvia se for diferente
	JMP	I150

COMP151:
	CJNE	A, #151, COMP152		; Compara o valor e desvia se for diferente
	JMP	I151

COMP152:
	CJNE	A, #152, COMP153		; Compara o valor e desvia se for diferente
	JMP	I152	

COMP153:
	CJNE	A, #153, COMP154		; Compara o valor e desvia se for diferente
	JMP	I153

COMP154:
	CJNE	A, #154, COMP155		; Compara o valor e desvia se for diferente
	JMP	I154

COMP155:
	CJNE	A, #155, COMP156		; Compara o valor e desvia se for diferente
	JMP	I155	

COMP156:
	CJNE	A, #156, COMP157		; Compara o valor e desvia se for diferente
	JMP	I156

COMP157:
	CJNE	A, #157, COMP158		; Compara o valor e desvia se for diferente
	JMP	I157

COMP158:
	CJNE	A, #158, COMP159		; Compara o valor e desvia se for diferente
	JMP	I158	

COMP159:
	CJNE	A, #159, COMP160		; Compara o valor e desvia se for diferente
	JMP	I159

COMP160:
	CJNE	A, #160, COMP161		; Compara o valor e desvia se for diferente
	JMP	I160

COMP161:
	CJNE	A, #161, COMP162		; Compara o valor e desvia se for diferente
	JMP	I161

COMP162:
	CJNE	A, #162, COMP163		; Compara o valor e desvia se for diferente
	JMP	I162	

COMP163:
	CJNE	A, #163, COMP164		; Compara o valor e desvia se for diferente
	JMP	I163

COMP164:
	CJNE	A, #164, COMP165		; Compara o valor e desvia se for diferente
	JMP	I164

COMP165:
	CJNE	A, #165, COMP166		; Compara o valor e desvia se for diferente
	JMP	I165	

COMP166:
	CJNE	A, #166, COMP167		; Compara o valor e desvia se for diferente
	JMP	I166

COMP167:
	CJNE	A, #167, COMP168		; Compara o valor e desvia se for diferente
	JMP	I167

COMP168:
	CJNE	A, #168, COMP169		; Compara o valor e desvia se for diferente
	JMP	I168	

COMP169:
	CJNE	A, #169, COMP170		; Compara o valor e desvia se for diferente
	JMP	I169

COMP170:
	CJNE	A, #170, COMP171		; Compara o valor e desvia se for diferente
	JMP	I170

COMP171:
	CJNE	A, #171, COMP172		; Compara o valor e desvia se for diferente
	JMP	I171

COMP172:
	CJNE	A, #172, COMP173		; Compara o valor e desvia se for diferente
	JMP	I172	

COMP173:
	CJNE	A, #173, COMP174		; Compara o valor e desvia se for diferente
	JMP	I173

COMP174:
	CJNE	A, #174, COMP175		; Compara o valor e desvia se for diferente
	JMP	I174

COMP175:
	CJNE	A, #175, COMP176		; Compara o valor e desvia se for diferente
	JMP	I175	

COMP176:
	CJNE	A, #176, COMP177		; Compara o valor e desvia se for diferente
	JMP	I176

COMP177:
	CJNE	A, #177, COMP178		; Compara o valor e desvia se for diferente
	JMP	I177

COMP178:
	CJNE	A, #178, COMP179		; Compara o valor e desvia se for diferente
	JMP	I178	

COMP179:
	CJNE	A, #179, COMP180		; Compara o valor e desvia se for diferente
	JMP	I179

COMP180:
	CJNE	A, #180, COMP181		; Compara o valor e desvia se for diferente
	JMP	I180

COMP181:
	CJNE	A, #181, COMP182		; Compara o valor e desvia se for diferente
	JMP	I181

COMP182:
	CJNE	A, #182, COMP183		; Compara o valor e desvia se for diferente
	JMP	I182	

COMP183:
	CJNE	A, #183, COMP184		; Compara o valor e desvia se for diferente
	JMP	I183

COMP184:
	CJNE	A, #184, COMP185		; Compara o valor e desvia se for diferente
	JMP	I184

COMP185:
	CJNE	A, #185, COMP186		; Compara o valor e desvia se for diferente
	JMP	I185	

COMP186:
	CJNE	A, #186, COMP187		; Compara o valor e desvia se for diferente
	JMP	I186

COMP187:
	CJNE	A, #187, COMP188		; Compara o valor e desvia se for diferente
	JMP	I187

COMP188:
	CJNE	A, #188, COMP189		; Compara o valor e desvia se for diferente
	JMP	I198	

COMP189:
	CJNE	A, #189, COMP190		; Compara o valor e desvia se for diferente
	JMP	I189

COMP190:
	CJNE	A, #190, COMP191		; Compara o valor e desvia se for diferente
	JMP	I190

COMP191:
	CJNE	A, #191, COMP192		; Compara o valor e desvia se for diferente
	JMP	I191

COMP192:
	CJNE	A, #192, COMP193		; Compara o valor e desvia se for diferente
	JMP	I192	

COMP193:
	CJNE	A, #193, COMP194		; Compara o valor e desvia se for diferente
	JMP	I193

COMP194:
	CJNE	A, #194, COMP195		; Compara o valor e desvia se for diferente
	JMP	I194

COMP195:
	CJNE	A, #195, COMP196		; Compara o valor e desvia se for diferente
	JMP	I195	

COMP196:
	CJNE	A, #196, COMP197		; Compara o valor e desvia se for diferente
	JMP	I196

COMP197:
	CJNE	A, #197, COMP198		; Compara o valor e desvia se for diferente
	JMP	I197

COMP198:
	CJNE	A, #188, COMP199		; Compara o valor e desvia se for diferente
	JMP	I198	

COMP199:
	CJNE	A, #199, COMP200		; Compara o valor e desvia se for diferente
	JMP	I199

COMP200:
	CJNE	A, #200, COMP201		; Compara o valor e desvia se for diferente
	JMP	I200	

COMP201:
	CJNE	A, #201, COMP202		; Compara o valor e desvia se for diferente
	JMP	I201

COMP202:
	CJNE	A, #202, COMP203		; Compara o valor e desvia se for diferente
	JMP	I202

COMP203:
	CJNE	A, #203, COMP204		; Compara o valor e desvia se for diferente
	JMP	I203	

COMP204:
	CJNE	A, #204, COMP205		; Compara o valor e desvia se for diferente
	JMP	I204

COMP205:
	CJNE	A, #205, COMP206		; Compara o valor e desvia se for diferente
	JMP	I205

COMP206:
	CJNE	A, #206, COMP207		; Compara o valor e desvia se for diferente
	JMP	I206

COMP207:
	CJNE	A, #207, COMP208		; Compara o valor e desvia se for diferente
	JMP	I207

COMP208:
	CJNE	A, #208, COMP209		; Compara o valor e desvia se for diferente
	JMP	I208	

COMP209:
	CJNE	A, #209, COMP210		; Compara o valor e desvia se for diferente
	JMP	I209

COMP210:
	CJNE	A, #210, COMP211		; Compara o valor e desvia se for diferente
	JMP	I210

COMP211:
	CJNE	A, #211, COMP212		; Compara o valor e desvia se for diferente
	JMP	I211	

COMP212:
	CJNE	A, #212, COMP213		; Compara o valor e desvia se for diferente
	JMP	I212

COMP213:
	CJNE	A, #213, COMP214		; Compara o valor e desvia se for diferente
	JMP	I213

COMP214:
	CJNE	A, #214, COMP215		; Compara o valor e desvia se for diferente
	JMP	I214	

COMP215:
	CJNE	A, #215, COMP216		; Compara o valor e desvia se for diferente
	JMP	I215

COMP216:
	CJNE	A, #216, COMP217		; Compara o valor e desvia se for diferente
	JMP	I216

COMP217:
	CJNE	A, #217, COMP218		; Compara o valor e desvia se for diferente
	JMP	I217

COMP218:
	CJNE	A, #218, COMP219		; Compara o valor e desvia se for diferente
	JMP	I218

COMP219:
	CJNE	A, #219, COMP220		; Compara o valor e desvia se for diferente
	JMP	I219	

COMP220:
	CJNE	A, #220, COMP221		; Compara o valor e desvia se for diferente
	JMP	I220

COMP221:
	CJNE	A, #221, COMP222		; Compara o valor e desvia se for diferente
	JMP	I221

COMP222:
	CJNE	A, #222, COMP223		; Compara o valor e desvia se for diferente
	JMP	I222	

COMP223:
	CJNE	A, #223, COMP224		; Compara o valor e desvia se for diferente
	JMP	I223

COMP224:
	CJNE	A, #224, COMP225		; Compara o valor e desvia se for diferente
	JMP	I224

COMP225:
	CJNE	A, #225, COMP226		; Compara o valor e desvia se for diferente
	JMP	I225	

COMP226:
	CJNE	A, #226, COMP227		; Compara o valor e desvia se for diferente
	JMP	I226

COMP227:
	CJNE	A, #227, COMP228		; Compara o valor e desvia se for diferente
	JMP	I227

COMP228:
	CJNE	A, #228, COMP229		; Compara o valor e desvia se for diferente
	JMP	I228

COMP229:
	CJNE	A, #229, COMP230		; Compara o valor e desvia se for diferente
	JMP	I229

COMP230:
	CJNE	A, #230, COMP231		; Compara o valor e desvia se for diferente
	JMP	I230	

COMP231:
	CJNE	A, #231, COMP232		; Compara o valor e desvia se for diferente
	JMP	I231

COMP232:
	CJNE	A, #232, COMP233		; Compara o valor e desvia se for diferente
	JMP	I232

COMP233:
	CJNE	A, #233, COMP234		; Compara o valor e desvia se for diferente
	JMP	I233	

COMP234:
	CJNE	A, #234, COMP235		; Compara o valor e desvia se for diferente
	JMP	I234

COMP235:
	CJNE	A, #235, COMP236		; Compara o valor e desvia se for diferente
	JMP	I235

COMP236:
	CJNE	A, #236, COMP237		; Compara o valor e desvia se for diferente
	JMP	I236	

COMP237:
	CJNE	A, #237, COMP238		; Compara o valor e desvia se for diferente
	JMP	I237

COMP238:
	CJNE	A, #238, COMP239		; Compara o valor e desvia se for diferente
	JMP	I238

COMP239:
	CJNE	A, #239, COMP240		; Compara o valor e desvia se for diferente
	JMP	I239

COMP240:
	CJNE	A, #240, COMP241		; Compara o valor e desvia se for diferente
	JMP	I240

COMP241:
	CJNE	A, #241, COMP242		; Compara o valor e desvia se for diferente
	JMP	I241	

COMP242:
	CJNE	A, #242, COMP243		; Compara o valor e desvia se for diferente
	JMP	I242

COMP243:
	CJNE	A, #243, COMP244		; Compara o valor e desvia se for diferente
	JMP	I143

COMP244:
	CJNE	A, #244, COMP245		; Compara o valor e desvia se for diferente
	JMP	I244	

COMP245:
	CJNE	A, #245, COMP246		; Compara o valor e desvia se for diferente
	JMP	I245

COMP246:
	CJNE	A, #246, COMP247		; Compara o valor e desvia se for diferente
	JMP	I246

COMP247:
	CJNE	A, #247, COMP248		; Compara o valor e desvia se for diferente
	JMP	I247	

COMP248:
	CJNE	A, #248, COMP249		; Compara o valor e desvia se for diferente
	JMP	I248

COMP249:
	CJNE	A, #249, COMP250		; Compara o valor e desvia se for diferente
	JMP	I249

COMP250:
	CJNE	A, #250, COMP251		; Compara o valor e desvia se for diferente
	JMP	I250

COMP251:
	CJNE	A, #251, COMP252		; Compara o valor e desvia se for diferente
	JMP	I151

COMP252:
	CJNE	A, #252, COMP253		; Compara o valor e desvia se for diferente
	JMP	I252	

COMP253:
	CJNE	A, #253, COMP254		; Compara o valor e desvia se for diferente
	JMP	I253

COMP254:
	CJNE	A, #254, COMP255		; Compara o valor e desvia se for diferente
	JMP	I254

COMP255:
	CJNE	A, #255, COMP256		; Compara o valor e desvia se for diferente
	JMP	I255


COMP256:
	JMP	PRINCIPAL






I000:
	MOV	VALAD01, #'0' 
	MOV	VALAD02, #'0'
	MOV	VALAD03, #'0'	
	JMP	LERAD

I001:
	MOV	VALAD01, #'0' 
	MOV	VALAD02, #'0'
	MOV	VALAD03, #'1'	
	JMP	LERAD

I002:
	MOV	VALAD01, #'0' 
	MOV	VALAD02, #'0'
	MOV	VALAD03, #'2'	
	JMP	LERAD

I003:
	MOV	VALAD01, #'0' 
	MOV	VALAD02, #'0'
	MOV	VALAD03, #'3'	
	JMP	LERAD

I004:
	MOV	VALAD01, #'0' 
	MOV	VALAD02, #'0'
	MOV	VALAD03, #'4'	
	JMP	LERAD

I005:
	MOV	VALAD01, #'0' 
	MOV	VALAD02, #'0'
	MOV	VALAD03, #'5'	
	JMP	LERAD

I006:
	MOV	VALAD01, #'0' 
	MOV	VALAD02, #'0'
	MOV	VALAD03, #'6'	
	JMP	LERAD

I007:
	MOV	VALAD01, #'0' 
	MOV	VALAD02, #'0'
	MOV	VALAD03, #'7'	
	JMP	LERAD

I008:
	MOV	VALAD01, #'0' 
	MOV	VALAD02, #'0'
	MOV	VALAD03, #'8'	
	JMP	LERAD

I009:
	MOV	VALAD01, #'0' 
	MOV	VALAD02, #'0'
	MOV	VALAD03, #'9'	
	JMP	LERAD

I010:
	MOV	VALAD01, #'0' 
	MOV	VALAD02, #'1'
	MOV	VALAD03, #'0'	
	JMP	LERAD

I011:
	MOV	VALAD01, #'0' 
	MOV	VALAD02, #'1'
	MOV	VALAD03, #'1'	
	JMP	LERAD

I012:
	MOV	VALAD01, #'0' 
	MOV	VALAD02, #'1'
	MOV	VALAD03, #'2'	
	JMP	LERAD

I013:
	MOV	VALAD01, #'0' 
	MOV	VALAD02, #'1'
	MOV	VALAD03, #'3'	
	JMP	LERAD

I014:
	MOV	VALAD01, #'0' 
	MOV	VALAD02, #'1'
	MOV	VALAD03, #'4'	
	JMP	LERAD

I015:
	MOV	VALAD01, #'0' 
	MOV	VALAD02, #'1'
	MOV	VALAD03, #'5'	
	JMP	LERAD

I016:
	MOV	VALAD01, #'0' 
	MOV	VALAD02, #'1'
	MOV	VALAD03, #'6'	
	JMP	LERAD

I017:
	MOV	VALAD01, #'0' 
	MOV	VALAD02, #'1'
	MOV	VALAD03, #'7'	
	JMP	LERAD

I018:
	MOV	VALAD01, #'0' 
	MOV	VALAD02, #'1'
	MOV	VALAD03, #'8'	
	JMP	LERAD

I019:
	MOV	VALAD01, #'0' 
	MOV	VALAD02, #'1'
	MOV	VALAD03, #'9'	
	JMP	LERAD

I020:
	MOV	VALAD01, #'0' 
	MOV	VALAD02, #'2'
	MOV	VALAD03, #'0'	
	JMP	LERAD

I021:
	MOV	VALAD01, #'0' 
	MOV	VALAD02, #'2'
	MOV	VALAD03, #'1'	
	JMP	LERAD

I022:
	MOV	VALAD01, #'0' 
	MOV	VALAD02, #'2'
	MOV	VALAD03, #'2'	
	JMP	LERAD
I023:
	MOV	VALAD01, #'0' 
	MOV	VALAD02, #'2'
	MOV	VALAD03, #'3'	
	JMP	LERAD
I024:
	MOV	VALAD01, #'0' 
	MOV	VALAD02, #'2'
	MOV	VALAD03, #'4'	
	JMP	LERAD
I025:
	MOV	VALAD01, #'0' 
	MOV	VALAD02, #'2'
	MOV	VALAD03, #'5'	
	JMP	LERAD

I026:
	MOV	VALAD01, #'0' 
	MOV	VALAD02, #'2'
	MOV	VALAD03, #'6'	
	JMP	LERAD

I027:
	MOV	VALAD01, #'0' 
	MOV	VALAD02, #'2'
	MOV	VALAD03, #'7'	
	JMP	LERAD

I028:
	MOV	VALAD01, #'0' 
	MOV	VALAD02, #'2'
	MOV	VALAD03, #'8'	
	JMP	LERAD

I029:
	MOV	VALAD01, #'0' 
	MOV	VALAD02, #'2'
	MOV	VALAD03, #'9'	
	JMP	LERAD
I030:
	MOV	VALAD01, #'0' 
	MOV	VALAD02, #'3'
	MOV	VALAD03, #'0'	
	JMP	LERAD

I031:
	MOV	VALAD01, #'0' 
	MOV	VALAD02, #'3'
	MOV	VALAD03, #'1'	
	JMP	LERAD

I032:
	MOV	VALAD01, #'0' 
	MOV	VALAD02, #'3'
	MOV	VALAD03, #'2'	
	JMP	LERAD

I033:
	MOV	VALAD01, #'0' 
	MOV	VALAD02, #'3'
	MOV	VALAD03, #'3'	
	JMP	LERAD

I034:
	MOV	VALAD01, #'0' 
	MOV	VALAD02, #'3'
	MOV	VALAD03, #'4'	
	JMP	LERAD

I035:
	MOV	VALAD01, #'0' 
	MOV	VALAD02, #'3'
	MOV	VALAD03, #'5'	
	JMP	LERAD

I036:
	MOV	VALAD01, #'0' 
	MOV	VALAD02, #'3'
	MOV	VALAD03, #'6'	
	JMP	LERAD

I037:
	MOV	VALAD01, #'0' 
	MOV	VALAD02, #'3'
	MOV	VALAD03, #'7'	
	JMP	LERAD

I038:
	MOV	VALAD01, #'0' 
	MOV	VALAD02, #'3'
	MOV	VALAD03, #'8'	
	JMP	LERAD

I039:
	MOV	VALAD01, #'0' 
	MOV	VALAD02, #'3'
	MOV	VALAD03, #'9'	
	JMP	LERAD

I040:
	MOV	VALAD01, #'0' 
	MOV	VALAD02, #'4'
	MOV	VALAD03, #'0'	
	JMP	LERAD

I041:
	MOV	VALAD01, #'0' 
	MOV	VALAD02, #'4'
	MOV	VALAD03, #'1'	
	JMP	LERAD

I042:
	MOV	VALAD01, #'0' 
	MOV	VALAD02, #'4'
	MOV	VALAD03, #'2'	
	JMP	LERAD

I043:
	MOV	VALAD01, #'0' 
	MOV	VALAD02, #'4'
	MOV	VALAD03, #'3'	
	JMP	LERAD

I044:
	MOV	VALAD01, #'0' 
	MOV	VALAD02, #'4'
	MOV	VALAD03, #'4'	
	JMP	LERAD

I045:
	MOV	VALAD01, #'0' 
	MOV	VALAD02, #'4'
	MOV	VALAD03, #'5'	
	JMP	LERAD

I046:
	MOV	VALAD01, #'0' 
	MOV	VALAD02, #'4'
	MOV	VALAD03, #'6'	
	JMP	LERAD

I047:
	MOV	VALAD01, #'0' 
	MOV	VALAD02, #'4'
	MOV	VALAD03, #'7'	
	JMP	LERAD

I048:
	MOV	VALAD01, #'0' 
	MOV	VALAD02, #'4'
	MOV	VALAD03, #'8'	
	JMP	LERAD

I049:
	MOV	VALAD01, #'0' 
	MOV	VALAD02, #'4'
	MOV	VALAD03, #'9'	
	JMP	LERAD

I050:
	MOV	VALAD01, #'0' 
	MOV	VALAD02, #'5'
	MOV	VALAD03, #'0'	
	JMP	LERAD

I051:
	MOV	VALAD01, #'0' 
	MOV	VALAD02, #'5'
	MOV	VALAD03, #'1'	
	JMP	LERAD

I052:
	MOV	VALAD01, #'0' 
	MOV	VALAD02, #'5'
	MOV	VALAD03, #'2'	
	JMP	LERAD

I053:
	MOV	VALAD01, #'0' 
	MOV	VALAD02, #'5'
	MOV	VALAD03, #'3'	
	JMP	LERAD
I054:
	MOV	VALAD01, #'0' 
	MOV	VALAD02, #'5'
	MOV	VALAD03, #'4'	
	JMP	LERAD
I055:
	MOV	VALAD01, #'0' 
	MOV	VALAD02, #'5'
	MOV	VALAD03, #'5'	
	JMP	LERAD

I056:
	MOV	VALAD01, #'0' 
	MOV	VALAD02, #'5'
	MOV	VALAD03, #'6'	
	JMP	LERAD

I057:
	MOV	VALAD01, #'0' 
	MOV	VALAD02, #'5'
	MOV	VALAD03, #'7'	
	JMP	LERAD

I058:
	MOV	VALAD01, #'0' 
	MOV	VALAD02, #'5'
	MOV	VALAD03, #'8'	
	JMP	LERAD

I059:
	MOV	VALAD01, #'0' 
	MOV	VALAD02, #'5'
	MOV	VALAD03, #'9'	
	JMP	LERAD
I060:
	MOV	VALAD01, #'0' 
	MOV	VALAD02, #'6'
	MOV	VALAD03, #'0'	
	JMP	LERAD

I061:
	MOV	VALAD01, #'0' 
	MOV	VALAD02, #'6'
	MOV	VALAD03, #'1'	
	JMP	LERAD

I062:
	MOV	VALAD01, #'0' 
	MOV	VALAD02, #'6'
	MOV	VALAD03, #'2'	
	JMP	LERAD

I063:
	MOV	VALAD01, #'0' 
	MOV	VALAD02, #'6'
	MOV	VALAD03, #'3'	
	JMP	LERAD

I064:
	MOV	VALAD01, #'0' 
	MOV	VALAD02, #'6'
	MOV	VALAD03, #'4'	
	JMP	LERAD

I065:
	MOV	VALAD01, #'0' 
	MOV	VALAD02, #'6'
	MOV	VALAD03, #'5'	
	JMP	LERAD

I066:
	MOV	VALAD01, #'0' 
	MOV	VALAD02, #'6'
	MOV	VALAD03, #'6'	
	JMP	LERAD

I067:
	MOV	VALAD01, #'0' 
	MOV	VALAD02, #'6'
	MOV	VALAD03, #'7'	
	JMP	LERAD

I068:
	MOV	VALAD01, #'0' 
	MOV	VALAD02, #'6'
	MOV	VALAD03, #'8'	
	JMP	LERAD

I069:
	MOV	VALAD01, #'0' 
	MOV	VALAD02, #'6'
	MOV	VALAD03, #'9'	
	JMP	LERAD

I070:
	MOV	VALAD01, #'0' 
	MOV	VALAD02, #'7'
	MOV	VALAD03, #'0'	
	JMP	LERAD

I071:
	MOV	VALAD01, #'0' 
	MOV	VALAD02, #'7'
	MOV	VALAD03, #'1'	
	JMP	LERAD

I072:
	MOV	VALAD01, #'0' 
	MOV	VALAD02, #'7'
	MOV	VALAD03, #'2'	
	JMP	LERAD

I073:
	MOV	VALAD01, #'0' 
	MOV	VALAD02, #'7'
	MOV	VALAD03, #'3'	
	JMP	LERAD

I074:
	MOV	VALAD01, #'0' 
	MOV	VALAD02, #'7'
	MOV	VALAD03, #'4'	
	JMP	LERAD
I075:
	MOV	VALAD01, #'0' 
	MOV	VALAD02, #'7'
	MOV	VALAD03, #'5'	
	JMP	LERAD

I076:
	MOV	VALAD01, #'0' 
	MOV	VALAD02, #'7'
	MOV	VALAD03, #'6'	
	JMP	LERAD

I077:
	MOV	VALAD01, #'0' 
	MOV	VALAD02, #'7'
	MOV	VALAD03, #'7'	
	JMP	LERAD

I078:
	MOV	VALAD01, #'0' 
	MOV	VALAD02, #'7'
	MOV	VALAD03, #'8'	
	JMP	LERAD

I079:
	MOV	VALAD01, #'0' 
	MOV	VALAD02, #'7'
	MOV	VALAD03, #'9'	
	JMP	LERAD

I080:
	MOV	VALAD01, #'0' 
	MOV	VALAD02, #'8'
	MOV	VALAD03, #'0'	
	JMP	LERAD

I081:
	MOV	VALAD01, #'0' 
	MOV	VALAD02, #'8'
	MOV	VALAD03, #'1'	
	JMP	LERAD
I082:
	MOV	VALAD01, #'0' 
	MOV	VALAD02, #'8'
	MOV	VALAD03, #'2'	
	JMP	LERAD

I083:
	MOV	VALAD01, #'0' 
	MOV	VALAD02, #'8'
	MOV	VALAD03, #'3'	
	JMP	LERAD

I084:
	MOV	VALAD01, #'0' 
	MOV	VALAD02, #'8'
	MOV	VALAD03, #'4'	
	JMP	LERAD

I085:
	MOV	VALAD01, #'0' 
	MOV	VALAD02, #'8'
	MOV	VALAD03, #'5'	
	JMP	LERAD

I086:
	MOV	VALAD01, #'0' 
	MOV	VALAD02, #'8'
	MOV	VALAD03, #'6'	
	JMP	LERAD

I087:
	MOV	VALAD01, #'0' 
	MOV	VALAD02, #'8'
	MOV	VALAD03, #'7'	
	JMP	LERAD

I088:
	MOV	VALAD01, #'0' 
	MOV	VALAD02, #'8'
	MOV	VALAD03, #'8'	
	JMP	LERAD
I089:
	MOV	VALAD01, #'0' 
	MOV	VALAD02, #'8'
	MOV	VALAD03, #'9'	
	JMP	LERAD

I090:
	MOV	VALAD01, #'0' 
	MOV	VALAD02, #'9'
	MOV	VALAD03, #'0'	
	JMP	LERAD

I091:
	MOV	VALAD01, #'0' 
	MOV	VALAD02, #'9'
	MOV	VALAD03, #'1'	
	JMP	LERAD

I092:
	MOV	VALAD01, #'0' 
	MOV	VALAD02, #'9'
	MOV	VALAD03, #'2'	
	JMP	LERAD

I093:
	MOV	VALAD01, #'0' 
	MOV	VALAD02, #'9'
	MOV	VALAD03, #'3'	
	JMP	LERAD

I094:
	MOV	VALAD01, #'0' 
	MOV	VALAD02, #'9'
	MOV	VALAD03, #'4'	
	JMP	LERAD

I095:
	MOV	VALAD01, #'0' 
	MOV	VALAD02, #'9'
	MOV	VALAD03, #'5'	
	JMP	LERAD

I096:
	MOV	VALAD01, #'0' 
	MOV	VALAD02, #'9'
	MOV	VALAD03, #'6'	
	JMP	LERAD

I097:
	MOV	VALAD01, #'0' 
	MOV	VALAD02, #'9'
	MOV	VALAD03, #'7'	
	JMP	LERAD

I098:
	MOV	VALAD01, #'0' 
	MOV	VALAD02, #'9'
	MOV	VALAD03, #'8'	
	JMP	LERAD
I099:
	MOV	VALAD01, #'0' 
	MOV	VALAD02, #'9'
	MOV	VALAD03, #'9'	
	JMP	LERAD

I100:

	MOV	VALAD01, #'1' 
	MOV	VALAD02, #'0'
	MOV	VALAD03, #'0'	
	JMP	LERAD
I101:
	MOV	VALAD01, #'1' 
	MOV	VALAD02, #'0'
	MOV	VALAD03, #'1'	
	JMP	LERAD
I102:
	MOV	VALAD01, #'1' 
	MOV	VALAD02, #'0'
	MOV	VALAD03, #'2'	
	JMP	LERAD
I103:
	MOV	VALAD01, #'1' 
	MOV	VALAD02, #'0'
	MOV	VALAD03, #'3'	
	JMP	LERAD
I104:
	MOV	VALAD01, #'1' 
	MOV	VALAD02, #'0'
	MOV	VALAD03, #'4'	
	JMP	LERAD
I105:
	MOV	VALAD01, #'1' 
	MOV	VALAD02, #'0'
	MOV	VALAD03, #'5'	
	JMP	LERAD

I106:
	MOV	VALAD01, #'1' 
	MOV	VALAD02, #'0'
	MOV	VALAD03, #'6'	
	JMP	LERAD
I107:
	MOV	VALAD01, #'1' 
	MOV	VALAD02, #'0'
	MOV	VALAD03, #'7'	
	JMP	LERAD

I108:
	MOV	VALAD01, #'1' 
	MOV	VALAD02, #'0'
	MOV	VALAD03, #'8'	
	JMP	LERAD

I109:
	MOV	VALAD01, #'1' 
	MOV	VALAD02, #'0'
	MOV	VALAD03, #'9'	
	JMP	LERAD
I110:
	MOV	VALAD01, #'1' 
	MOV	VALAD02, #'1'
	MOV	VALAD03, #'0'	
	JMP	LERAD

I111:
	MOV	VALAD01, #'1' 
	MOV	VALAD02, #'1'
	MOV	VALAD03, #'1'	
	JMP	LERAD

I112:
	MOV	VALAD01, #'1' 
	MOV	VALAD02, #'1'
	MOV	VALAD03, #'2'	
	JMP	LERAD

I113:
	MOV	VALAD01, #'1' 
	MOV	VALAD02, #'1'
	MOV	VALAD03, #'3'	
	JMP	LERAD

I114:
	MOV	VALAD01, #'1' 
	MOV	VALAD02, #'1'
	MOV	VALAD03, #'4'	
	JMP	LERAD

I115:
	MOV	VALAD01, #'1' 
	MOV	VALAD02, #'1'
	MOV	VALAD03, #'5'	
	JMP	LERAD

I116:
	MOV	VALAD01, #'1' 
	MOV	VALAD02, #'1'
	MOV	VALAD03, #'6'	
	JMP	LERAD

I117:
	MOV	VALAD01, #'1' 
	MOV	VALAD02, #'1'
	MOV	VALAD03, #'7'	
	JMP	LERAD

I118:
	MOV	VALAD01, #'1' 
	MOV	VALAD02, #'1'
	MOV	VALAD03, #'8'	
	JMP	LERAD

I119:
	MOV	VALAD01, #'1' 
	MOV	VALAD02, #'1'
	MOV	VALAD03, #'9'	
	JMP	LERAD
I120:
	MOV	VALAD01, #'1' 
	MOV	VALAD02, #'2'
	MOV	VALAD03, #'0'	
	JMP	LERAD

I121:
	MOV	VALAD01, #'1' 
	MOV	VALAD02, #'2'
	MOV	VALAD03, #'1'	
	JMP	LERAD

I122:
	MOV	VALAD01, #'1' 
	MOV	VALAD02, #'2'
	MOV	VALAD03, #'2'	
	JMP	LERAD

I123:
	MOV	VALAD01, #'1' 
	MOV	VALAD02, #'2'
	MOV	VALAD03, #'3'	
	JMP	LERAD

I124:
	MOV	VALAD01, #'1' 
	MOV	VALAD02, #'2'
	MOV	VALAD03, #'4'	
	JMP	LERAD

I125:
	MOV	VALAD01, #'1' 
	MOV	VALAD02, #'2'
	MOV	VALAD03, #'5'	
	JMP	LERAD
I126:
	MOV	VALAD01, #'1' 
	MOV	VALAD02, #'2'
	MOV	VALAD03, #'6'	
	JMP	LERAD

I127:
	MOV	VALAD01, #'1' 
	MOV	VALAD02, #'2'
	MOV	VALAD03, #'7'	
	JMP	LERAD
I128:
	MOV	VALAD01, #'1' 
	MOV	VALAD02, #'2'
	MOV	VALAD03, #'8'	
	JMP	LERAD
I129:
	MOV	VALAD01, #'1' 
	MOV	VALAD02, #'2'
	MOV	VALAD03, #'9'	
	JMP	LERAD

I130:
	MOV	VALAD01, #'1' 
	MOV	VALAD02, #'3'
	MOV	VALAD03, #'0'	
	JMP	LERAD

I131:
	MOV	VALAD01, #'1' 
	MOV	VALAD02, #'3'
	MOV	VALAD03, #'1'	
	JMP	LERAD

I132:
	MOV	VALAD01, #'1' 
	MOV	VALAD02, #'3'
	MOV	VALAD03, #'2'	
	JMP	LERAD
I133:
	MOV	VALAD01, #'1' 
	MOV	VALAD02, #'3'
	MOV	VALAD03, #'3'	
	JMP	LERAD
I134:
	MOV	VALAD01, #'1' 
	MOV	VALAD02, #'3'
	MOV	VALAD03, #'4'	
	JMP	LERAD

I135:
	MOV	VALAD01, #'1' 
	MOV	VALAD02, #'3'
	MOV	VALAD03, #'5'	
	JMP	LERAD

I136:
	MOV	VALAD01, #'1' 
	MOV	VALAD02, #'3'
	MOV	VALAD03, #'6'	
	JMP	LERAD

I137:
	MOV	VALAD01, #'1' 
	MOV	VALAD02, #'3'
	MOV	VALAD03, #'7'	
	JMP	LERAD
I138:
	MOV	VALAD01, #'1' 
	MOV	VALAD02, #'3'
	MOV	VALAD03, #'8'	
	JMP	LERAD

I139:
	MOV	VALAD01, #'1' 
	MOV	VALAD02, #'3'
	MOV	VALAD03, #'9'	
	JMP	LERAD
I140:
	MOV	VALAD01, #'1' 
	MOV	VALAD02, #'4'
	MOV	VALAD03, #'0'	
	JMP	LERAD

I141:
	MOV	VALAD01, #'1' 
	MOV	VALAD02, #'4'
	MOV	VALAD03, #'1'	
	JMP	LERAD
I142:
	MOV	VALAD01, #'1' 
	MOV	VALAD02, #'4'
	MOV	VALAD03, #'2'	
	JMP	LERAD

I143:
	MOV	VALAD01, #'1' 
	MOV	VALAD02, #'4'
	MOV	VALAD03, #'3'	
	JMP	LERAD

I144:
	MOV	VALAD01, #'1' 
	MOV	VALAD02, #'4'
	MOV	VALAD03, #'4'	
	JMP	LERAD
I145:
	MOV	VALAD01, #'1' 
	MOV	VALAD02, #'4'
	MOV	VALAD03, #'5'	
	JMP	LERAD
I146:
	MOV	VALAD01, #'1' 
	MOV	VALAD02, #'4'
	MOV	VALAD03, #'6'	
	JMP	LERAD

I147:
	MOV	VALAD01, #'1' 
	MOV	VALAD02, #'4'
	MOV	VALAD03, #'7'	
	JMP	LERAD
I148:
	MOV	VALAD01, #'1' 
	MOV	VALAD02, #'4'
	MOV	VALAD03, #'8'	
	JMP	LERAD
I149:
	MOV	VALAD01, #'1' 
	MOV	VALAD02, #'4'
	MOV	VALAD03, #'9'	
	JMP	LERAD

I150:
	MOV	VALAD01, #'1' 
	MOV	VALAD02, #'5'
	MOV	VALAD03, #'0'	
	JMP	LERAD

I151:
	MOV	VALAD01, #'1' 
	MOV	VALAD02, #'5'
	MOV	VALAD03, #'1'	
	JMP	LERAD

I152:
	MOV	VALAD01, #'1' 
	MOV	VALAD02, #'5'
	MOV	VALAD03, #'2'	
	JMP	LERAD

I153:
	MOV	VALAD01, #'1' 
	MOV	VALAD02, #'5'
	MOV	VALAD03, #'3'	
	JMP	LERAD
I154:
	MOV	VALAD01, #'1' 
	MOV	VALAD02, #'5'
	MOV	VALAD03, #'4'	
	JMP	LERAD

I155:
	MOV	VALAD01, #'1' 
	MOV	VALAD02, #'5'
	MOV	VALAD03, #'5'	
	JMP	LERAD

I156:
	MOV	VALAD01, #'1' 
	MOV	VALAD02, #'5'
	MOV	VALAD03, #'6'	
	JMP	LERAD

I157:
	MOV	VALAD01, #'1' 
	MOV	VALAD02, #'5'
	MOV	VALAD03, #'7'	
	JMP	LERAD

I158:
	MOV	VALAD01, #'1' 
	MOV	VALAD02, #'5'
	MOV	VALAD03, #'8'	
	JMP	LERAD

I159:
	MOV	VALAD01, #'1' 
	MOV	VALAD02, #'5'
	MOV	VALAD03, #'9'	
	JMP	LERAD

I160:
	MOV	VALAD01, #'1' 
	MOV	VALAD02, #'6'
	MOV	VALAD03, #'0'	
	JMP	LERAD

I161:
	MOV	VALAD01, #'1' 
	MOV	VALAD02, #'6'
	MOV	VALAD03, #'1'	
	JMP	LERAD

I162:
	MOV	VALAD01, #'1' 
	MOV	VALAD02, #'6'
	MOV	VALAD03, #'2'	
	JMP	LERAD
I163:
	MOV	VALAD01, #'1' 
	MOV	VALAD02, #'6'
	MOV	VALAD03, #'3'	
	JMP	LERAD
I164:
	MOV	VALAD01, #'1' 
	MOV	VALAD02, #'6'
	MOV	VALAD03, #'4'	
	JMP	LERAD

I165:
	MOV	VALAD01, #'1' 
	MOV	VALAD02, #'6'
	MOV	VALAD03, #'5'		
	JMP	LERAD

I166:
	MOV	VALAD01, #'1' 
	MOV	VALAD02, #'6'
	MOV	VALAD03, #'6'	
	JMP	LERAD

I167:
	MOV	VALAD01, #'1' 
	MOV	VALAD02, #'6'
	MOV	VALAD03, #'7'	
	JMP	LERAD
I168:
	MOV	VALAD01, #'1' 
	MOV	VALAD02, #'6'
	MOV	VALAD03, #'8'	
	JMP	LERAD

I169:
	MOV	VALAD01, #'1' 
	MOV	VALAD02, #'6'
	MOV	VALAD03, #'9'	
	JMP	LERAD
I170:
	MOV	VALAD01, #'1' 
	MOV	VALAD02, #'7'
	MOV	VALAD03, #'0'	
	JMP	LERAD

I171:
	MOV	VALAD01, #'1' 
	MOV	VALAD02, #'7'
	MOV	VALAD03, #'1'	
	JMP	LERAD
I172:
	MOV	VALAD01, #'1' 
	MOV	VALAD02, #'7'
	MOV	VALAD03, #'2'	
	JMP	LERAD

I173:
	MOV	VALAD01, #'1' 
	MOV	VALAD02, #'7'
	MOV	VALAD03, #'3'	
	JMP	LERAD

I174:
	MOV	VALAD01, #'1' 
	MOV	VALAD02, #'7'
	MOV	VALAD03, #'4'	
	JMP	LERAD

I175:
	MOV	VALAD01, #'1' 
	MOV	VALAD02, #'7'
	MOV	VALAD03, #'5'	
	JMP	LERAD

I176:
	MOV	VALAD01, #'1' 
	MOV	VALAD02, #'7'
	MOV	VALAD03, #'6'	
	JMP	LERAD
I177:
	MOV	VALAD01, #'1' 
	MOV	VALAD02, #'7'
	MOV	VALAD03, #'8'	
	JMP	LERAD

I178:
	MOV	VALAD01, #'1' 
	MOV	VALAD02, #'7'
	MOV	VALAD03, #'8'	
	JMP	LERAD

I179:
	MOV	VALAD01, #'1' 
	MOV	VALAD02, #'7'
	MOV	VALAD03, #'9'	
	JMP	LERAD

I180:
	MOV	VALAD01, #'1' 
	MOV	VALAD02, #'8'
	MOV	VALAD03, #'0'	
	JMP	LERAD
I181:
	MOV	VALAD01, #'1' 
	MOV	VALAD02, #'8'
	MOV	VALAD03, #'1'	
	JMP	LERAD
I182:
	MOV	VALAD01, #'1' 
	MOV	VALAD02, #'8'
	MOV	VALAD03, #'2'	
	JMP	LERAD

I183:
	MOV	VALAD01, #'1' 
	MOV	VALAD02, #'8'
	MOV	VALAD03, #'3'	
	JMP	LERAD

I184:
	MOV	VALAD01, #'1' 
	MOV	VALAD02, #'8'
	MOV	VALAD03, #'4'	
	JMP	LERAD

I185:
	MOV	VALAD01, #'1' 
	MOV	VALAD02, #'8'
	MOV	VALAD03, #'5'	
	JMP	LERAD

I186:
	MOV	VALAD01, #'1' 
	MOV	VALAD02, #'8'
	MOV	VALAD03, #'6'	
	JMP	LERAD

I187:
	MOV	VALAD01, #'1' 
	MOV	VALAD02, #'8'
	MOV	VALAD03, #'7'	
	JMP	LERAD

I188:
	MOV	VALAD01, #'1' 
	MOV	VALAD02, #'8'
	MOV	VALAD03, #'8'	
	JMP	LERAD

I189:
	MOV	VALAD01, #'1' 
	MOV	VALAD02, #'8'
	MOV	VALAD03, #'9'	
	JMP	LERAD

I190:
	MOV	VALAD01, #'1' 
	MOV	VALAD02, #'9'
	MOV	VALAD03, #'0'	
	JMP	LERAD
I191:
	MOV	VALAD01, #'1' 
	MOV	VALAD02, #'9'
	MOV	VALAD03, #'1'	
	JMP	LERAD

I192:
	MOV	VALAD01, #'1' 
	MOV	VALAD02, #'9'
	MOV	VALAD03, #'2'	
	JMP	LERAD

I193:
	MOV	VALAD01, #'1' 
	MOV	VALAD02, #'9'
	MOV	VALAD03, #'3'	
	JMP	LERAD

I194:
	MOV	VALAD01, #'1' 
	MOV	VALAD02, #'9'
	MOV	VALAD03, #'4'	
	JMP	LERAD

I195:
	MOV	VALAD01, #'1' 
	MOV	VALAD02, #'9'
	MOV	VALAD03, #'5'	
	JMP	LERAD

I196:
	MOV	VALAD01, #'1' 
	MOV	VALAD02, #'9'
	MOV	VALAD03, #'6'	
	JMP	LERAD

I197:
	MOV	VALAD01, #'1' 
	MOV	VALAD02, #'9'
	MOV	VALAD03, #'7'	
	JMP	LERAD

I198:
	MOV	VALAD01, #'1' 
	MOV	VALAD02, #'9'
	MOV	VALAD03, #'8'	
	JMP	LERAD

I199:
	MOV	VALAD01, #'1' 
	MOV	VALAD02, #'9'
	MOV	VALAD03, #'9'	
	JMP	LERAD
I200:
	MOV	VALAD01, #'2' 
	MOV	VALAD02, #'0'
	MOV	VALAD03, #'0'	
	JMP	LERAD

I201:
	MOV	VALAD01, #'2' 
	MOV	VALAD02, #'0'
	MOV	VALAD03, #'1'	
	JMP	LERAD
I202:
	MOV	VALAD01, #'2' 
	MOV	VALAD02, #'0'
	MOV	VALAD03, #'2'	
	JMP	LERAD

I203:
	MOV	VALAD01, #'2' 
	MOV	VALAD02, #'0'
	MOV	VALAD03, #'3'	
	JMP	LERAD

I204:
	MOV	VALAD01, #'2' 
	MOV	VALAD02, #'0'
	MOV	VALAD03, #'4'	
	JMP	LERAD

I205:
	MOV	VALAD01, #'2' 
	MOV	VALAD02, #'0'
	MOV	VALAD03, #'5'	
	JMP	LERAD
I206:
	MOV	VALAD01, #'2' 
	MOV	VALAD02, #'0'
	MOV	VALAD03, #'6'	
	JMP	LERAD

I207:
	MOV	VALAD01, #'2' 
	MOV	VALAD02, #'0'
	MOV	VALAD03, #'7'	
	JMP	LERAD

I208:
	MOV	VALAD01, #'2' 
	MOV	VALAD02, #'0'
	MOV	VALAD03, #'8'	
	JMP	LERAD

I209:
	MOV	VALAD01, #'2' 
	MOV	VALAD02, #'0'
	MOV	VALAD03, #'9'	
	JMP	LERAD

I210:
	MOV	VALAD01, #'2' 
	MOV	VALAD02, #'1'
	MOV	VALAD03, #'0'	
	JMP	LERAD

I211:
	MOV	VALAD01, #'2' 
	MOV	VALAD02, #'1'
	MOV	VALAD03, #'1'	
	JMP	LERAD
I212:
	MOV	VALAD01, #'2' 
	MOV	VALAD02, #'1'
	MOV	VALAD03, #'2'	
	JMP	LERAD
I213:
	MOV	VALAD01, #'2' 
	MOV	VALAD02, #'1'
	MOV	VALAD03, #'3'	
	JMP	LERAD
I214:
	MOV	VALAD01, #'2' 
	MOV	VALAD02, #'1'
	MOV	VALAD03, #'4'	
	JMP	LERAD

I215:
	MOV	VALAD01, #'2' 
	MOV	VALAD02, #'1'
	MOV	VALAD03, #'5'	
	JMP	LERAD
I216:
	MOV	VALAD01, #'2' 
	MOV	VALAD02, #'1'
	MOV	VALAD03, #'6'	
	JMP	LERAD

I217:
	MOV	VALAD01, #'2' 
	MOV	VALAD02, #'1'
	MOV	VALAD03, #'7'	
	JMP	LERAD
I218:
	MOV	VALAD01, #'2' 
	MOV	VALAD02, #'1'
	MOV	VALAD03, #'8'	
	JMP	LERAD

I219:
	MOV	VALAD01, #'2' 
	MOV	VALAD02, #'1'
	MOV	VALAD03, #'9'	
	JMP	LERAD

I220:
	MOV	VALAD01, #'2' 
	MOV	VALAD02, #'2'
	MOV	VALAD03, #'0'	
	JMP	LERAD

I221:
	MOV	VALAD01, #'2' 
	MOV	VALAD02, #'2'
	MOV	VALAD03, #'1'	
	JMP	LERAD

I222:
	MOV	VALAD01, #'2' 
	MOV	VALAD02, #'2'
	MOV	VALAD03, #'2'	
	JMP	LERAD

I223:
	MOV	VALAD01, #'2' 
	MOV	VALAD02, #'2'
	MOV	VALAD03, #'3'	
	JMP	LERAD

I224:
	MOV	VALAD01, #'2' 
	MOV	VALAD02, #'2'
	MOV	VALAD03, #'4'	
	JMP	LERAD

I225:
	MOV	VALAD01, #'2' 
	MOV	VALAD02, #'2'
	MOV	VALAD03, #'5'	
	JMP	LERAD

I226:
	MOV	VALAD01, #'2' 
	MOV	VALAD02, #'2'
	MOV	VALAD03, #'6'	
	JMP	LERAD

I227:
	MOV	VALAD01, #'2' 
	MOV	VALAD02, #'2'
	MOV	VALAD03, #'7'	
	JMP	LERAD

I228:
	MOV	VALAD01, #'2' 
	MOV	VALAD02, #'2'
	MOV	VALAD03, #'8'	
	JMP	LERAD
I229:
	MOV	VALAD01, #'2' 
	MOV	VALAD02, #'2'
	MOV	VALAD03, #'9'	
	JMP	LERAD

I230:
	MOV	VALAD01, #'2' 
	MOV	VALAD02, #'3'
	MOV	VALAD03, #'0'	
	JMP	LERAD

I231:
	MOV	VALAD01, #'2' 
	MOV	VALAD02, #'3'
	MOV	VALAD03, #'1'	
	JMP	LERAD
I232:
	MOV	VALAD01, #'2' 
	MOV	VALAD02, #'3'
	MOV	VALAD03, #'2'	
	JMP	LERAD

I233:
	MOV	VALAD01, #'2' 
	MOV	VALAD02, #'3'
	MOV	VALAD03, #'3'	
	JMP	LERAD

I234:
	MOV	VALAD01, #'2' 
	MOV	VALAD02, #'3'
	MOV	VALAD03, #'4'	
	JMP	LERAD

I235:
	MOV	VALAD01, #'2' 
	MOV	VALAD02, #'3'
	MOV	VALAD03, #'5'	
	JMP	LERAD
I236:
	MOV	VALAD01, #'2' 
	MOV	VALAD02, #'3'
	MOV	VALAD03, #'6'	
	JMP	LERAD
I237:
	MOV	VALAD01, #'2' 
	MOV	VALAD02, #'3'
	MOV	VALAD03, #'7'	
	JMP	LERAD

I238:
	MOV	VALAD01, #'2' 
	MOV	VALAD02, #'3'
	MOV	VALAD03, #'8'	
	JMP	LERAD

I239:
	MOV	VALAD01, #'2' 
	MOV	VALAD02, #'3'
	MOV	VALAD03, #'9'	
	JMP	LERAD

I240:
	MOV	VALAD01, #'2' 
	MOV	VALAD02, #'4'
	MOV	VALAD03, #'0'	
	JMP	LERAD

I241:
	MOV	VALAD01, #'2' 
	MOV	VALAD02, #'4'
	MOV	VALAD03, #'1'	
	JMP	LERAD

I242:
	MOV	VALAD01, #'2' 
	MOV	VALAD02, #'4'
	MOV	VALAD03, #'2'	
	JMP	LERAD

I243:
	MOV	VALAD01, #'2' 
	MOV	VALAD02, #'4'
	MOV	VALAD03, #'3'	
	JMP	LERAD

I244:
	MOV	VALAD01, #'2' 
	MOV	VALAD02, #'4'
	MOV	VALAD03, #'4'	
	JMP	LERAD

I245:
	MOV	VALAD01, #'2' 
	MOV	VALAD02, #'4'
	MOV	VALAD03, #'5'	
	JMP	LERAD

I246:
	MOV	VALAD01, #'2' 
	MOV	VALAD02, #'4'
	MOV	VALAD03, #'6'	
	JMP	LERAD

I247:
	MOV	VALAD01, #'2' 
	MOV	VALAD02, #'4'
	MOV	VALAD03, #'7'	
	JMP	LERAD

I248:
	MOV	VALAD01, #'2' 
	MOV	VALAD02, #'4'
	MOV	VALAD03, #'8'	
	JMP	LERAD
I249:
	MOV	VALAD01, #'2' 
	MOV	VALAD02, #'4'
	MOV	VALAD03, #'9'	
	JMP	LERAD

I250:
	MOV	VALAD01, #'2' 
	MOV	VALAD02, #'5'
	MOV	VALAD03, #'0'	
	JMP	LERAD

I251:
	MOV	VALAD01, #'2' 
	MOV	VALAD02, #'5'
	MOV	VALAD03, #'1'	
	JMP	LERAD

I252:
	MOV	VALAD01, #'2' 
	MOV	VALAD02, #'5'
	MOV	VALAD03, #'2'	
	JMP	LERAD

I253:
	MOV	VALAD01, #'2' 
	MOV	VALAD02, #'5'
	MOV	VALAD03, #'3'	
	JMP	LERAD

I254:
	MOV	VALAD01, #'2' 
	MOV	VALAD02, #'5'
	MOV	VALAD03, #'4'	
	JMP	LERAD

I255:
	MOV	VALAD01, #'2' 
	MOV	VALAD02, #'5'
	MOV	VALAD03, #'5'	
	JMP	LERAD


	JMP	PRINCIPAL


	
	END					; Fim da compilação do programa


	

		

;########################################
;########## Restos de programa ##########
;########## Subrotinas prontas ##########
;########################################	


; Linha 2
;CARAC21  EQU	37				; Caracter 21
;CARAC22  EQU	38
;CARAC23  EQU	39
;CARAC24  EQU	40
;CARAC25  EQU	41
;CARAC26  EQU	42
;CARAC27  EQU	43
;CARAC28  EQU	44
;CARAC29  EQU	45
;CARAC30  EQU	46
;CARAC31  EQU	47
;CARAC32  EQU	48
;CARAC33  EQU	49
;CARAC34  EQU	50
;CARAC35  EQU	51
;CARAC36  EQU	52
;CARAC37  EQU	53
;CARAC38  EQU	54
;CARAC39  EQU	55
;CARAC40  EQU	56				; Caracter 40

; Linha 3					
;CARAC41  EQU	58				; Caracter 41
;CARAC42  EQU	59
;CARAC43  EQU	60
;CARAC44  EQU	61
;CARAC45  EQU	62
;CARAC46  EQU	63
;CARAC47  EQU	64
;CARAC48  EQU	65
;CARAC49  EQU	66
;CARAC50  EQU	67
;CARAC51  EQU	68
;CARAC52  EQU	69
;CARAC53  EQU	70
;CARAC54  EQU	71
;CARAC55  EQU	72
;CARAC56  EQU	73
;CARAC57  EQU	74
;CARAC58  EQU	75
;CARAC59  EQU	76
;CARAC60  EQU	77				; Caracter 60

; Linha 4					
;CARAC61  EQU	79				; Caracter 61
;CARAC62  EQU	80
;CARAC63  EQU	81
;CARAC64  EQU	82
;CARAC65  EQU	83
;CARAC66  EQU	84
;CARAC67  EQU	85
;CARAC68  EQU	86
;CARAC69  EQU	87
;CARAC70  EQU	88
;CARAC71  EQU	89
;CARAC72  EQU	90
;CARAC73  EQU	91
;CARAC74  EQU	92
;CARAC75  EQU	93
;CARAC76  EQU	94
;CARAC77  EQU	95
;CARAC78  EQU	96
;CARAC79  EQU	97
;CARAC80  EQU	98				; Caracter 80



TECLADO2:

TECLADO:					; Rotina de atendimento de teclado

TEC21:
	JNB	P3.7, MENU21			; Verifica se tem tecla do teclado apertada e salta estiver
	
TEC22:	
	JNB	P3.6, MENU22			; Verifica se tem tecla do teclado apertada e salta estiver
            	
TEC23:
	JNB	P3.5, MENU23			; Verifica se tem tecla do teclado apertada e salta estiver
        

	JMP	PRINCIPAL			; Salta para rotina endereçada


MENU21:						; Link para saltar mais de 128 bytes	
	JMP	BOTAO21				; Salta para rotina endereçada

MENU22:						; Link para saltar mais de 128 bytes
	JMP	BOTAO22				; Salta para rotina endereçada

MENU23:						; Link para saltar mais de 128 bytes
	JMP	BOTAO23				; Salta para rotina endereçada






TELA11:

	MOV	CARAC01, #' '			
	MOV	CARAC02, #' '
	MOV	CARAC03, #' '
	MOV	CARAC04, #' '
	MOV	CARAC05, #' '
	MOV	CARAC06, #' '
	MOV	CARAC07, #' '
	MOV	CARAC08, #' '
	MOV	CARAC09, #' '
	MOV	CARAC10, #' '
	MOV	CARAC11, #' '			
	MOV	CARAC12, #' '
	MOV	CARAC13, #' '
	MOV	CARAC14, #' '
	MOV	CARAC15, #' '
	MOV	CARAC16, #' '
	MOV	CARAC17, #' '
	MOV	CARAC18, #' ' 
	MOV	CARAC19, #' '
	MOV	CARAC20, #' '

TELA12:

	MOV	CARAC21, #' '			
	MOV	CARAC22, #' '
	MOV	CARAC23, #' '
	MOV	CARAC24, #' '
	MOV	CARAC25, #' '
	MOV	CARAC26, #' '
	MOV	CARAC27, #' '
	MOV	CARAC28, #' '
	MOV	CARAC29, #' '
	MOV	CARAC30, #' '
	MOV	CARAC31, #' '			
	MOV	CARAC32, #' '
	MOV	CARAC33, #' '
	MOV	CARAC34, #' '
	MOV	CARAC35, #' '
	MOV	CARAC36, #' '
	MOV	CARAC37, #' '
	MOV	CARAC38, #' '
	MOV	CARAC39, #' '
	MOV	CARAC40, #' '






TELA13:

	MOV	CARAC41, #' '			
	MOV	CARAC42, #' '
	MOV	CARAC43, #' '
	MOV	CARAC44, #' '
	MOV	CARAC45, #' '
	MOV	CARAC46, #' '
	MOV	CARAC47, #' '
	MOV	CARAC48, #' '
	MOV	CARAC59, #' '
	MOV	CARAC50, #' '
	MOV	CARAC51, #' '			
	MOV	CARAC52, #' '
	MOV	CARAC53, #' '
	MOV	CARAC54, #' '
	MOV	CARAC55, #' '
	MOV	CARAC56, #' '
	MOV	CARAC57, #' '
	MOV	CARAC58, #' '
	MOV	CARAC59, #' '
	MOV	CARAC60, #' '

TELA14:

	MOV	CARAC61, #' '			
	MOV	CARAC62, #' '
	MOV	CARAC63, #' '
	MOV	CARAC64, #' '
	MOV	CARAC65, #' '
	MOV	CARAC66, #' '
	MOV	CARAC67, #' '
	MOV	CARAC68, #' '
	MOV	CARAC69, #' '
	MOV	CARAC70, #' '
	MOV	CARAC71, #' '			
	MOV	CARAC72, #' '
	MOV	CARAC73, #' '
	MOV	CARAC74, #' '
	MOV	CARAC75, #' '
	MOV	CARAC76, #' '
	MOV	CARAC77, #' '
	MOV	CARAC78, #' '
	MOV	CARAC79, #' '
	MOV	CARAC80, #' '

		



#include<mandingas.h>

int temporizador = 0;


//	#####################################################################
//	############################## Funções ##############################
//	#####################################################################


//  #####################################################################
//	################ Rotinas de função para o display ###################
//  #####################################################################

//	############## Rotinas de inicialização do display ##################

void configura_Display(){
	FUNCDIS (56);
	FUNCDIS (56);
	FUNCDIS (6);
	FUNCDIS (12);
	FUNCDIS (1);
	FUNCDIS (128);	
}





//	############ Rotina para enviar caracter para o display ################

void ImpDis(char a[20], int b){

int i;
for (i = b; i<20; i++){


	P1 = a[i];
	DadoDis();
	DEL40uS();
}
}

void DadoDis(){																				// Função para enviar dados ao display
			P3_0 = 1;									 											// Configura display para receber dados
			P3_1 = 1;																				// Habilita a leitura de instruções/dados
			DEL40uS();																			// Delay necessário para o display
			P3_1 = 0;
}


//	########### Rotina para selecionar a linha do display ###############

void SelLinha(int linha){															// Bloco para selecionar a linha a ser escriata no diaplay
		int l;	
	switch(linha){
		case 1:
						l = 128; break;														// Nesse caso linha 1 "80h"
		case 2:
						l = 192; break;														// Nesse caso linha 2 "0c0h"
		case 3:
						l = 148; break;														// Nesse caso linha 3 "94h"
		case 4: 
						l = 212; break;														// Nesse caso linha 4 "0d4h"
		} 
FUNCDIS(l);																						// Envia a linha selecionada para o display
	}


//	############ Rotina para enviar função para o display ################


void FUNCDIS (int func){															// Bloco de função proriamente dito
			P3_0 = 0;									 											// Configura display para receber instruções
			P3_1 = 1;																				// Habilita a leitura de instruções/dados
			P1 = func;				 															// Coloca o dado na porta de leitura/escrita do display
			DEL3mS();																				// Rotina de delay para 3ms
			P3_1 = 0;																				// Desabilita leitura de instruções/dados	
		}

//  #####################################################################
//	######################## Rotinas de delay ###########################
//  #####################################################################

void DELSEG(){																					// Função para delay de 1 segundo
  TMOD = 2;																							// Configura Timer/Counter no modo 2 (dois Timers com recarga automática)
  TL0 = 55;																							// Valor inicial da contagem
  TH0 = 55;																							// Valor de recarga automática
  PT0 = 1;																							// Define prioridade para Timer 0
  EA  = 1;																							// Ativa todas as interrupções
  ET0 = 1;																							// Ativa interrupção interna do Timer 0
  TR0 = 1;																							// Dispara contagem
	temporizador = 0;																			// Varíáve do contador secundario (complementar) decontagem
 while(temporizador <5000){}															// Laço até que tempo seja o tempo seja concluido
	TR0 = 0;																							// Pausa a contagem	
}

	
void DEL02SEG(){																			// Função para delay de 200 milisegundos
  TMOD = 2;																							// Configura Timer/Counter no modo 2 (dois Timers com recarga automática)
  TL0 = 55;																							// Valor inicial da contagem
  TH0 = 55;																							// Valor de recarga automática
  PT0 = 1;																							// Define prioridade para Timer 0
  EA  = 1;																							// Ativa todas as interrupções
  ET0 = 1;																							// Ativa interrupção interna do Timer 0
  TR0 = 1;																							// Dispara contagem
	temporizador = 0;																			// Varíáve do contador secundario (complementar) decontagem
 while(temporizador <1000){}															// Laço até que tempo seja o tempo seja concluido
	TR0 = 0;																							// Pausa a contagem	
}



void DEL01SEG(){																			// Função para delay de 500 milisegundos
  TMOD = 2;																							// Configura Timer/Counter no modo 2 (dois Timers com recarga automática)
  TL0 = 55;																							// Valor inicial da contagem
  TH0 = 55;																							// Valor de recarga automática
  PT0 = 1;																							// Define prioridade para Timer 0
  EA  = 1;																							// Ativa todas as interrupções
  ET0 = 1;																							// Ativa interrupção interna do Timer 0
  TR0 = 1;																							// Dispara contagem
	temporizador = 0;																			// Varíáve do contador secundario (complementar) decontagem
 while(temporizador <500){}															// Laço até que tempo seja o tempo seja concluido
	TR0 = 0;																							// Pausa a contagem	
}

	

void DEL3mS(){																					// Bloco de delay de 3 milisegundos
  TMOD = 2;																							// Configura Timer/Counter no modo 2 (dois Timers com recarga automática)
  TL0 = 55;																							// Valor inicial da contagem
  TH0 = 55;																							// Valor de recarga automática
  PT0 = 1;																							// Define prioridade para Timer 0
  EA  = 1;																							// Ativa todas as interrupções
  ET0 = 1;																							// Ativa interrupção interna do Timer 0
  TR0 = 1;																							// Dispara contagem
	temporizador = 0;																			// Varíáve do contador secundario (complementar) decontagem
 while(temporizador <33){}															// Laço até que tempo seja o tempo seja concluido
	TR0 = 0;																							// Pausa a contagem

}


void DEL40uS(){																					// Bloco de delay de 40 microsegundos
  TMOD = 2;																							// Configura Timer/Counter no modo 2 (dois Timers com recarga automática)
  TL0 = 216;																						// Valor inicial da contagem
  TH0 = 216;																						// Valor de recarga automática
  PT0 = 1;																							// Define prioridade para Timer 0
  EA  = 1;																							// Ativa todas as interrupções
  ET0 = 1;																							// Ativa interrupção interna do Timer 0
  TR0 = 1;																							// Dispara contagem
	temporizador = 0;																			// Varíáve do contador secundario (complementar) decontagem
 while(temporizador <2){}																// Laço até que tempo seja o tempo seja concluido
	TR0 = 0;																							// Pausa a contagem
}


//  #####################################################################	
// 	###################### Chamadas de Interrupção ######################	
//  #####################################################################	

// 	############ Rotina chamada pela interrupção externa 0 ##############
void Atendimento_Interrupcao_Ex0() interrupt 0
{
return;
}

// 	############ Rotina chamada pela interrupção do Timer 0 #############
void Atendimento_interrupcao_Timer0() interrupt 1
{
	temporizador ++;
}

// 	############ Rotina chamada pela interrupção externa 1 ##############
void Atendimento_Interrupcao_Ex1() interrupt 2
{
return;
}

// 	############ Rotina chamada pela interrupção do Timer 1 #############
void Atendimento_interrupcao_Timer1() interrupt 3
{
return;
}


// 	########## Rotina chamada pela interrupção do canal Serial ###########
void Atendimento_interrupcao_Serial() interrupt 4
{
return;
} 	

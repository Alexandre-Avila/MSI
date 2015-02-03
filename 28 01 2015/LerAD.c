
// ################# Biblioteca de funções de leitura do conversor A/D

#include<LerAD.h>
#include<AT89X52.H>

// ################### P2 =	barramento de dados do AD ######################

// ################ P0 =	barramento de controle do AD ###################
// P0 = 	barramento de controle AD
// P0_0		Pino 1 de seleção de porta do AD
// P0_1		Pino 2 de seleção de porta do AD
// P0_2		Pino 3 de seleção de porta do AD
// P0_3		ativa ALE
// P0_4		Start do AD	
// P0_5		EOC sinaliza o fim da conversão(End of conversion)
// P0_6		OE coloca o dado no barramento (out put enable)


void LerAD(){
	incAD();
	LerADx(1);
	}
void IncAD(){
 	P0_3 = 0;												 	// Desativa ALE
	P0_4 = 0;											     	// Desativa Start
	P0_6 = 0;													// Desativa OE (coloca barramento em tree state)
	}															

void LerADx(int ad){

	switch(ad){					 								// Seleciona AD
		case 1:
				ad = 1;	P0_0 = 0;
						P0_1 = 0;
						P0_2 = 0; break;						// Seleciona AD 1											
		case 2:
				ad = 2;	P0_0 = 1;
						P0_1 = 0;
						P0_2 = 0; break;						// Seleciona AD 2					
		case 3:											   	
				ad = 3;	P0_0 = 0;
						P0_1 = 1;
						P0_2 = 0; break;						// Seleciona AD 3					
		case 4: 
				ad = 4; P0_0 = 1;
						P0_1 = 1;
						P0_2 = 0; break;						// Seleciona AD 4
		case 5:
				ad = 5;	P0_0 = 0;
						P0_1 = 0;
						P0_2 = 1; break;						// Seleciona AD 5
		case 6:
				ad = 6;	P0_0 = 1;
						P0_1 = 0;
						P0_2 = 1; break;						// Seleciona AD 6
		case 7:
				ad = 7;	P0_0 = 0;
						P0_1 = 1;
						P0_2 = 1; break;						// Seleciona AD 7
		case 8:
				ad = 8;	P0_0 = 1;
						P0_1 = 1;
						P0_2 = 1; break;						// Seleciona AD 8
		} 

	   P0_4 = 1;												// Ativa Start
	   P0_4 = 0;												// Desativa Start
	   while (P0_5 = 0){} 										// Monitora EOC
	   P0_6 = 1;												// Ativa OE (coloca dado no barramento)
	   P0_6 = 0;												// Desativa OE (coloca barramento em tree state)

 	}
 
 										   
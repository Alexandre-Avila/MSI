 
 // ********************* Reescrevendo o progrma MSI em C ******************



#include<mandingas.h>





void main (){

	
while ( 1 ){


	configura_Display();
	
	
	SelLinha(1);																					// Função para selecionar a linha a ser escrita no display	
	ImpDis("Teste de display    ", 0);										// Função de envio de linha + posição inicial da linha
	SelLinha(2);
	ImpDis("Agora escrito em C  ", 0);
	DELSEG();
	SelLinha(3);
	ImpDis("Fumeta pra caralho  ", 0);
	DELSEG();
	DELSEG();
	SelLinha(4);
	ImpDis("Demorou, mas saiu...", 0);
	LerAD();
	
	while (1){}
	


}
}


 
 // ********************* Reescrevendo o progrma MSI em C ******************



#include<mandingas.h>





void main (){

	
while ( 1 ){


	configura_Display();
	
	
	SelLinha(1);																					// Fun��o para selecionar a linha a ser escrita no display	
	ImpDis("Teste de display    ", 0);										// Fun��o de envio de linha + posi��o inicial da linha
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


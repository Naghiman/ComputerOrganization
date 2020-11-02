///////Subroutine in ARM, which will be called by C pure.c program/////////

//Imane Chafi 260847716
	.text
	.global MAX_2
MAX_2: 
	CMP R0, R1 //Check if R0 is bigger than or equal R1
	BXGE LR //If so, then R0 is still our max, branch back to the next number 
	MOV R0, R1 //If not, the move R1 (MAX) into R0
	BX LR //Branch 
	.end

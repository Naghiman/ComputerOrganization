	
/////////////////////////PART1.S///////////////////////////////
//Imane Chafi 260847716
//Narry Zendehrooh 260700556
		.text
		.global _start

_start: 
			LDR R4, =RESULT //R4 points to the result location
			LDR R2, [R4, #4] //R2 holds the number of elements in the list
			ADD R3, R4, #8 // R3 points to the first number in the list
			LDR R0, [R3] //R0 holds what there is in R3

LOOP:		SUBS R2, R2, #1 //decrement the loop counter
			BEQ DONE //end the loop if the counter has reached 0
			ADD R3, R3, #4 //R3 points to the next number in the list
			LDR R1, [R3] //R1 holds the next number in the list
			CMP R0, R1 //Check if R1 is bigger than R0
			BGE LOOP//if not, branch to the loop
			MOV R0, R1 //if yes, move the value of R1 into R0
			B LOOP //branch back to the loop to check the next number

DONE: 		STR R0, [R4] //Storing the value of R4 inside of R0 

END: 		B END //End branch into an infinite loop!

///////////VARIABLES/////////////
RESULT:		.word 0 //result memory allocation
N: 			.word 7 //Numbers of elements in the list
NUMBERS:	.word 4,5,3,6
			.word 1,8,2 //Values to use in the list data for the greatest integer!

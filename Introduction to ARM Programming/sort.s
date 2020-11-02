	
/////////////////////////SORT.S///////////////////////////////
//Imane Chafi 260847716
//Narry Zendehrooh 260700556
			.text
			.global _start

_start:
			LDR R4, =RESULT	//Final result r4 = 0
			LDR R11, [R4, #4] //This is the number elements = 4
				
//////////UPPER LOOP////////
CheckMoveValue:	//utimate loop
				MOV R7, R11	//Temp variable for number elements	 	
				SUBS R11, R11, #1	//Decrement 	
				BEQ END				
				ADD R3, R4, #8 //first number		
				LDR R0, [R3] //r0 = value of first number	
				ADD R5, R3, #4 //second element
				LDR R1, [R5] //r1 a second 		
				B CheckBetweenNumbers		
			
/////////INNER LOOP//////
CheckBetweenNumbers:	
			SUBS R7, R7, #1	//decrement	
			BEQ CheckMoveValue //if not equal to 0, no flag has been raised to we 
			CMP R1, R0 // R0 is smaller than R1 you good 		
			BLT ChangeNumbers //change number if not		
			ADD R3, R3, #4 //If the 2nd number is not smaller than first number, just switch R3 to the second number		
			LDR R0, [R3] //store the new value of r3 in r0		
			ADD R5, R5, #4	//just switch R5 to the third number
			LDR R1, [R5] //load new value of r5 in r1 		
			B CheckBetweenNumbers //go back and check the numbers again with the new values, the inner loop until the increment is over!
		
/////////CHANGE NUMBERS///////	
ChangeNumbers:		
			MOV R12, R1 //Temp variables for swaping numbers, R12 is a temp variable
			MOV R1, R0		
			MOV R0, R12		
			STR R0, [R3] //store value of r0 inside of what r3 points in memory (chnge first number by what is r0
			STR R1, [R5] //store value of r1 inside of what r5 points in memory (chnge second number by what is r1	
			ADD R3, R3, #4 //Then we add 4 to r3 to change the value of r3 pointer to the next number in list	
			LDR R0, [R3] //load the new value to R0		
			ADD R5, R5, #4	//Then we add 4 to r5 to change the value of r5 pointer to the next number in list
			LDR R1, [R5] //load the new value to R1	
			B CheckBetweenNumbers //Go back to the check between numbers until the inner loop is over!				

END: 		B END //END THE LOOP INFINITELY!!!		

RESULT:		.word	0 //The first value result to start the array		
N:			.word	6 //The number of elements in the list	
NUMBERS:	.word	2, 5, 2, 77, 2, 1 //the values of the list, unsorted!!

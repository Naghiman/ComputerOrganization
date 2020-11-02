
//////////////////////STDDEV.S//////////////////////////////////////
//Imane Chafi 260847716
//Narry Zendehrooh 260700556

			.text
			.global _start

_start: //We are looking at R1 as the value between the first i and next number i + r1 + 1
			LDR R4, =RESULT //R4 has the location of the result
			LDR R2, [R4, #4] //R2 is the number of elements in the list
			ADD R3, R4, #8// The next number (first number) is pointed by the R3 register
			LDR R0, [R3] //R0 also has the first number in the list (since it loads what is inside of r3) 
			LDR R5, [R3]//R0 also has the first number in the list (since it loads what is inside of r3) 

LOOP:		SUBS R2, R2, #1 // This is the condition for the done value, we substract 1 to r2 everytime we run the loop until we reach 0,  and then we got to the BEQ branch DONE! 
			BEQ STDDEV_sub // Branch that goes to doing the std dev substraction if the increment is 0 (if R2 is 0)
			ADD R3, R3, #4 // R3 is the next number in the list(2nd number) //Only need to offset by 4 to get to the next number
			LDR R1, [R3] // R1 has R3 (what is stored in R3, which is the second number in the list)
			CMP R1, R0 // Is R0 smaller than R1?
			BLT XMINIMUM	// branch to Min if R1 is less than R0 //NOT OPTION

//Second loop we would have had
			CMP R5, R1// We still check if R1 is bigger than R5, R5 is the value of the first number in list
			BGE LOOP// NOT, branch back to the loop //NOT OPTION
			MOV R5, R1// YES, update the curent max (THE MAX IS IN R5)
			B LOOP//Get back to the loop until you reach the final value i

XMINIMUM:	MOV R0, R1// THE MIN IS IN R0
			B LOOP// branch back to the min for the next value

STDDEV_sub:		SUBS R6, R5, R0//Substract xmax from xmin, R6 = R5 - R0 	
				B STDDEV_divide //Branch to the divide branch

STDDEV_divide: LSR R7, R6, #2// right shift by 2 to divide by 2^2
			   STR R7, [R4]//FINAL VALUE STORED IN R7

END:		B END//This infinite loop to end the project!

RESULT:		.word	0//Result location for the word of the result (has only 0)
N:			.word	3//Number of elements in the list of data
NUMBERS:	.word	8, 1, 0	//the list data //This should give 8-0/4 = 2 inside of R7

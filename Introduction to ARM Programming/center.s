	
/////////////////////////CENTER.S///////////////////////////////
//Imane Chafi 260847716
//Narry Zendehrooh 260700556
			.text
			.global _start

_start:
			LDR R4, =RESULT	//R4 has the result first value in memory, 0
			LDR R2, [R4, #4] // R2 is right after the result, which is the number of elements in the list, N
			LDR R6, [R4, #4]// R6 is a word after, which is the first number in the list
			LDR R12, [R4, #4]//R12 has the second number in the list`
			ADD R3, R4, #8//Add 8 to the 0, which is the first number in the list		
			ADD R7, R4, #8//Add 8 to the 0, which is the first number in the list
			LDR R0, [R3]//Load the value of R3, which is the first number into r0
			LDR R8, [R7]//Load the value of R3, which is the first number into r8
			MOV R10, #1//R10 has 1 now
			MOV R11, #0//R11 has 0 now

//NORMAL LOOP for the number of elements in the list to add all elements and then make the average (total) afterwards
NORMAL_LOOP_ADD_AVERAGE:SUBS R2, R2, #1	//R2 has the number of elements, which means that we decrement by 1 from the number of elements
			BEQ BRANCH_AVERAGE_OR_NOT //if it's 0, you can go to BRANCH_AVERAGE_OR_NOT branch!
			ADD R3, R3, #4 //R3 is now the second number in the list
			LDR R1, [R3]//R1 is the second number in the list
			ADD R0, R0, R1//We add r1 and r0 inside of r0
			B NORMAL_LOOP_ADD_AVERAGE//total value branched back

BRANCH_AVERAGE_OR_NOT:	CMP R10, R12	//Comparing the 1 and 0 from the r10 and r12 if they are equal, branch to average
			BEQ AVERAGE_VALUE	//end tp average if they are equal, which is a boolean check
			ADD R11, R11, #1 //Add 1 to R11
			LSL R10, R10, #1//We shift R10 by 1 to the left shift logical
			B BRANCH_AVERAGE_OR_NOT //Continue until R10 and R12  are equal

////////////////AVERAGE BRANCH THAT SHIFTS TOTAL TO RIGHT BY 1//////////////////
AVERAGE_VALUE:	ASR R0, R0, #1 //Shift to right by 1, arithmatic shift right, R0 holds the average !
			SUBS R11, R11, #1 // decrement r11 by 1 
			BEQ SIGNAL_SUB//Once the r11 reached 0, go to substract, which means that we have divided by the number of elements and have the average, we can leave and substract the average R0 for each signal
			B AVERAGE_VALUE//If not go back to the average value!!!!

//We simply substract average from each value of the signal!!!
SIGNAL_SUB:	SUBS R8, R8, R0//Substracy from R8, which is the first number in array, R0 average value
			STR R8, [R7] //Store r8 in the address r7
			SUBS R6, R6, #1	//Loop counter -1 until we get to 0, where we need to get out!!!
			BEQ END	
			ADD R7, R7, #4//Next number in list is R7 +4
			LDR R8, [R7]//load back in R8 next number in list!!!
			B SIGNAL_SUB//Continue to substract for each element until loop is over!

END:		B END					// infinite loop!

RESULT:		.word	0				// memory assigned for result location
N:			.word	4				// number of entries in the list
NUMBERS:	.word	2, 2, 2, 2		// the list data

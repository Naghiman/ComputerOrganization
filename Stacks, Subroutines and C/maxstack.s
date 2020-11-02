/////////////////////maxstack.s/////////////////////////////
/////////////////CONVENTION CALLEE CALLER///////////////////

//The caller : Move args in r0-r3, more than 4 args into stack
			//Call subroutine using BL

//The callee : Move return value into R0 FINAL VALUE
			//State processpr is restored 
			//Use BX to branch exit, and LR to get the link register value, from BL

//Imane Chafi 260847716
//Narry Zendehrooh 260700556
		.text
		.global _start

_start: 
			LDR R0, =NUMBERS//R0 holds the elements of the list
			LDR R1, N//R1 is the number of elements in the list
			PUSH {R0, R1, LR}//we can push r0 and r1 into stack with Lr from the callee
			BL MAX_ARRAY//call subroutine (CALLEE)
			LDR R0, [SP, #4]//load the value of the stack pointer plus 4 into r0, so the beginning of the stack (lr + 4 is R1)
			STR R0, MAX//store space of 4 into memory for r0 (add r0 to 
			LDR LR, [SP, #8]//restore LR to stack pointer + 8 to the second max_array subroutine lr call
			ADD SP, SP, #12//remove params from stack
END: 		B END//End branch into an infinite loop!	
			

MAX_ARRAY:	
			PUSH {R0-R3}//callee - saves the values from r0 to r3 that we will use
			LDR R1, [SP, #20]//load param N from stack -> R1!!
			LDR R2, [SP, #16]//load/pop param list from stack (r0-r3)
			MOV R0, #0//Since R0 will be our max, we want it to be free.
//////////////We go straight to find max once this is done/////////////
FIND_MAX: //Simple recursive funtion to compare 2 numbers and replace r0 if r0 is smaller than second number	
			LDR R3, [R2], #4//get second value from the list
			CMP R0, R3//Compare R0 with R3 Compare first and second values
			BGE DONE//if R0 > R3, branch to DONE To set the max in r0
			MOV R0, R3//else, replace with new max
			
			
DONE:		SUBS R1, R1, #1	//lower number elements by 1 the number of elements as the counter
			BGT FIND_MAX//If the counter is not zero keep finding max 
			STR R0, [SP, #20]//Store max on stack, replacing N of R1 since the new R1 is in R1
			POP {R0-R3}//restore registers with the new values
			BX LR //Branch exit back to the value after MAX_ARRAY
			
			
NUMBERS:	.word 4,5,3,6,1,8,2 //Values to use in the list data for the greatest integer!
N: 			.word 7 //Numbers of elements in the list
MAX:		.space 4 //max memory allocation

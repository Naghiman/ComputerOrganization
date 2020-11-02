//////////////////Fibonacci.s//////////////////////////////////////

//Imane Chafi 20847716
//Nariman Zendehrooh 260700556

		  .text
          .global _start

_start:		LDR R4, =RESULT	//Memory value to get the result
			LDR R3, [R4, #4]// R4 is 0 + 4 = the index of the number we want to compute
			BL FIBONACCI // call the FIB subroutine -> goes into fib and loads link register back
            STR R0, [R4]// The result is stored in R0 as the final fib number
            B END// branch to END once Fibonacci is over
//A BL (Branch with Link) is a jump that additionally writes a return address to R14.

FIBONACCI:	STMDB SP!, {R1, R2} //Store multiple and decrement before *PUSH* R1 and R2 everytime you do fibonacci
            CMP R3, #2// compare R3 to 2 (i.e. base case)
            BGE FIB_OVER// jump to our recursion instructions if R3 is greater than or equal to 2
			MOV R0, #1// Else (If its smaller than 2, the index) : move 1 into R0
            B DONE // jump to DONE once the 1rst bse case if done so that we can call this recursively

FIB_OVER:	STMDB SP!, {R3, LR}//Load values of R3 and the link register (From first fib) in stack
            SUB R3, R3, #1 // subtract 1 from the index value
            BL FIBONACCI // call the FIB subroutine Fib(n - 1) (Branch link to fib until we get to the base case
            MOV R1, R0 // Once we're in the base case, move the return value R0 to R1
            LDMIA SP!, {R3, LR}// pop the values of R3 and LR off the stack
            STMDB SP!, {R3, LR}// save the values of R3 and LR on the stack (We're going to override them)
            SUB R3, R3, #2 // subtract 2 from R3 to call n-2 subroutine
            BL FIBONACCI // call the FIB subroutine Fib(n - 2) since r3 is r3-2
            MOV R2, R0  // move the return value R0 to R2, which will be overriden
            LDMIA SP!, {R3, LR}// pop the values of R0 and LR off the stack by convention, back into r0 and r3
            ADD R0, R1, R2  // add R1 and R2 and store the result in R0 //r0 is 2 at first, and then added by 1 and then added 3 by 2

DONE:		LDMIA SP!, {R1, R2}// pop the values of R1 and R2 off the stack since we will use them to add R1 and R2
            BX LR // return to the value of the link register (once is underneath the first fib (n-1), then fib (n-2), then at the end. 

END:		B END // infinite loop!

RESULT:     .word   0 //Memory stay in results
N:          .word   0 //i of fibonnacci from 1 (not 0)


//The Stack Pointer (SP) register is used to indicate the location of the last item put onto the stack. 
//When you PUT something ONTO the stack (PUSH onto the stack), 
//the SP is decremented before the item is placed on the stack.

//A program counter is a register in a computer processor 
//that contains the address (location) of the instruction 
//being executed at the current time. As each instruction gets
// fetched, the program counter increases its stored value by 1.

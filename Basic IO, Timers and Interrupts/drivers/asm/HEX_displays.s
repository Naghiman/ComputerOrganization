.text
		.equ HEX_DISP_1, 0xFF200020
		.equ HEX_DISP_2, 0xFF200030	
		.global HEX_clear_ASM
		.global HEX_flood_ASM
		.global HEX_write_ASM

////////////SUBROUTINE LAB2///////////////////////////////////////////
//WE'RE CHANGING THE SUBROUTINE TO WRITE FOR THE HEX DISPLAY AND CHECK THE ARGUMENTS

////////////////////THIS IS TO CLEAR THE DISPLAYS//////////////////////////
HEX_clear_ASM://we know that R0 holds a hot-one encoding of which HEX display
		PUSH {R1-R8,LR} //Pushing all the registers and lnik register to stack
		LDR R1, =HEX_DISP_1//put location of the HEX3-0 register into R0
		MOV R3, #0//Counter for hex
	
ClearFinalLOOP: //This is the loop for checking which ones need to be cleaned
		CMP R3, #6//if we looped all of them, there are 6 hex displays
		BEQ ClearingDisplay//if not equal, don't branch to the correct branch and state an error
		AND R4, R0, #1//AND 0x0000 0000 is equal to 0x0000 00001: shift if not equal
		CMP R4, #1//if equal, this is the desired HEX compare if the register that clears the values is 1, true
		BEQ ClearingDisplay//branch to hex if correct and clear the hex displays					
		ASR R0, R0, #1//if not equal, Artithmetic right shift of r0 by 1 if you didn't clear them
		ADD R3, R3, #1//increment counter to know HEX
		B ClearFinalLOOP//loop back to the same branch if it's not correct
		
ClearingDisplay: //This is the branch that actually clears the display
		CMP R3, #3//if counter is bigger than 3, we are at HEX 4 or 5
		SUBGT R3, R3, #4//we set our counter back to either 0 or 1 since we are updating the bits
		LDRGT R1, =HEX_DISP_2//we set it to the the other disp HEX
		LDR R2, [R1] //load the value of the other display to R2 so that we don't lose it
		MOV R5, #0xFFFFFF00//give it an initial value
		B ClearingAgain//Branch to the second loop for clearing so that we can push things back in the loop

ClearingAgain: //This branch is to push the second value shifted by 8 bits in the registers
		CMP R3, #0//if not equal to 0, we update it
		BEQ HEX_clear_DONE//branch to done		
		LSL R5, R5, #8//shift left by 8 bits
		ADD R5, R5, #0xFF//keep our empty space constant
		SUB R3, R3, #1//decrement our counter
		B ClearingAgain //Go again until r3 is equal to 0
/////////////////////////////////////tHIS IS TO LOAD THE FLOOD ///////////////////////////////
HEX_clear_DONE:
		AND R2, R2, R5//we and the two values
		STR R2, [R1]//we store back on the display
		POP {R1-R8, R14}
		BX LR

HEX_flood_ASM://we know that R0 holds a hot-one encoding of which HEX display
		PUSH {R1-R8,R14}
		LDR R1, =HEX_DISP_1//put location of the HEX3-0 register into R0
		MOV R3, #0//this is our counter for which hex counts
		
HEX_flood_LOOP:
		CMP R3, #6//if we looped all of them
		BEQ HEX_flood_CORRECT//branch to done if error

		AND R4, R0, #1//AND 0x0000 0000 is equal to 0x0000 00001, shift if not equal
		CMP R4, #1//if equal, this is the desired HEX
		BEQ HEX_flood_CORRECT//branch to the part that does something
							
		ASR R0, R0, #1//if not equal, then shift by 1 bit
		ADD R3, R3, #1//also increment our counter which will tell us which one is our HEX
		B HEX_flood_LOOP//loop again if not correct
		
HEX_flood_CORRECT:
		CMP R3, #3//if counter is bigger than 3, we are at HEX 4 or 5
		SUBGT R3, R3, #4//we set our counter back to either 0 or 1 since we are updating the bits
		LDRGT R1, =HEX_DISP_2//we set it to the the other disp HEX
		LDR R2, [R1]
		MOV R5, #0x000000FF	//give it an initial value
		B HEX_flood_LOOP2//to push stuff back

HEX_flood_LOOP2:
		CMP R3, #0//if not equal to 0, we update it
		BEQ HEX_flood_DONE//branch to done		
		LSL R5, R5, #8//shift left by 8 bits
		SUB R3, R3, #1//decrement our counter
		B HEX_flood_LOOP2

HEX_flood_DONE:
		ORR R2, R2, R5//we and the two values
		STR R2, [R1]//we store back on the display
		POP {R1-R8,LR}
		BX LR

//HEX_flood_ASM:					//R0 contains the hex to flood
//		LDR R1, =HEX_DISP_1
//		MOV R2, #0xFFFFFFFF		//set all as on
//		STR R2, [R1]
//		LDR R1, =HEX_DISP_2
//		STR R2, [R1]
//		BX LR

/////////////////////////this is to write the display//////////////////////////
HEX_write_ASM://we know that R0 holds a hot-one encoding of which HEX display, R1 holds the character value
		MOV R10, R0
		MOV R9, R1
		PUSH {R1-R8,LR}
		BL HEX_clear_ASM//we have to clear the display we have before doing anything on it
		POP {R1-R8,R14} //Push values and link registers
		MOV R0, R10		
		PUSH {R1-R8,LR}
		LDR R1, =HEX_DISP_1//put location of the HEX3-0 register into R0
		MOV R3, #0//this is our counter for which hex counts
		B HEX_write_0

////////////////THESE ARE ALL THE FUNCTIONS FOR WRITING FROM 0 TO 15 INSIDE OF THE hex DISPLAY//////////////
HEX_write_0:
		CMP R9, #48
		BNE HEX_write_1
		MOV R5, #0x3F
		MOV R8, R5
		B HEX_write_LOOP

HEX_write_1:	
		CMP R9, #49
		BNE HEX_write_2
		MOV R5, #0x06
		MOV R8, R5
		B HEX_write_LOOP

HEX_write_2:	
		CMP R9, #50
		BNE HEX_write_3
		MOV R5, #0x5B
		MOV R8, R5
		B HEX_write_LOOP

HEX_write_3:	
		CMP R9, #51
		BNE HEX_write_4
		MOV R5, #0x4F
		MOV R8, R5
		B HEX_write_LOOP

HEX_write_4:	
		CMP R9, #52
		BNE HEX_write_5
		MOV R5, #0x66
		MOV R8, R5
		B HEX_write_LOOP

HEX_write_5:	
		CMP R9, #53
		BNE HEX_write_6
		MOV R5, #0x6D
		MOV R8, R5
		B HEX_write_LOOP

HEX_write_6:	
		CMP R9, #54
		BNE HEX_write_7
		MOV R5, #0x7D
		MOV R8, R5
		B HEX_write_LOOP

HEX_write_7:	
		CMP R9, #55
		BNE HEX_write_8
		MOV R5, #0x07
		MOV R8, R5
		B HEX_write_LOOP

HEX_write_8:	
		CMP R9, #56
		BNE HEX_write_9
		MOV R5, #0x7F
		MOV R8, R5
		B HEX_write_LOOP

HEX_write_9:	
		CMP R9, #57
		BNE HEX_write_A
		MOV R5, #0x6F
		MOV R8, R5
		B HEX_write_LOOP

HEX_write_A:	
		CMP R9, #58
		BNE HEX_write_B
		MOV R5, #0x77
		MOV R8, R5
		B HEX_write_LOOP

HEX_write_B:	
		CMP R9, #59
		BNE HEX_write_C
		MOV R5, #0x7C
		MOV R8, R5
		B HEX_write_LOOP

HEX_write_C:	
		CMP R9, #60
		BNE HEX_write_D
		MOV R5, #0x39
		MOV R8, R5
		B HEX_write_LOOP

HEX_write_D:	
		CMP R9, #61
		BNE HEX_write_E
		MOV R5, #0x5E
		MOV R8, R5
		B HEX_write_LOOP

HEX_write_E:	
		CMP R9, #62
		BNE HEX_write_F
		MOV R5, #0x79
		MOV R8, R5
		B HEX_write_LOOP

HEX_write_F:	
		CMP R9, #63
		BNE HEX_write_OFF
		MOV R5, #0x71
		MOV R8, R5
		B HEX_write_LOOP

HEX_write_OFF:
		MOV R5, #0
		MOV R8, R5
		B HEX_write_LOOP
	
/////////////////tHIS IS THE LOOP THAT CALLS THE ISPLAYS TO PUSH BACK TO THE REGISTERS IF NO ERROR HAS BEEN SET	
HEX_write_LOOP:
		CMP R3, #6//if we looped all of them
		BEQ HEX_write_CORRECT//branch to done if error

		AND R4, R0, #1 //AND 0x0000 0000 is equal to 0x0000 00001, shift if not equal
		CMP R4, #1//if equal, this is the desired HEX
		BEQ HEX_write_CORRECT//branch to the part that does something
							
		ASR R0, R0, #1//if not equal, then shift by 1 bit
		ADD R3, R3, #1//also increment our counter which will tell us which one is our HEX
		B HEX_write_LOOP//loop again if not correct
		
HEX_write_CORRECT:
		CMP R3, #3//if counter is bigger than 3, we are at HEX 4 or 5
		SUBGT R3, R3, #4//we set our counter back to either 0 or 1 since we are updating the bits
		LDRGT R1, =HEX_DISP_2//we set it to the the other disp HEX
		LDR R2, [R1]
		MOV R5, R8//give R8 an initial value, which is from our switch case
		B HEX_write_LOOP2//to push stuff back

HEX_write_LOOP2:
		CMP R3, #0//if not equal to 0, we update it
		BEQ HEX_write_DONE//branch to done		
		LSL R5, R5, #8//shift left by 8 bits, 
		SUB R3, R3, #1//decrement our counter
		B HEX_write_LOOP2

////////////////////////HEX DONE VALUE/////////////////////////////
HEX_write_DONE:
		ORR R2, R2, R5//we and the two values bitwise OR operations (bitwise OR operations)
		STR R2, [R1]//we store back on the display
		POP {R1-R8,LR} //pOP THE VALUES OF THE REGISTERS TO USE THEM AND ADD ON THE 
		BX LR
		.end

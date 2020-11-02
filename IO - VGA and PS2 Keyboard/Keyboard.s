.equ VGA_PIXEL_BUF_BASE, 0xC8000000 //Top-left corner as (0,0)
.equ VGA_CHAR_BUF_BASE, 0xC9000000
.equ PS_2_BASE, 0xFF200100

.global _start
_start:
	MOV R4, #0	//Reserved for X
	MOV R5, #0	//Reserved for Y
	BL VGA_clear_pixelbuff_ASM
	B while_loop
while_loop:
	LDR R3, =CHAR	//Valid address to write on
	BL  read_PS2_data_ASM
	CMP R0, #0	//RVALID is 0 then go back
	BEQ while_loop
	LDR R3, =CHAR	//load address into R3
	LDR R3, [R3]	//Load the overwritten byte to display on buffer
	MOV R0, R4		//Restore value of R0 that revised before by reserved X
	MOV R1, R5		//Restore value of R1 that revised before by reserved Y
	BL VGA_write_byte_ASM
	ADD R4, R4, #3	// Reserved X coordinate go to the next available space
	CMP R4, #80		//Check if reached the end of screen
	MOVGE R4, #0	//If it reached go back to the beginning of the line
	ADDGE R5, R5, #1	//Go one row down
	CMP R5, #60	//Check if we reached the last row
	BLEQ VGA_clear_charbuff_ASM
	MOVEQ R5, #0	//Go back to the first row
	B while_loop


//Screen Resolution 320x240 pixels
VGA_clear_pixelbuff_ASM: //clears(set to 0) all the valid memory locations in the pixel buffer
	PUSH {R7,R8}	//save the system state
	MOV R2, #0	//Clear the pixel with R2
	LDR R3, =VGA_PIXEL_BUF_BASE	//Starting memory address of pixel buffer

	MOV R0, #0	//X
PIXEL_LOOPX:
	MOV R1, #0	//Y
	ADD R7, R3, R0, LSL #1	//address + 00000000 000000001 0 ( + (1,0) )
PIXEL_LOOPY:
	ADD R8, R7, R1, LSL #10 //address + 00000001 000000000 0 ( + (0,1) )
	
	STRH R2, [R8]	//store the colour pixel which is 16-bit( half-word)
	
	ADD R1, R1, #1
	CMP R1, #240	//Most Buttom
	BLT PIXEL_LOOPY
	
	ADD R0, R0, #1
	CMP R0, #320	//Most Right
	BLT PIXEL_LOOPX

	POP {R7,R8}	//Restore and return
	BX LR
	
//Screen resolution 80x60 characters	
VGA_clear_charbuff_ASM: //clears(set to 0) all the valid memory locations in the char buffer
	PUSH {R7,R8}	
	MOV R2, #0 //Clear the pixel with R2
	LDR R3, =VGA_CHAR_BUF_BASE	//Starting memory address of char buffer

	MOV R0, #0	//X
CHAR_LOOPX:
	MOV R1, #0	//Y
	ADD R7, R3, R0, LSL #1	//character 1,0 has the address + 000000 0000001
CHAR_LOOPY:
	ADD R8, R7, R1, LSL #7	//character 0,1 has the address + 000001 0000000
	
	STRH R2, [R8]
	
	ADD R1, R1, #1
	CMP R1, #60		//Most buttom
	BLT CHAR_LOOPY
	
	ADD R0, R0, #1
	CMP R0, #80		//Most right
	BLT CHAR_LOOPX

	POP {R7,R8}
	BX LR
	
VGA_write_byte_ASM:
	PUSH {R4-R9}	//Store the state of system
	LDR R3 ,=VGA_CHAR_BUF_BASE
	MOV R7, #0
	MOV R8, #0
	MOV R9, #0
	ADD R3, R3, R0, LSL #1	//Pushes X into the byte buffer address(address + 000000 0000001)
	ADD R3, R3, R1, LSL #7	//pushes Y into the byte buffer address(address + 000001 0000000)
	AND R7, R2, #0xF0  //240 (11110000) clears first byte of R2 and store it in R7 xxxx0000
	AND R8, R2, #0x0F //15 (00001111)	clears second byte of R2 and store it in R8 0000yyyy
	LSR R7, R7, #4	// Now R7 is like 0000xxxx
	LDR R4, =HEX_ASCII
	ADD R9, R4, R8	//R9 = HEX + 0000yyyy (HEX starts from 110000)
	ADD R4, R4, R7	//R4 = HEX + 0000xxxx
	LDRB R4, [R4]	//Load content of one byte in R4
	STRB R4, [R3]	//Store it in R3 (First byte)
	LDRB R9, [R9]	//Load content of one byte in R9
	STRB R9, [R3, #1] //Store it in R3 (second byte). 1 offset is for Space between each byte
	POP {R4-R9}
	BX LR
	
	
read_PS2_data_ASM:
	MOV R3, R0
	PUSH {R4-R12} //saves the state of the system
	LDR R1, =PS_2_BASE //load the ps/2 data register address into R1
	LDRB R4, [R1]
	AND R2, R4, #0x80 //10000000 keeps the most significant bit (RVALID bit) of ps/2 value 
	CMP R2, #0	//check if RVALID is 0
	BEQ INVALID
	AND R6, R4, #0xFF	//AND data with 11111111 to get last 8 bits
	STRB R6, [R3] //if is 1, read data and place it in R3 address
	MOV R0, #1    //return 1
	POP {R4-R12}
	BX LR

INVALID:
	MOV R0, #0	//return 0
	POP {R4-R12}	//restore system state
	BX LR
	
CHAR:			.word 0				//memory assigned for character location
HEX_ASCII:
	.byte 0x30, 0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37, 0x38, 0x39, 0x41, 0x42, 0x43, 0x44, 0x45, 0x46
	
	
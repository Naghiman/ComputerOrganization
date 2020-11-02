.equ PB_BASE, 0xFF200050
.equ VGA_PIXEL_BUF_BASE, 0xC8000000 //Top-left corner as (0,0)
.equ VGA_CHAR_BUF_BASE, 0xC9000000

.global _start
_start:
B while_loop
while_loop:
    MOV R0, #0
    BL read_PB_data_ASM //Read the input of push button
    AND R1, R0, #1
    CMP R1, #1	// Push button 0(2^0) is used to write characters on the buffer
    BLEQ test_char
    AND R1, R0, #2
    CMP R0, #2	// Push button 1 (2^1) is used to write bytes on the buffer 
    BLEQ test_byte
    AND R1, R0, #4
    CMP R0, #4	//Push button 2 (2^2) is used to draw pixels on the buffer
    BLEQ test_pixel
    AND R1, R0, #8
    CMP R0, #8	//Push button 3 (2^3) is used to clear both character and pixel inputs
    BLEQ clear_screen
	B while_loop

clear_screen:
	PUSH {LR}
	BL VGA_clear_charbuff_ASM
	BL VGA_clear_pixelbuff_ASM
	POP {LR}
	BX LR

//Test Character buffer subroutine
test_char:
    PUSH {R0-R10,LR}	//Saved the system state
    MOV R0, #0	//X
    MOV R1, #-1	//Y
    MOV R2, #0	//C
//for(int y = 0 ; y < 60 ; y++)
TEST_CHAR_LOOPY:
    ADD R1, R1,#1
    CMP R1, #60
    BEQ TEST_CHAR_END
    MOV R0, #0
//for(int x = 0 ; x < 80 ; x++)
TEST_CHAR_LOOPX:
    CMP R0, #80
    BEQ TEST_CHAR_LOOPY
    BL VGA_write_char_ASM
    ADD R2,R2,#1
    ADD R0,R0,#1
    B TEST_CHAR_LOOPX
	
TEST_CHAR_END:
    POP {R0-R10,LR}     //Restore the system state and return
    BX LR
	
	
//Test byte buffer subroutine
test_byte:
    PUSH {R0-R10,LR}	//saved the system state
    MOV R0, #0	//X
    MOV R1, #-1	//Y
    MOV R2, #0	//C
//for(int y = 0 ; y < 60 ; y++)
TEST_BYTE_LOOPY:
    ADD R1, R1,#1
    CMP R1, #60
    BEQ TEST_BYTE_END
    MOV R0, #0
//for(int x = 0 ; x < 80 ; x+=3)
TEST_BYTE_LOOPX:
    CMP R0, #80
    BEQ TEST_BYTE_LOOPY
    BL VGA_write_byte_ASM
    ADD R2,R2,#1
    ADD R0,R0,#3
    B TEST_BYTE_LOOPX
	
TEST_BYTE_END:
    POP {R0-R10,LR}     //Restore the system state and return
    BX LR

	
//Test pixel buffer subroutine
test_pixel:
    PUSH {R0-R10,LR}
    MOV R0, #0	//X
    MOV R1, #-1	//Y
    MOV R2, #0	//Colour
//for(int y = 0 ; y < 240 ; y++)
TEST_PIXEL_LOOPY:
    ADD R1, R1,#1
    CMP R1, #240
    BEQ TEST_PIXEL_END
    MOV R0, #0
//for(int x = 0 ; x < 320 ; x++)
TEST_PIXEL_LOOPX:
    CMP R0, #320
    BEQ TEST_PIXEL_LOOPY
    BL VGA_draw_point_ASM
    ADD R2,R2,#1
    ADD R0,R0,#1
    B TEST_PIXEL_LOOPX
	
TEST_PIXEL_END:
    POP {R0-R10,LR}     //Restore and return
    BX LR

		
read_PB_data_ASM:
	LDR R1, =PB_BASE //ADD THE CODE FOR THE PUSHBUTTON BASE VALUE LOAD INTO R1
	LDR R0, [R1]
	AND R0, R0, #0xF //get rid of all bits except first 4
	BX LR
	
read_PB_data_is_pressed_ASM:
            LDR     R2, =PB_BASE//Add the pb base address in corresponding register
            LDR     R1, [R2]      
            AND     R0, R0, R1    
            BX      LR
			
read_PB_edgecap_ASM:
            LDR     R1, =PB_BASE//Add the pb base address in corresponding register  
            LDR     R0, [R1, #12]    
            BX      LR
			
PB_edgecap_is_pressed_ASM:
            LDR     R2, =PB_BASE//Add the pb base address in corresponding register    
            LDR     R1, [R2, #12]   
            AND     R0, R0, R1      
            BX      LR
			
PB_clear_edgecap_ASM:
            LDR     R1, =PB_BASE//Add the pb base address in corresponding register  
            STR     R0, [R1, #12]   
            BX      LR
			
enable_PB_INT_ASM:
            LDR     R2, =PB_BASE//Add the pb base address in corresponding register 
            LDR     R1, [R2, #8] 
            ORR     R1, R1, R0    ///BITWISE ORR
            STR     R1, [R2, #8] //STORE FINAL VALUE OF R2 WITH OFFSET 8 BITS
            BX      LR
disable_PB_INT_ASM:
            LDR     R2, =PB_BASE//Add the pb base address in corresponding register
            LDR     R1, [R2, #8]  
            BIC     R1, R1, R0 
            STR     R1, [R2, #8]   
            BX      LR


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

//Screen Resolution 320x240 pixels	
VGA_draw_point_ASM:
	LDR R3, =VGA_PIXEL_BUF_BASE //overwrite R3 by base address
	ADD R3, R3, R0, LSL #1 // Pushes X into the pixel buffer address( address + 00000000 000000001 0 ( + (1,0) ))
	ADD R3, R3, R1, LSL #10 //pushes Y into the pixel buffer address( address + 00000001 000000000 0 ( + (0,1) )) 
	STRH R2, [R3] //store the colour pixel which is 16-bit( half-word)
	BX LR
	

//Screen resolution 80x60 characters
VGA_write_char_ASM:
	LDR R3 ,=VGA_CHAR_BUF_BASE //Character base address
	ADD R3, R3, R0, LSL #1	//Pushes X into the char buffer address(address + 000000 0000001)
	ADD R3, R3, R1, LSL #7 //pushes Y into the char buffer address(address + 000001 0000000)
	STRB R2, [R3]	//store the byte
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
	
HEX_ASCII:
	.byte 0x30, 0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37, 0x38, 0x39, 0x41, 0x42, 0x43, 0x44, 0x45, 0x46
				
	.text //Variable declarations
	.equ PB_BASE, 0xFF200050
	.global read_PB_data_ASM
	.global PB_data_is_pressed_ASM
	.global read_PB_edgecap_ASM
	.global PB_edgecap_is_pressed_ASM
	.global PB_clear_edgecap_ASM
	.global enable_PB_INT_ASM
	.global disable_PB_INT_ASM
///////////////////////////////////////SECOND PART OF THE BASIC.IO CODE, HEX DISPLAYS WITH PUSHBUTTONS//////////////////////////////
read_PB_data_ASM:
	LDR R1, =PB_BASE //ADD THE CODE FOR THE PUSHBUTTON BASE VALUE LOAD INTO R1
	LDR R0, [R1]
	AND R0, R0, #0xF //get rid of all bits except first 4
	BX LR
	//////////////////Reading the data when pressed and exiting branch with link register
read_PB_data_is_pressed_ASM:
            LDR     R2, =PB_BASE//Add the pb base address in corresponding register
            LDR     R1, [R2]      
            AND     R0, R0, R1    
            BX      LR
read_PB_edgecap_ASM:
            LDR     R1, =PB_BASE//Add the pb base address in corresponding register  
            LDR     R0, [R1, #12]    
            BX      LR
////////////////////////////////////update the values in the register when edgecap is pressed
PB_edgecap_is_pressed_ASM:
            LDR     R2, =PB_BASE//Add the pb base address in corresponding register    
            LDR     R1, [R2, #12]   
            AND     R0, R0, R1      
            BX      LR
PB_clear_edgecap_ASM: /////////////////Clear the values if the pushbutton clear is pressed
            LDR     R1, =PB_BASE//Add the pb base address in corresponding register  
            STR     R0, [R1, #12]   
            BX      LR
/////////////////////////////////enable the push button int by having an 
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

	.end

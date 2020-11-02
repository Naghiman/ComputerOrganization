	.text
	
	.global A9_PRIV_TIM_ISR //bRANCHES FOR LINK REGISTER KEEPS
	.global HPS_GPIO1_ISR
	.global HPS_TIM0_ISR
	.global HPS_TIM1_ISR
	.global HPS_TIM2_ISR
	.global HPS_TIM3_ISR
	.global FPGA_INTERVAL_TIM_ISR //BRANCHES FOR FPGA LINKS
	.global FPGA_PB_KEYS_ISR
	.global FPGA_Audio_ISR
	.global FPGA_PS2_ISR
	.global FPGA_JTAG_ISR
	.global FPGA_IrDA_ISR
	.global FPGA_JP1_ISR
	.global FPGA_JP2_ISR
	.global FPGA_PS2_DUAL_ISR
	.global hps_tim0_int_flag //FLAG FOR THE TIMER HPS
	.global pb_int_flag //FLAG FOR THE PUDH BUTTON EVENTS

//bRANCHES FOR ALL THE branches to the appropriate subroutine in the ISRs.s file
hps_tim0_int_flag://This is the interrupt values, WHICH WILL BE USED TO SEND TO THE 
	.word 0x0///Asynchronous events such as this, if assigned an interrupt, can free the processors time and use it
//only when required
pb_int_flag: //PUSHBUTTON FLAG
	.word 0x0
A9_PRIV_TIM_ISR://THIS IS THE TIMER SHIFT RIGHT BRANCH (JUST TO KEEP THE LINK REGISTER)
	BX LR	
HPS_GPIO1_ISR:
	BX LR	
HPS_TIM0_ISR: //This is the interrupt for the values of the hps
	PUSH {LR}//Push LR to stack
	MOV R0, #0x1
	BL HPS_TIM_clear_INT_ASM//Clear timE
	LDR R0, =hps_tim0_int_flag
	MOV R1, #1
	STR R1, [R0]//Set flag to 1
	POP {LR}//Pop LR from stack
	BX LR
	//COUPLE OF BRANCHES JUST TO KEEP THE LINK REGISTERS.
HPS_TIM1_ISR:
	BX LR
	
HPS_TIM2_ISR:
	BX LR
	
HPS_TIM3_ISR:
	BX LR
	
FPGA_INTERVAL_TIM_ISR:
	BX LR
	//BRANCH TO KEEP THE PUSH BUTTONS STATUS IN STACK AND READ WHICH PUSHBUTTON WAS PRESSED
FPGA_PB_KEYS_ISR:
	PUSH {LR}//Push LR to stack
	BL read_PB_edgecap_ASM//Get pushbutton that was pressed
	LDR R1, =pb_int_flag
	STR R0, [R1]//Set flag to value of pb
	BL PB_clear_edgecap_ASM	//Clear edgecap to reset interrupt
	POP {LR}//Pop LR from stack
	BX LR
	
FPGA_Audio_ISR:
	BX LR
	
FPGA_PS2_ISR:
	BX LR
	
FPGA_JTAG_ISR:
	BX LR
	
FPGA_IrDA_ISR:
	BX LR
	
FPGA_JP1_ISR:
	BX LR
	
FPGA_JP2_ISR:
	BX LR
	
FPGA_PS2_DUAL_ISR:
	BX LR
	
	.end

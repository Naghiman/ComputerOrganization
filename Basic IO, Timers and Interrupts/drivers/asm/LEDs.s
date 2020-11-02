	.text
	.equ LED_BASE, 0xFF200000
	.global read_LEDs_ASM
	.global write_LEDs_ASM
/////////////////////////////////SIMPLE CODE TO READ AND WRITE THE LED LIGHTS AND SLIDER SWITCHES FROM LAB DESCRIPTION///////////////
read_LEDs_ASM:
	LDR R1, = LED_BASE
	LDR R0, [R1]
	BX LR

	//.end

write_LEDs_ASM:
	LDR R1, = LED_BASE
	STR R0, [R1]	//store
	BX LR

	.end

#include <stdio.h>

#include "./drivers/inc/LEDs.h"
#include "./drivers/inc/slider_switches.h"

////////////////////////////CODE FOR WRITING LED LIGHTS ON SLIDER SWITCHES GIVEN IN LAB DESCRIPTION/////////////////////////////
int main() {
	while(1) {
		write_LEDs_ASM(read_slider_switches_ASM());
	}
	return 0;
}	

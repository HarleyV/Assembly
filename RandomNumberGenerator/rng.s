//Random Number Generator
//Written by Harley Vasquez

.equ LOW, 	0
.equ HIGH,  	1
.equ INPUT, 	0
.equ OUTPUT,	1

//Components (LEDs)
.equ LED_WHITE, 4
.equ LED_RED,	0
.equ LED_GREEN, 5
.equ LED_BLUE,	2
.equ LED_YELLOW,3

//Components (Buttons)
.equ BUTTON_EXIT, 27	//This button will exit the program
.equ BUTTON_GEN,  6	//This button will generate a random number

.section .text
.global main
//Execution Begins Here//
main:
	push {lr}
	bl wiringPiSetup

	bl component_setup
	
	ldr r0, =start_message
	bl printf

	bl main_loop
	
	ldr r0, =end_message
	bl printf

	mov r0, #0
	pop {pc}
//Execution Ends Here//



//Start of Main Loop Function//
main_loop:
	push {lr}

loop:	
	mov r0, #BUTTON_EXIT
	bl digitalRead
	
	//If the exit button is pressed, exit the loop
	cmp r0, #HIGH
	beq main_loop_exit
	
	//Delay to prevent button bounce
	ldr r0, =#250
	bl delay
	
	mov r0, #BUTTON_GEN
	bl digitalRead
	
	//If the generation button is pressed, generate a random number
	cmp r0, #HIGH
	beq _random	

	bal loop
	
main_loop_exit:
	pop {pc}
//End of Main Loop Function//



//Start of Randoming Function//
_random:
	push {lr}
	
	//Load data into registers
	ldr r3, =multiplier
	ldr r4, =increment
	ldr r6, =prev
	ldr r7, =max
	
	ldr r3, [r3]
	ldr r4, [r4]
	ldr r6, [r6]
	
	//Use the LCG Algorithm to generate a random number
	mul r1, r3, r6
	add r1, r1, r4
	
	ldr r2, [r7]
	bl mod
	
	//Store the onmodded number in prev to be used as the next seed
	ldr r6, =prev
	str r0, [r6]	
	
	and r0, r0, #127
	
	//Mod the generated number by 5	
	mov r1, r0
	mov r2, #5
	bl mod 	
	
	//Store the number
	ldr r5, =number
	str r0, [r5]
	
	//Print out the generated number
	ldr r0, =number_output
	ldr r1, [r5]
	bl printf
	
	//Light the corresponding LED
	bl light_led

	pop {pc}
//End of Randoming Function//



//Start of Mod Function//
mod:
	push {lr}
	
	mov r4, r2
	cmp r4, r1, lsl #1
	
div1:
	movls r4, r4, lsl #1
	cmp r4, r1, lsl #1
	bls div1
	mov r3, #0

div2:
	cmp r1, r4
	subcs r1, r1, r4
	adc r3, r3, r3

	mov r4, r4, lsr #1
	cmp r4, r2
	bhs div2

	mov r0, r1
	pop {pc}
//End of Mod Function//



//Start of Lighting LED Function//
light_led:
	push {lr}
	
	//Load the random number into register 1
	ldr r1, =number
	ldr r1, [r1]
	
	//Light an LED based on the random number
	cmp r1, #0
	ble red
	
	cmp r1, #1
	ble green	
	
	cmp r1, #2
	ble blue

	cmp r1, #3
	ble white
	
	cmp r1, #4
	ble yellow

red:
	mov r0, #LED_RED
	mov r1, #HIGH
	bl digitalWrite

	ldr r0, =#500
	bl delay

	mov r0, #LED_RED
	mov r1, #LOW
	bl digitalWrite

	bal light_led_exit
	 
green:
	mov r0, #LED_GREEN
	mov r1, #HIGH
	bl digitalWrite

	ldr r0, =#500
	bl delay

	mov r0, #LED_GREEN
	mov r1, #LOW
	bl digitalWrite

	bal light_led_exit

blue:
	mov r0, #LED_BLUE
	mov r1, #HIGH
	bl digitalWrite

	ldr r0, =#500
	bl delay

	mov r0, #LED_BLUE
	mov r1, #LOW
	bl digitalWrite

	bal light_led_exit

white:
	mov r0, #LED_WHITE
	mov r1, #HIGH
	bl digitalWrite

	ldr r0, =#500
	bl delay

	mov r0, #LED_WHITE
	mov r1, #LOW
	bl digitalWrite

	bal light_led_exit

yellow:
	mov r0, #LED_YELLOW
	mov r1, #HIGH
	bl digitalWrite

	ldr r0, =#500
	bl delay

	mov r0, #LED_YELLOW
	mov r1, #LOW
	bl digitalWrite

	bal light_led_exit

light_led_exit:
	pop {pc}
//End of Lighting LED Function//



//Start of Component Setup Function//
component_setup:
	push {lr}
	
	mov r0, #LED_RED
	mov r1, #OUTPUT
	bl pinMode

	mov r0, #LED_GREEN
	mov r1, #OUTPUT
	bl pinMode

	mov r0, #LED_BLUE
	mov r1, #OUTPUT
	bl pinMode

	mov r0, #LED_WHITE
	mov r1, #OUTPUT
	bl pinMode

	mov r0, #LED_YELLOW
	mov r1, #OUTPUT
	bl pinMode

	mov r0, #BUTTON_EXIT
	mov r1, #INPUT
	bl pinMode

	mov r0, #BUTTON_GEN
	mov r1, #INPUT
	bl pinMode
	
	pop {pc}
//End of Component Setup Function//



//Data
.section .data

multiplier: 	.word 1103515245U
increment: 	.word 12345U
max: 		.word 0x7FFFFFFFU
prev:		.word 1
number:		.word 0			

//Output messages
number_output:		.asciz "Generated Number: %u\n"
start_message:	.asciz "Press the green button to generate a number\nPress the the red button to exit the program\n\n"
end_message:	.asciz "\nYou exited the program\n"

.section .data

prompt: .asciz "Enter three integer numbers: "

input: .asciz "%d %d %d"

num1: .word 0
num2: .word 0
num3: .word 0
sum: .word 2

response1: .asciz "You entered %d, %d, %d, "
response2: .asciz "and the sum is %d \n"

.section .text
.global main
main: 
	push {lr}
	
	ldr r0, =prompt
 	bl printf
	
	ldr r0, =input
	ldr r1, =num1
	ldr r2, =num2
	ldr r3, =num3
	bl scanf
next:	
	ldr r0, =response1
	ldr r1, =num1
	ldr r1, [r1]
	ldr r2, =num2
	ldr r2, [r2]
	ldr r3, =num3
	ldr r3, [r3]
	bl printf

	ldr r0, =num1
	ldr r1, =num2
	ldr r2, =num3
	ldr r3, =sum
	
	ldr r0, [r0]
	ldr r1, [r1]
	ldr r2, [r2]

	ADD r4, r0, r1
	ADD r4, r4, r2
	STR r4, [r3]

	ldr r0, =response2
	ldr r1, =sum
	ldr r1, [r1]
	bl printf

	mov r0, #0
	pop {pc}
	

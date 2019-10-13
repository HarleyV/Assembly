 .section .data

prompt: .asciz "Enter a positive integer and I'll add it to a running total (negative values entered to stop): "

input: .asciz "%d"

response: .asciz "The sum is %d and average is %d\n"

num: .word 0

sum: .word 0

count: .word 0

average: .word 0

.section .text
.global main
main:
	push {lr}

loop:
	ldr r0, =prompt
	bl printf

	ldr r0, =input
	ldr r1, =num
	bl scanf

	ldr r0, =num
	ldr r0, [r0]
	cmp r0, #0
	blt get_average

	ldr r1, =num
	ldr r1, [r1]
	ldr r2, =sum
	ldr r2, [r2]
	
	add r0, r1, r2

	ldr r3, =sum
	str r0, [r3]

	ldr r1, =count
	ldr r1, [r1]

	ADD r2, r1, #1
	
	ldr r3, =count
	str r2, [r3]

	bal loop

get_average:

	ldr r5, =sum
	ldr r4, =count

	ldr r0, [r5]
	ldr r1, =average
	ldr r1, [r1]
	mov r2, #1
	ldr r3, [r4]

loop2:
	movs r3, r3, lsl#1
	movs r2, r2, lsl#1
	
	cmp r0, r3
	bgt loop2

	movs r3, r3, lsr#1
	movs r2, r2, lsr#1

subtract:
	cmp r0, r3
	blt output

	add r1, r1, r2
	sub r0, r0, r3

shift_right:
	cmp r2, #1
	beq subtract

	cmp r3, r0
	ble subtract;

	movs r2, r2, lsr#1
	movs r3, r3, lsr#1
	
	bal shift_right
	bal subtract

output:
	ldr r0, =average
	str r1, [r0]
 
	ldr r0, =response
	ldr r1, =sum
	ldr r1, [r1]
	ldr r2, =average
	ldr r2, [r2]	
	bl printf

	mov r0, #0	
	pop {pc}

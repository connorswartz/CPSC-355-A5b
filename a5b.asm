// File: a5b.asm
// Author: Connor Swartz
// Date: March 28, 2022
//
// Description:
// An ARMv8 assembly language program to accept as command line arguments two strings representing a date in the format mm dd. 
// Program will print the name of month, the day (with the appropriate suffix), and the season for this date.
//

define(month, w28)
define(day, w27)
define(argc_r, w26)
define(argv_r, x25)
define(arg1, w24)
define(arg2, w23)
define(base, x22)

		.data									// .data section (read and write data) initialized by programmer
jan:		.string "Januray"							// Store string in memory with label 
feb:		.string "February"							// Store string in memory with label
mar:		.string "March"								// Store string in memory with label
apr:		.string "April"								// Store string in memory with label
may:		.string "May"								// Store string in memory with label
jun:		.string "June"								// Store string in memory with label 
jul:		.string "July"								// Store string in memory with label 
aug:		.string "August"							// Store string in memory with label 
sep:		.string "September"							// Store string in memory with label 
oct:		.string "October"							// Store string in memory with label 
nov:		.string "November"							// Store string in memory with label 
dec:		.string "December"							// Store string in memory with label 

win:		.string "Winter"							// Store string in memory with label 
spr:		.string "Spring"							// Store string in memory with label 
sum:		.string "Summer"							// Store string in memory with label 
fal:		.string "Fall"								// Store string in memory with label 

st:		.string "st"								// Store string in memory with label 
nd:		.string "nd"								// Store string in memory with label 
rd:		.string "rd"								// Store string in memory with label 
th:		.string "th"								// Store string in memory with label 

result:		.string "%s %d%s is %s\n"						// Store string in memory with label 
usage:		.string "usage: a5b mm dd\n"						// Store string in memory with label 


		.balign 8								// 8 byte alignment
monthNames:	.dword jan, feb, mar, apr, may, jun, jul, aug, sep, oct, nov, dec	// Array of 12 double words

seasNames:	.dword win, spr, sum, fal						// Array of 4 double words
// Array of 31 double words
suffixNames:	.dword st, nd, rd, th, th, th, th, th, th, th, th, th, th, th, th, th, th, th, th, th, st, nd, rd, th, th, th, th, th, th, th, st


		.text									// .text section (read data)
		.balign 4								// 4 byte alignment

		.global main								// Ensure "main" is visible to linker

main:
		stp	x29, x30, [sp, -16]!						// Save frame pointer (FP) and link register (LR) to the stack
		mov	x29, sp								// Set FP to the top of the stack

		mov	argc_r, w0							// Set argc_r to w0 (number of arguments)
		mov	argv_r, x1							// Set argv_r to w1 (array of arguments)
		mov	arg1, 1								// Set arg1 to 1
		mov	arg2, 2								// Set arg2 to 2

		cmp	argc_r, 3							// Compare argc_r to 3
		b.ne	error								// Branch to error if argc_r != 3


setMonth:
		adrp	base, monthNames 						// Load monthNames into base
		add	base, base, :lo12:monthNames					// Load monthNames into base

		ldr	x0, [argv_r, arg1, SXTW 3]					// Load first input value in argv_r into x0
		bl	atoi								// Convert x0 ASCII string to integer (stored in w0)

		cmp	w0, 1								// Compare w0 to 1
		b.lt	error								// Branch to error if w0 < 1

		cmp	w0, 12								// Compare w0 to 12
		b.gt	error								// Branch to error if w0 > 12

		sub	w1, w0, 1							// Set w1 to proper month integer for monthNames array

		ldr	x21, [base, w1, SXTW 3]						// Set x21 to proper month string

		add	month, w1, 1							// Set month to int month that was originally input


setDay:
		ldr	x0, [argv_r, arg2, SXTW 3]					// Load second input value into x0
		bl	atoi								// Convert x0 ASCII string into integer (stored in w0)

		cmp	w0, 1								// Compare w0 to 1
		b.lt	error								// Branch to error if w0 < 1

		cmp	w0, 31								// Compare w0 to 31
		b.gt	error								// Branch to error if w0 > 31
	
		mov	day, w0								// Set day to proper day (1, 2, ... 30, 31)

		adrp	base, seasNames							// Load seasNames into base
		add	base, base, :lo12:seasNames					// Load seasNames into base

		b	checkDay							// Branch to checkDay


setSuffix:
		adrp	base, suffixNames						// Load suffixNames into base
		add	base, base, :lo12:suffixNames					// Load suffixNames into base

		sub	w7, day, 1							// Subtract 1 from day and store in w7

		ldr	x3, [base, w7, SXTW 3]						// Set x3 to proper suffix (st, nd, rd, th)


printDate:
		ldr	x0, =result							// Load result into x0
		mov	x1, x21								// Set x1 to x21
		mov	w2, day								// Set w2 to day
		mov	x4, x19								// Set x4 to x19
		bl	printf								// Print

		b	done								// Branch to done


checkDay:
		cmp	month, 1							// Compare month to 1
		b.eq	setWin								// Branch to setWin if month == 1

		cmp	month, 2							// Compare month to 2
		b.eq	setWin								// Branch to setWin if month == 2

		cmp	month, 4							// Compare month to 4
		b.eq	setSpr								// Branch to setSpr if month == 4

		cmp	month, 5							// Compare month to 5 
		b.eq	setSpr								// Branch to setSpr if month == 5

		cmp	month, 7							// Compare month to 7
		b.eq	setSum								// Branch to setSum if month == 7

		cmp	month, 8							// Compare month to 8
		b.eq	setSum								// Branch to setSum if month == 8

		cmp	month, 10							// Compare month to 10
		b.eq	setFal								// Branch to setFal if month == 10

		cmp	month, 11							// Compare month to 11
		b.eq	setFal								// Branch to setFal if month == 11


		cmp	day, 20								// Compare day to 20
		b.gt	checkGreater							// Branch to checkGreater if day > 20

checkLess:
		cmp	month, 3							// Compare month to 3
		b.eq	setWin								// Branch to setWin if month == 3

		cmp	month, 6							// Compare month to 6
		b.eq	setSpr								// Branch to setSpr if month == 6

		cmp	month, 9							// Compare month to 9
		b.eq	setSum								// Branch to setSum if month == 9

		b	setFal								// Branch to setFal

checkGreater:
		cmp	month, 3							// Compare month to 3
		b.eq	setSpr								// Branch to setSpr if month == 3

		cmp	month, 6							// Compare month to 6
		b.eq	setSum								// Branch to setSum if month == 6

		cmp	month, 9							// Compare month to 9
		b.eq	setFal								// Branch to setFal if month == 9

		b	setWin								// Branch to setWin

setWin:
		mov	w4, 0								// Set w4 to 0
		ldr	x19, [base, w4, SXTW 3]						// Load base[w4] into x19
		b	setSuffix							// Branch to setSuffix

setSpr:
		mov	w4, 1								// Set w4 to 1
		ldr	x19, [base, w4, SXTW 3]						// Load base[w4] into x19
		b	setSuffix							// Branch to setSuffix

setSum:
		mov	w4, 2								// Set w4 to 2
		ldr	x19, [base, w4, SXTW 3]						// Load base[w4] into x19
		b	setSuffix							// Branch to setSuffix

setFal:
		mov	w4, 3								// Set w4 to 3
		ldr	x19, [base, w4, SXTW 3]						// Load base[w4] into x19
		b	setSuffix							// Branch to setSuffix

error:
		ldr	x0, =usage							// Load usage into x0
		bl	printf								// Print

done:
		ldp	x29, x30, [sp], 16						// Clean lines and restore the stack
		mov	x0, 0								// Set return code to 0 (no errors)
		ret									// Return to OS

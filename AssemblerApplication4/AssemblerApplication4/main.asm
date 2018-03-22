;
; AssemblerApplication4.asm
;
; Created: 3/22/2018 4:19:49 PM
; Author : Daniella
;


; Replace with your application code
;ex1
	;LDI		r16, 0b0100_0010		;load value into register r16
	;nop								;does nothing, but provides a place to put a breakpoint
;
;
;ex3: write a program that puts the decimal value 42 into register R16
	
	LDI		r16, 42				;load the decimal value 42 into register r16
	LDI		r17, 0x21			;load hexadecimal value 33(=21[hexa]) into register r17
	LDI		r18, 0b10110010		;load binary value 10110010 into register r18
	nop
	
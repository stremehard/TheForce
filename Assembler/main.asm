;
; Assembler.asm
;
; Created: 15/03/2018 09:50:41
; Author : Daniela Crucerescu ,Hristo Getov, Nikolay Nikolov

; Version 1 : Not working as expected 
; Idea was to create level by level the same code just to make sure we get the basic idea of assembler
; However we found numers bugs or feautures ;) Therefore we change our strategy

; Version 2 : Modified to use stack and limit the amount of code
; Works well
; Improved the code overall design by deleting around 800 lines of code

; Version 3.1 : After final round added ... Flashesh LED's on / off

; TODO for Version 3 : add to level 30
; TODO for Version 3 : change delay time based on levels and player Input 
; TODO for Version 3 : Make loop function for adding levels to the stack so its nicer and shorter
; TODO for Version 4 : Make randomizer for the game not using the predefine values
 
																			;Binary patterns for levels
																			;Randomly genereted using Java  { As random as possible }
																			;Beggins from level 1
.equ bitPattern_level_1  = 0b01010011
.equ bitPattern_level_2  = 0b00100111
.equ bitPattern_level_3  = 0b01001101
.equ bitPattern_level_4  = 0b00011101
.equ bitPattern_level_5  = 0b11010011
.equ bitPattern_level_6  = 0b01010001
.equ bitPattern_level_7  = 0b11101101
.equ bitPattern_level_8  = 0b10110100
.equ bitPattern_level_9  = 0b00101111
.equ bitPattern_level_10 = 0b01001011
.equ bitPattern_level_11 = 0b11100111
.equ bitPattern_level_12 = 0b00100000
.equ bitPattern_level_13 = 0b01001010
.equ bitPattern_level_14 = 0b11110001
.equ bitPattern_level_15 = 0b01111110
.equ bitPattern_level_16 = 0b00101011
.equ bitPattern_level_17 = 0b00001000
.equ bitPattern_level_18 = 0b00100110
.equ bitPattern_level_19 = 0b10111011
.equ bitPattern_level_20 = 0b11101011
.equ bitPattern_level_21 = 0b10011001
.equ bitPattern_level_22 = 0b10010110
.equ bitPattern_level_23 = 0b01101011
.equ bitPattern_level_24 = 0b00101001
.equ bitPattern_level_25 = 0b11001100
.equ bitPattern_level_26 = 0b00101100
.equ bitPattern_level_27 = 0b00010101
.equ bitPattern_level_28 = 0b00001010
.equ bitPattern_level_29 = 0b10010001
.equ bitPattern_level_30 = 0b11100010											;End at level 30 is assumed as the last level of the game

																				
InitialSetUp:																	;Game will enter initial setup once at the beggining of it. However every time the input from the player is wrong it will go again to initial setup
																				;Create stack

				LDI R16,high(RAMEND)											;
				out sph, R16													;
				LDI R16,low(RAMEND)												;
				out spl, R16													;
			     																;
																				;Adding patterns to the stack	
				LDI R16, bitPattern_level_20									;
				PUSH R16														;

				LDI R16, bitPattern_level_19									;
				PUSH R16														;

				LDI R16, bitPattern_level_18									;
				PUSH R16														;
																																	;
				LDI R16, bitPattern_level_17									;
				PUSH R16														;

				LDI R16, bitPattern_level_16									;
				PUSH R16														;

				LDI R16, bitPattern_level_15									;
				PUSH R16														;

				LDI R16, bitPattern_level_14									;
				PUSH R16														;

				LDI R16, bitPattern_level_13									;
				PUSH R16														;

				LDI R16, bitPattern_level_12									;
				PUSH R16														;

				LDI R16, bitPattern_level_11									;
				PUSH R16														;

				LDI R16, bitPattern_level_10									;
				PUSH R16														;
																			
																				;
				LDI R16, bitPattern_level_9										;
				PUSH R16														;
																			
																				;
				LDI R16, bitPattern_level_8										;
				PUSH R16														;
																			
																				;
				LDI R16, bitPattern_level_7										;
				PUSH R16														;
																			
																				;
				LDI R16, bitPattern_level_6										;
				PUSH R16														;
																			
																				;
				LDI R16, bitPattern_level_5										;
				PUSH R16														;
																		
																				;
				LDI R16, bitPattern_level_4										;
				PUSH R16														;
				
																				;
				LDI R16, bitPattern_level_3										;
				PUSH R16														;
				
																				;
				LDI R16, bitPattern_level_2										;
				PUSH R16														;
				
																				;
				LDI R16, bitPattern_level_1										;
				PUSH R16														;
				
																				;
				LDI R16, 0b11111111												;
				OUT ddra , R16									;Writes the binary pattern to port a data direction registrer
				OUT porta, R16									;Turn of LEDs
				LDI R18 ,0										;Defines register R18 used to store the level pattern
				LDI R19, 21										;Max level
				LDI R20 ,1										;Minus 1 level on success
jmp Level

restart:
				CLR R16
				LDI R16, 0x00
				OUT porta, R16
call delayPlayer												;Long delay
				
jmp InitialSetUp
                                                                ; Game setup
                                                                ; If wrong input go back to InitialSetUp based on that game will restart
																; If correct input go to next level
Level:
				SUB R19,R20										;Level minus 1
				cp R19,R20										;Checks if level is the last
				
breq win
				CLR R16
				LDI R16,0b11111111								;Clears register R16 used to display values on LED's
				CLR R17											;Clears register R17 used to store the value of the buttons
				CLR R18											;Clears register R18 used to store the value for the current level
				OUT porta,R16

call delayPlayer												;Long delay
				
				POP R16											;Pops a value of the stack
				add R18,R16
				OUT porta,R16									;Displays the value that was poped from the stack
				

call delay														;Call delay so player has time to see pattern
				CLR R16
				LDI R16,0b11111111								;Turn off LED's after showing the pattern for the current level
				OUT porta,R16									;Turn off LED's 
call delayPlayer												;Long delay
				IN R17,pinb										;Record player input in register R17
				CP R17,R18										;Compare bit pattern for current level with player input
				

brne restart													;If the input from the player is wrong it will restart the game
breq Level														;If the input from the player is correct it will continue to next level

win :
				LDI R16, 0b11111111
				;out ddra, r16
				OUT porta, R16
call delay
				LDI R16,0b00000000
				OUT porta,R16
call delay
			jmp win



;Delay methos showed by the teacher way to keep cpu busy so player is able to see result or give input
delay:
						LDI R22 ,120							;Delay register 1 
loop:					
						LDI R23 ,120							;Delay register 2
innerLoop:
						LDI R24 ,120							;Delay register 3
innerLoop2:
						dec r24
brne innerLoop2
						dec r23
brne innerLoop
						dec r22
brne loop
ret


delayPlayer:
						LDI R22 ,200							;Delay register 1 
loop22:					
						LDI R23 ,200							;Delay register 2
innerLoop22:
						LDI R24 ,200							;Delay register 3
innerLoop222:
						dec r24
brne innerLoop222
						dec r23
brne innerLoop22
						dec r22
brne loop22
ret

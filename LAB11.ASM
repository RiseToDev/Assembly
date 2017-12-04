.model small							;Model of memory for exe-file
.stack 100h								;Allocate memory for stack
.data 									;detect the data-segment
										
	a dw ?								;Init the variable a
	b dw ?								;Init the variable b
	d dw ?								;Init the variable d

 ;=================================Init the string for output=========================
  	;0Ah (10) - move the cursor in one position down
 	;0Dh (13) - go to the beginning of the current line
	toDo 		 db 'The program finds the sum of three numbers: r_12 = a - b + c^2.', 13, 10, '$' 
	firstNumber	 db 'Enter the first number - a: $'
	secondNumber db 'Enter the second number - b: $'
	thirdNumber  db 'Enter the third number - c: $'
	theSum 		 db 10, 13, 10,'The sum of input numbers is: $'
	exit         db 10, 13, 10, 'Press any key to exit...', 13, 10, '$'
	error 		 db 'Input error', 13, 10, '$'
 ;====================================================================================

	crlf   db 0dh, 0ah, '$'				;Moves you to a new line and clears the buffer
	buffer label byte 					; 
	maxL   db 6							;initialise 6 variables equals for six double words (32-bits or 4 bytes)
	actL   db ?							;initialise undetermined number of variables equals for six double words (32-bits or 4 bytes)
	field  db 6 dup(?) 					;dup(?) - initialise 6 variables equals for six double words (32-bits or 4 bytes)
	l      dw 6							;initialise 6 variables equals for six double words (32-bits or 4 bytes)
	outBuf db 6 dup(?), '$' 			;$ - symbol of the end of string

.code									;detect the code-segment
.386									;the set of commands of 386 processor
main: 									;the labe of beginning of the program
	mov ax, dgroup						;the beginning of data-segment in AX
	mov ds, ax 							;the beginning of data-segment in DS
	mov dx, offset toDo					;the beginning of the toDo string in DX / Set the address of the data receiver

	call WriteLine						;WriteLine procedure call
	mov dx, offset firstNumber			;Display the message: "Enter the first number: " / Set the address of the data receiver
	call WriteLine						;WriteLine procedure call
	call ReadLine						;ReadLine procedure call
	call ASCII_To_Bin					;ASCII_To_Bin procedure call
	mov a, ax 							;put the value of AX register in the variable "a"

			mov dx, offset crlf			;Moves you to a new line

	call WriteLine						;WriteLine procedure call
	mov dx, offset secondNumber			;Display the message: "Enter the second number: " / Set the address of the data receiver
	call WriteLine						;WriteLine procedure call
	call ReadLine						;ReadLine procedure call
	call ASCII_To_Bin					;ASCII_To_Bin procedure call
	mov b, ax 							;put the value of AX register in the variable "b"

			mov dx, offset crlf			;Moves you to a new line

	call WriteLine						;WriteLine procedure call
	mov dx, offset thirdNumber			;Display the message: "Enter the third number: " / Set the address of the data receiver
	call WriteLine						;WriteLine procedure call
	call ReadLine						;ReadLine procedure call
	call ASCII_To_Bin					;ASCII_To_Bin procedure call
	mov d, ax 							;put the value of AX register in the variable "c"

			mov dx, offset crlf			;Moves you to a new line

	;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\logic\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
							;r_12 = a - b + c^2	
							

							
							mov ax, d  	; in AX register put a variable "d"
							mul ax 		; = c^2. get the second power of "d"

							add ax, a 	; = c^2 + a. Adding to "d" a variable "a"
							sub ax, b 	; = (c^2 + a) - b. Substring from the amount - variable "b"							
	;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\end logic\\\\\\\\\\\\\\\\\\\\\\\\\\\

	mov dx, offset outBuf				;in dx upload the bin code of the number / Set the address of the data receiver
	mov bx, dx 							;then from dx to ax
	call BinToASCII						;BinToASCII procedure call, which is covert the bin code into ASCII
	mov dx, offset theSum				;display the 'The sum of input numbers is: '/ Set the address of the data receiver
	call WriteLine						;WriteLine procedure call, which write that is above
	mov dx, offset outBuf				;and display the number after '...input numbers is: ' / Set the address of the data receiver
	call WriteLine						;WriteLine procedure call, which write that is above
	mov dx, offset exit 				;display the 'Press any key to exit...' / Set the address of the data receiver

	call WriteLine						;WriteLine procedure call, which write that is above
	call WaitingForKey					;WaitingForKey procedure call
	call ExitProgram					;ExitProgram procedure call

;========================================"Linrary of methods"======================================================
;|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
;-------------Convert bin to ascii-------------------------
BinToASCII proc 						;init the procedure
	mov cx, l 							;put the value of 'l' in CX register

	Fill_Buf:							;init label
		mov byte ptr[bx], ' '			;split string array by the spaces 
		inc bx							;increment the value of the BX register by 1 pont (bx++)
		loop Fill_Buf					;do the loop
	mov si, 10							;put 10 in SI register

	Cld_Dvd:							;init label
		xor dx, dx    					;logical division of two registers. Return 1 if values are different, 0 if equal.
										;Reset OF and CF flags. And set ZF, PF, SF flags with the result.
		div si							;		
		add dx, '0' 					;Add char of 0 to the value in DX register
		dec bx 							;decreases the value of the BX register by 1 pont (bx--)
		mov byte ptr[bx], dl 			;mov the value from DL register to ptr-array
		inc cx 							;increment the value of the CX register by 1 pont (bx++)
		or ax, ax 						;logical addition of two registers. Return 1 if one of byte equal 1.
										;Reset OF and CF flags. Set SF and ZF, PF in oder of the result.
		jnz Cld_Dvd   					;jnz command set ZF flag in 0 and transmits the control on Cld_Dvd label
	BinToASCII endp						;the end of procedure
;-------------------------end------------------------------
;|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
;-----------Convert ascii to bin----------------------------
ASCII_To_Bin proc						;init the procedure
	xor di, di 							;logical division of two registers. Return 1 if values are different, 0 if equal.
										;Reset OF and CF flags. And set ZF, PF, SF flags with the result.
	xor ax, ax                          ;logical division of two registers. Return 1 if values are different, 0 if equal.
										;Reset OF and CF flags. And set ZF, PF, SF flags with the result.
	mov cl, actL						;mov the value in actL variable in CL register
	xor ch, ch   						;logical division of two registers. Return 1 if values are different, 0 if equal.
										;Reset OF and CF flags. And set ZF, PF, SF flags with the result.
	xor bx, bx 							;logical division of two registers. Return 1 if values are different, 0 if equal.
										;Reset OF and CF flags. And set ZF, PF, SF flags with the result.
	mov si, cx 							;mov the value in CX register in SI register
	mov cl, 10 							;mov 10 in CL register

	acsii2hex: 							;init label
		mov bl, byte ptr field[di] 		;mov something in BL register
		sub bl, '0' 					;Substring the 0 char from the value in BL register
		jb acsii_error 					;mov to "acsii_error" label when x < y and ZF=0 and CF=1
		cmp bl, '9'                     ;Subtracts the source operand from the data receiver.
										;The SMP does not change the value of the recipient's operand.
										;SMP changes CF, ZF, SP, OF, AF and PF. 
										;It sets them depending on the value that was obtained as a result of the SUB command
		ja acsii_error 					;mov to "acsii_error" label when x > y and ZF=0 and CF=0
		mul cx 							;multiply cx on cx
		add ax, bx 					 	;add to value in AX, the value from BX
		inc di 							;increment the value of the DI register by 1 pont (bx++)
		cmp di, si 						;Subtracts the source operand from the data receiver.
										;The SMP does not change the value of the recipient's operand.
										;SMP changes CF, ZF, SP, OF, AF and PF. 
										;It sets them depending on the value that was obtained as a result of the SUB command
		jb acsii2hex 					;mov to "acsii_error" label when x < y and ZF=0 and CF=1
		ret 							;Return procedure
		
	acsii_error: 						;init label
		mov dx, offset error 			;Display the message: "Input error" / Set the address of the data receiver
		call WriteLine 					;WriteLine procedure call
		mov dx, offset exit 			;Display the message: "Press any key to exit..." / Set the address of the data receiver
		call WriteLine					;WriteLine procedure call
		call WaitingForKey 				;WaitingForKey procedure call
		call ExitProgram 				;ExitProgram procedure call

	ASCII_To_Bin endp 					;the end of procedure
;-------------------------end------------------------------
;|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
;---------------Read from keyboard-------------------------
ReadLine proc 							;init the procedure
	push ax 							;PUSH places the value in the stack - puts the value in the memory location (Stack)
	mov dx, offset buffer 				;Set the address of the data receiver
	mov ah, 0ch 						;Function of displaying a point on the screen
	mov al, 0ah 						;keyboard input function
	int 21h 							;call for DOS function
	xor ch, ch 							;logical division of two registers. Return 1 if values are different, 0 if equal.
										;Reset OF and CF flags. And set ZF, PF, SF flags with the result.
	mov cl, actL 						;mov the value in actL variable in CL register
	add dx, 2 							;add to value in DX, the value = 2
	pop ax 								;POP retrieves a value from the stack - retrieves the value from the memory location pointed to by the ESP register
	ret 								;Return the procedure
	ReadLine endp 						;the end of procedure
;-------------------------end------------------------------
;|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
;-----------------Display on the screan--------------------
WriteLine proc 							;init the procedure
	push ax 							;PUSH places the value in the stack - puts the value in the memory location (Stack)
	mov ah, 09h 						;Function - output of strings
	int 21h 							;call for DOS function
	pop ax 								;POP retrieves a value from the stack - retrieves the value from the memory location pointed to by the ESP register
	ret 								;Return the procedure
	WriteLine endp 						;the end of procedure
;-------------------------end------------------------------
;|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
;---------------Method for waiting of key pressing---------
WaitingForKey proc 						;init the procedure
	push ax 							;PUSH places the value in the stack - puts the value in the memory location (Stack)
	mov ah, 8 							;The 08h function checks if you typed CTRL + BREAK
	int 21h 							;call for DOS function
	pop ax 								;POP retrieves a value from the stack - retrieves the value from the memory location pointed to by the ESP register
	ret 								;Return the procedure
	WaitingForKey endp 					;the end of procedure
;-------------------------end------------------------------
;|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
;---------------Method for exit of the program-------------
ExitProgram proc 						;init the procedure
	mov ax, 4c00h 	 					;the number of the function of the end of program in AX
	int 21h								;call for DOS function
	ret 								;Return the procedure
	ExitProgram endp 					;the end of procedure
;-------------------------end------------------------------
;|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
;================================================end of "Library"===================================================
end main 								;the end of main

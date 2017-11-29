.model small
.stack 100h
.data
	a dw ?
	b dw ?
	d dw ?
	r_12 dw ?

	toDo 		 db 'The program finds the sum of three numbers: r_12 = a - b + c^2.', 13, 10, '$'
	firstNumber	 db 'Enter the first number: $'
	secondNumber db 'Enter the second number: $'
	thirdNumber  db 'Enter the third number: $'
	theSum 		 db 10, 13, 10,'The sum of input numbers is: $'
	exit         db 10, 13, 10, 'Press any key to exit...', 13, 10, '$'
	error 		 db 'Input error', 13, 10, '$'

	crlf   db 0dh, 0ah, '$'
	buffer label byte 
	maxL   db 6
	actL   db ?
	field  db 6 dup(?)
	l      dw 6
	outBuf db 6 dup(?), '$'

.code
.386
main:
	mov ax, dgroup
	mov ds, ax
	mov dx, offset toDo

	call WriteLine
	mov dx, offset firstNumber
	call WriteLine
	call ReadLine
	call ASCII_To_Bin
	mov a, ax

			mov dx, offset crlf

	call WriteLine
	mov dx, offset secondNumber
	call WriteLine
	call ReadLine
	call ASCII_To_Bin
	mov b, ax

			mov dx, offset crlf

	call WriteLine
	mov dx, offset thirdNumber
	call WriteLine
	call ReadLine
	call ASCII_To_Bin
	mov d, ax

			mov dx, offset crlf

	;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\logic\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\	r_12 = a - b + c^2	
									;clc

									mov ax, d
									mul ax; = c^2

									add ax, a; = c^2 + a
									sub ax, b; = (c^2 + a) - b
	;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\end logic\\\\\\\\\\\\\\\\\\\\\\\\\\\

	mov dx, offset outBuf
	mov bx, dx
	call BinToASCII
	mov dx, offset theSum
	call WriteLine
	mov dx, offset outBuf
	call WriteLine
	mov dx, offset exit
	call WriteLine
	call WaitingForKey
	call ExitProgram

;========================================"Linrary of methods"======================================================
;|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
;-------------Convert bin to ascii-------------------------
	BinToASCII proc
	mov cx, l

	Fill_Buf:
		mov byte ptr[bx],' '
		inc bx
		loop Fill_Buf
	mov si, 10

	Cld_Dvd:
		xor dx, dx
		div si
		add dx, '0'
		dec bx
		mov byte ptr [bx], dl
		inc cx
		or ax, ax
		jnz Cld_Dvd
	BinToASCII endp
;-------------------------end------------------------------

;-----------Convert ascii to bin----------------------------
	ASCII_To_Bin proc
	xor di, di 
	xor ax, ax
	mov cl, actL
	xor ch, ch
	xor bx, bx
	mov si, cx
	mov cl, 10

	acsii2hex:
		mov bl, byte ptr field[di]
		sub bl, '0'
		jb acsii_error
		cmp bl, '9'
		ja acsii_error
		mul cx
		add ax, bx
		inc di
		cmp di, si
		jb acsii2hex
		ret
		
	acsii_error:
		mov dx, offset error
		call WriteLine
		mov dx, offset exit
		call WriteLine
		call WaitingForKey
		call ExitProgram

	ASCII_To_Bin endp
;-------------------------end------------------------------

;---------------Read from keyboard-------------------------
	ReadLine proc 
	push ax
	mov dx, offset buffer
	mov ah, 0ch
	mov al, 0ah
	int 21h
	xor ch, ch
	mov cl, actL
	add dx, 2
	pop ax
	ret
	ReadLine endp
;-------------------------end------------------------------

;-----------------Display on the screan--------------------
	WriteLine proc
	push ax
	mov ah, 09h
	int 21h
	pop ax
	ret
	WriteLine endp
;-------------------------end------------------------------

;---------------Method for waiting of key pressing---------
	WaitingForKey proc
	push ax
	mov ah, 8
	int 21h
	pop ax
	ret
	WaitingForKey endp
;-------------------------end------------------------------

;---------------Method for exit of the program-------------
	ExitProgram proc
	mov ax, 4c00h
	int 21h
	ret
	ExitProgram endp
;-------------------------end------------------------------
;|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
;================================================end of "Library"===================================================
end main

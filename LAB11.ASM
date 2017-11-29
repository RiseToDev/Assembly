.model
.stack 100h
.data
	a dw ?
	b dw ?
	d dw ?

	toDo 		 db 'The program finds the sum of three numbers.', 13, 10, '$'
	firstNumber	 db 'Enter the first number: $'
	secondNumber db 'Enter the second number $'
	thirdNumber  db 'Enter the third number: $'
	theSum 		 db 'The sum of input numbers is:', '$'
	exit         db 10, 13, 10, 'Press any key to exit...', 13, 10, '$'
	error 		 db 'Input error', 13, 10, '$'

	crlf   db 0dh, 0ah, '$'
	buffer label byte 
	maxL   db 6
	actL   db ?
	field  db 6 dup (?)
	l      dw 6
	outBuf db 6 (?), '$'

.code
.386
main:
	mov ax, dgroup
	mov ds, ax
	mov dx, offset toDo

	call Console.WriteLine
	mov dx, offset firstNumber
	call Console.WriteLine
	call Console.ReadLine
	call ASCII_To_Bin
	mov a, ax

			mov dx, offset crlf

	call Console.WriteLine
	mov dx, offset secondNumber
	call Console.WriteLine
	call Console.ReadLine
	call ASCII_To_Bin
	mov b, ax

			mov dx, offset crlf

	call Console.WriteLine
	mov dx, offset thirdNumber
	call Console.WriteLine
	call Console.ReadLine
	call ASCII_To_Bin
	mov d, ax

			mov dx, offset crlf

	;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\logic\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\		

	
	;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\end logic\\\\\\\\\\\\\\\\\\\\\\\\\\

	mov dx, offset outBuf
	mov bx, dx
	call BinToASCII
	mov dx, offset theSum
	call Console.WriteLine
	mov dx, offset outBuf
	call Console.WriteLine
	mov dx, offset exit
	call Console.WriteLine
	call Console.WaitingForKey
	call Console.ExitProgram

;========================================"Linrary of methods"======================================================

;-------------Convert bin to ascii-------------------------
	Console.BinToASCII proc
	mov cx, l

	Fill_Buf:
		mov byte ptr[bx],''
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
	Console.BinToASCII endp
;-------------------------end------------------------------

;-----------Convert ascii to bin----------------------------
	Console.ASCII_To_Bin proc
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
		call Console.WriteLine
		mov dx, offset exit
		call Console.WriteLine
		call Console.WaitingForKey
		call Console.ExitProgram

	ASCII_To_Bin endp
;-------------------------end------------------------------

;---------------Read from keyboard-------------------------
	Console.ReadLine proc 
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
	Console.ReadLine endp
;-------------------------end------------------------------

;-----------------Display on the screan--------------------
	Console.WriteLine proc
	push ax
	mov ah, 09h
	int 21h
	pop ax
	ret
	Console.WriteLine endp
;-------------------------end------------------------------

;---------------Method for waiting of key pressing---------
	Console.WaitingForKey proc
	push ax
	mov ah, 8
	int 21h
	pop ax
	ret
	Console.WaitingForKey endp
;-------------------------end------------------------------

;---------------Method for exit of the program-------------
	Console.ExitProgram proc
	mov ax, 4c00h
	int 21h
	ret
	Console.ExitProgram endp
;-------------------------end------------------------------
;================================================end of "Library"===================================================
end main

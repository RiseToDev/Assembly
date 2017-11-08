.model small
.stack 100h
.data
	original_string	db 'Assembler language programming the fastest in the world', 13, 10, '$'
	new_string db 255 DUP(?)
.code
.386
main:
	mov ax,	@data
	mov ds,	ax
	mov es,	ax

	mov dx,	offset original_string
	mov ah,	9
	int 21h	
	
	mov esi, offset original_string	
	mov edi, offset	new_string
	std
	mov ecx, lengthof original_string

	mov ecx, 25
	;sub ecx, 25
	rep movsb

	mov dx,	offset new_string
	mov ah,	9
	int 21h

	mov ax,	4c00h
	int 21h
end main
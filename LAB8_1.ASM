	.model small
	.stack 100h
	.data
		seven word 7
		res word ?
		message byte "Variant 12. (jl) res = 1C7h || 455", 0dh, 0ah, "$"
	.code
	.386

main:
	mov ax, @data
	mov ds, ax

	mov bx, 0
	mov cx, 0

	L1:
	inc cx
	mov ax, cx
	add ax, 1
	mul seven
	add bx, ax
	cmp cx, 10	
	jl L1
	
	mov res, bx

			mov ah,	9
			mov dx,	offset message
			int 21h

		
	mov ax, 4c00h
	int 21h
end main

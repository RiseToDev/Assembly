	.model small
	.stack 100h
	.data
		N_greater_M byte "N>M",	0dh, 0ah, "$"
		N_less_M byte "N<M", 0dh, 0ah, "$"
		N_equal_M byte "N=M", 0dh, 0ah,	"$"

		val1 word 12
		val2 word 7
		val3 word 4
		val4 word 10
		N    word ?
		M    word ?

	.code
	.386
	main:
	mov ax,	@data
	mov ds,	ax

	mov ax,	11
	mov val1, ax
	mov ax,	3
	mov val2, ax
	mov ax,	3
	mov val3, ax
	mov ax,	8
	mov val4, ax

	mov ax,	val1
	add ax,	val2
	mov bx,	5
	mul bx
	mov N, ax

	mov ax,	val4
	add ax,	3
	mul val3
	mov M, ax

	mov ax,	N
	mov bx,	M
	cmp Ax,	bx
	jg write_N_greater_M
	jl write_N_less_M
	je write_N_equal_M

	write_N_greater_M:
	mov ah,	9
	mov dx,	offset N_greater_M
	int 21h
	jmp exit_program

	write_N_less_M:
	mov ah,	9
	mov dx,	offset N_less_M
	int 21h
	jmp exit_program

	write_N_equal_M:
	mov ah,	9
	mov dx,	offset N_equal_M
	int 21h
	jmp exit_program

	exit_program:
	mov ax,	4c00h
	int 21h
	end main

	.model small
	.stack 100h
	.data

		message byte "Variant 12. Have to be: N > M !", 0dh, 0ah,	"$"

		N_greater_M byte "else N gt M, res: N>M",	0dh, 0ah, "$"
		N_less_M byte "elseif N lt M, res: N<M", 0dh, 0ah, "$"
		N_equal_M byte "if N eq M, res: N=M", 0dh, 0ah,	"$"	

		val1 word ?
		val2 word ?
		val3 word ?
		val4 word ?
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
		
		;mov ax,	N
		;mov bx,	M
		;cmp Ax,	bx
		;jg write_N_greater_M
		;jl write_N_less_M
		;je write_N_equal_M	
		
			mov ah,	9
			mov dx,	offset message
			int 21h

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

				.if N eq M
				jmp write_N_equal_M				
				
				.elseif N lt M
				jmp write_N_less_M
								
				.else 
				jmp write_N_greater_M
								
				.endif		

		exit_program:
		mov ax,	4c00h
		int 21h
		end main

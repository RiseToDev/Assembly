.model small
.stack 100h
.data
	a dword 100
	b dword 4
	d dword 10	
	r_12 dword ?
.code
.386
main PROC

	mov ax, @data
	mov ds, ax
	mov ebx, a
	mov ecx, b
	mov edx, d
		call calculate
	mov r_12, eax

mov ax, 4c00h
int 21h
main ENDP

		calculate PROC USES ebx ecx edx 
		;12) r12 = (a - b) * (b - d)^2
		;12) r_12 = (ebx - ecx) * ((ecx - edx) * (ecx - edx))
		;12) r_12 = (ebx - ecx) * 24h
			CLC
			
			mov eax, ecx	
			sub eax, edx; remember the reuslt of (b - d) = (ecx - edx)
			mov eax, eax
			mul eax		; the result of (b - d)^2 = -6 * -6 = 36 = 24h

						 ;12) r_12 = (ebx - ecx) * 24h

			sub ebx, ecx ;12) r_12 = (a - b) = (ebx - ecx) = 96 = 60h

			;12) r_12 = 60h * 24h = 3456 = D80
			mul ebx
			ret
		calculate ENDP

end main
.model small
.stack 100h
.data
N_greater_M	BYTE "N>M", 0Dh,0Ah, "$"
N_less_M	BYTE "N<M", 0Dh,0Ah, "$"
N_equal_M	BYTE "N=M", 0Dh,0Ah, "$"

.code
.386
main:
mov	ax, @data	; ���������� �����
mov	ds,ax		; ������ ����������� ������ � ds


N equ 5*(11+3)
M equ 3*(3+25)

.if (N gt M)
mov	ah,9
mov	dx, offset N_greater_M
int 21h
jmp exit_program

.elseif	(N lt M)
mov	ah,9
mov	dx, offset N_less_M
int 21h
jmp exit_program

.else
mov	ah,9
mov	dx, offset N_equal_M
int 21h
jmp exit_program

.endif

exit_program:
mov	ax, 4C00h	; �����	�������	DOS:4C00h ��������� ��������� �	��
int	21h		; �����	�������	��� �� ��
end main

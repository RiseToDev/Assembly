;counting the amount of elements in the second row
.model small
.stack 100h
.data
	tableB	byte  10h,  20h,  30h,	40h,  50h
			byte  60h,  70h,  80h,	90h, 0A0h
			byte 0B0h, 0C0h, 0D0h, 0E0h, 0F0h
	NumCols	= 5
	RowNumber =	2
	ColumnNumber = 2
.code
.386
main:
	mov ax,	@data
	mov ds,	ax

	mov ecx, NumCols
	mov ebx, offset	tableB
	mov ebx, (NumCols * RowNumber)
	mov esi, 0
	mov  ax, 0
	mov  dx, 0

.repeat
	inc esi
	mov dl,	[ebx + esi]
	add ax,	dx
	;inc esi ;incorrect place
	.until esi == 5

mov ax,	4c00h
int 21h
end main

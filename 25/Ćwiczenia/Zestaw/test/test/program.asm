.686
.model flat

public _main

.data
	linie dw 242, 424, 37, -3, 1024, 5, 0

.code
_main proc
	xor edi,edi
	mov esi, offset linie+4
	mov ebx,2
	mov di, [ebx][esi]
	nop

	mov ecx,3
mov eax,0
petla: sub ecx,1
add eax,1
cmp ecx,0
or eax,eax
jc petla

	nop


_main endp
end
; funkcja przestawia liczby w tablicy


.686
.model flat

public		_przestaw

.code
_przestaw	PROC

	push	ebp				; prolog
	mov		ebp, esp
	push	ebx

	mov		ebx, [ebp + 8]	; adres tablicy
	mov		ecx, [ebp + 12]	; liczba elementow tablicy
	dec		ecx				; zmniejszamy o 1, bo bedziemy porownywac z nastepnym elementem

	ptl:
		mov		eax, [ebx]		; pobieramy pierwszy element
		cmp		eax, [ebx + 4]	; porownujemy z nastepnym
		jle		gotowe

		mov		edx, [ebx + 4]	; jesli pierwszy jest wiekszy, zamieniamy je
		mov		[ebx], edx
		mov		[ebx + 4], eax

	gotowe:
		add		ebx, 4			; przechodzimy do nastepnego elementu
		loop	ptl				; petla do konca tablicy

	pop		ebx
	pop		ebp
	ret
_przestaw	ENDP
END
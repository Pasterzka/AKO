; Program szuka maksymalnej wartosci z poœród trzech podanych liczb

.686
.model flat

public		_szukajmax3


.code
_szukajmax3	PROC

	push	ebp				; zachowanie starej wartosci ebp
	mov		ebp, esp		; kopiowanie wartosci esp do ebp

	mov		eax, [ebp+8]	; w eax a
	cmp		eax, [ebp+12]	; porownanie a z b
	jge		a_wieksze		; jesli a >= b, przejdz do a_wieksze_b

	mov		eax, [ebp+12]	; w eax b
	cmp		eax, [ebp+16]	; porownanie b z c
	jge		b_wieksze		; jesli b >= c, przejdz do b_wieksze

	c_wieksze:
		mov		eax, [ebp+16]	; w eax c

		zakoncz:
			pop		ebp			; przywrocenie starej wartosci ebp
			ret


	a_wieksze:
		cmp		eax, [ebp+16]	; porownanie a z c
		jge		zakoncz			; jesli a >= c, zakoncz
		jmp		c_wieksze		; przejdz do c_wieksze

	b_wieksze:
		mov		eax, [ebp+12]	; liczba b
		jmp		zakoncz			; zakoncz

_szukajmax3	ENDP
END

; Program szuka maksymalnej wartosci z poœród trzech podanych liczb

.686
.model flat

public		_szukajmax4


.code
_szukajmax4	PROC

	push	ebp				; zachowanie starej wartosci ebp
	mov		ebp, esp		; kopiowanie wartosci esp do ebp

	mov 	eax, [ebp+8]	; w eax a
	cmp		eax, [ebp+12]	; porownanie a z b
	jge		a_wieksze_1		; jesli a >= b, przejdz do a_wieksze

	mov		eax, [ebp+12]	; w eax b
	cmp		eax, [ebp+16]	; porownanie b z c
	jge		b_wieksze_1		; jesli b >= c, przejdz do b_wieksze


	c_wieksze_1:
		mov		eax, [ebp+16]	; w eax c
		cmp		eax, [ebp+20]	; porownanie c z d
		jge		zakoncz			; jesli c >= d, przejdz do c_wieksze

	d_wieksze_1:
		mov		eax, [ebp+20]	; w eax d
		jmp		zakoncz			; zakoncz


		zakoncz:
			pop		ebp			; przywrocenie starej wartosci ebp
			ret


	a_wieksze_1:
		cmp		eax, [ebp+16]	; porownanie a z c
		jge		a_wieksze_2		; jesli a >= c, przejdz do a_wieksze_2
		jmp		c_wieksze_1		; przejdz do c_wieksze
		
		a_wieksze_2:
			cmp		eax, [ebp+20]	; porownanie a z d
			jge		zakoncz			; jesli a >= d, zakoncz
			jmp		d_wieksze_1		; przejdz do d_wieksze


	b_wieksze_1:
		cmp		eax, [ebp+20]	; porownanie b z d
		jge		zakoncz			; jesli b >= d, zakoncz
		jmp		d_wieksze_1		; przejdz do d_wieksze

_szukajmax4	ENDP
END

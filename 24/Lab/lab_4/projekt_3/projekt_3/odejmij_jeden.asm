; program odjemuje 1 od liczby w pamieci pami�ci (wska�nik na wska�nik)


.686
.model flat

public		_odejmij_jeden


.code
_odejmij_jeden		PROC
	push	ebp
	mov		ebp, esp		; prolog
	push	ebx
	push	ecx

	mov		ebx, [ebp+8]	; pobierz adres wska�nika
	mov		eax, [ebx]		; pobierz wska�nik
	mov		ecx, [eax]		; pobierz liczb�

	dec		ecx				; odejmij 1
	mov		[eax], ecx		; zapisz z powrotem
	mov		[ebx], eax		; zapisz z powrotem wska�nik (cho� nie zmieni� si�)]

	pop		ecx
	pop 	ebx				; powrot do stanu sprzed wywo�ania
	pop		ebp
	ret
_odejmij_jeden		ENDP
END
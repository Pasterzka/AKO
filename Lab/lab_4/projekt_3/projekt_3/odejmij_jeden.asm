; program odjemuje 1 od liczby w pamieci pamiÍci (wskaünik na wskaünik)


.686
.model flat

public		_odejmij_jeden


.code
_odejmij_jeden		PROC
	push	ebp
	mov		ebp, esp		; prolog
	push	ebx
	push	ecx

	mov		ebx, [ebp+8]	; pobierz adres wskaünika
	mov		eax, [ebx]		; pobierz wskaünik
	mov		ecx, [eax]		; pobierz liczbÍ

	dec		ecx				; odejmij 1
	mov		[eax], ecx		; zapisz z powrotem
	mov		[ebx], eax		; zapisz z powrotem wskaünik (choÊ nie zmieni≥ siÍ)]

	pop		ecx
	pop 	ebx				; powrot do stanu sprzed wywo≥ania
	pop		ebp
	ret
_odejmij_jeden		ENDP
END
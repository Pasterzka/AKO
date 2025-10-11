; program zamienia liczbê w pamiêci na jej przeciwn¹ (wskaŸnik)


.686
.model flat

public		_przeciwna

.code
_przeciwna		PROC
	push 	ebp
	mov 	ebp, esp		; prolog
	push	ebx				; zachowaj rejestry

	mov		ebx, [ebp+8]	; pobierz wskaŸnik do liczby
	mov		eax, [ebx]		; pobierz liczbê

	neg		eax				; zamieñ na przeciwn¹
	mov		[ebx], eax		; zapisz z powrotem do pamiêci


	pop		ebx				
	pop		ebp				
	ret
_przeciwna		ENDP
END
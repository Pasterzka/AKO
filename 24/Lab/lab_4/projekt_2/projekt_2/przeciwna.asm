; program zamienia liczb� w pami�ci na jej przeciwn� (wska�nik)


.686
.model flat

public		_przeciwna

.code
_przeciwna		PROC
	push 	ebp
	mov 	ebp, esp		; prolog
	push	ebx				; zachowaj rejestry

	mov		ebx, [ebp+8]	; pobierz wska�nik do liczby
	mov		eax, [ebx]		; pobierz liczb�

	neg		eax				; zamie� na przeciwn�
	mov		[ebx], eax		; zapisz z powrotem do pami�ci


	pop		ebx				
	pop		ebp				
	ret
_przeciwna		ENDP
END
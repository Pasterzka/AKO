; program dodaje jeden do liczby znajduj�cej si� w pami�ci (wska�nik)

.686
.model flat

public		_plus_jeden

.code
_plus_jeden		PROC

	push 	ebp
	mov 	ebp, esp		; prolog

	push	ebx				; zachowaj rejestry
	
	mov		ebx, [ebp+8]	; pobierz wska�nik do liczby
	

	mov		eax, [ebx]		; pobierz liczb�
	inc		eax				; dodaj jeden
	mov		[ebx], eax		; zapisz z powrotem do pami�ci

	; JEDNA INSTRUKCJA -> INC dword ptr [ebx]


	pop		ebx				; pobierz wska�nik do liczby
	pop 	ebp
	ret
_plus_jeden		ENDP
END

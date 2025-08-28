; program dodaje jeden do liczby znajdujπcej siÍ w pamiÍci (wskaünik)

.686
.model flat

public		_plus_jeden

.code
_plus_jeden		PROC

	push 	ebp
	mov 	ebp, esp		; prolog

	push	ebx				; zachowaj rejestry
	
	mov		ebx, [ebp+8]	; pobierz wskaünik do liczby
	

	mov		eax, [ebx]		; pobierz liczbÍ
	inc		eax				; dodaj jeden
	mov		[ebx], eax		; zapisz z powrotem do pamiÍci

	; JEDNA INSTRUKCJA -> INC dword ptr [ebx]


	pop		ebx				; pobierz wskaünik do liczby
	pop 	ebp
	ret
_plus_jeden		ENDP
END

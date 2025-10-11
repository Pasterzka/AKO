; program oblicza pierwiastek kwadratowy z liczby zmiennoprzecionych

.686
.XMM
.model flat

public		_pierwiastek_SSE

.code
_pierwiastek_SSE		PROC
	push 	ebp
	mov 	ebp, esp
	push	ebx
	push	esi

	mov		esi, [ebp + 8]	; wskaŸnik na tablicê A
	mov		ebx, [ebp + 12]	; wskaŸnik na tablicê wynikow¹

	; ³adowanie do rejestru xmm5 czterech liczb zmiennoprzecin-
	; kowych 32-bitowych - liczby zostaj¹ pobrane z tablicy,
	; której adres pocz¹tkowy podany jest w rejestrze ESI

	movups xmm6, [esi]

	; obliczanie pierwiastka z czterech liczb zmiennoprzecinkowych
	; znajduj¹cych sie w rejestrze xmm6 - wynik wpisywany jest do xmm5
	sqrtps xmm5, xmm6

	movups [ebx], xmm5	; zapisanie wyniku do tablicy wynikowej

	pop		esi
	pop		ebx
	pop 	ebp
	ret
_pierwiastek_SSE		ENDP
END
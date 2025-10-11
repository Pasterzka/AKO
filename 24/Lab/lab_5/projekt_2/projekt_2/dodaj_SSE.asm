; Program dodaje dwie tablice liczb zmiennoprzecionych
.686
.XMM
.model flat


public		_dodaj_SSE

.code
_dodaj_SSE		PROC
	push 	ebp
	mov 	ebp, esp

	push	ebx
	push	esi
	push	edi


	mov		esi, [ebp + 8]	; wska�nik na tablic� A
	mov		edi, [ebp + 12]	; wska�nik na tablic� B
	mov		ebx, [ebp + 16]	; liczba element�w tablicy

	; interpretacja mnemonika "movups" :
	; mov - operacja przes�ania,
	; u - unaligned (adres obszaru nie jest podzielny przez 16),
	; p - packed (do rejestru �adowane s� od razu cztery liczby), ; s - short (inaczej float, liczby zmiennoprzecinkowe 32-bitowe)

	movups	xmm5, [esi]	; za�aduj 4 liczby z tablicy A do rejestru xmm0
	movups	xmm6, [edi]	; za�aduj 4 liczby z tablicy B do rejestru xmm1

	; sumowanie czterech liczb zmiennoprzecinkowych zawartych w rejestrach xmm5 i xmm6
	addps	xmm5, xmm6	; dodaj zawarto�� rejestru xmm1 do rejestru xmm0

	movups	[ebx], xmm5	; zapisz wynik w tablicy wynikowej

	pop		edi
	pop		esi
	pop		ebx
	pop 	ebp
	ret
_dodaj_SSE		ENDP
END
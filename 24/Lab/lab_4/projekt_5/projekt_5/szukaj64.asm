public		szukaj64_max

.code
szukaj64_max	PROC
	push	rbx
	push	rsi

	mov		rbx, rcx			; adres startu tablicy
	mov		rcx, rdx			; liczba elementów tablicy

	mov		rsi, 0				; bierz¹cy indeks

	; RAX bêdzie przechowywaæ maksymaln¹ wartoœæ
	mov		rax, [rbx+rsi*8]	; inicjalizacja maksymalnej wartoœci pierwszym elementem tablicy


	dec		rcx					; zmniejszenie liczby elementów o 1 (pierwszy ju¿ wziêty pod uwagê)

	ptl:
		inc		rsi				; przejœcie do nastêpnego elementu tablicy
		cmp		rax, [rbx+rsi*8] ; porównanie bie¿¹cego maksimum z nastêpnym elementem
		jge		dalej			; jeœli bie¿¹ce maksimum jest wiêksze lub równe, przejdŸ dalej
		mov		rax, [rbx+rsi*8] ; aktualizacja maksimum


		dalej:
			loop	ptl			; powtarzaj, a¿ wszystkie elementy zostan¹ sprawdzone


	pop		rsi
	pop		rbx
	ret
szukaj64_max	ENDP
END
public		szukaj64_max

.code
szukaj64_max	PROC
	push	rbx
	push	rsi

	mov		rbx, rcx			; adres startu tablicy
	mov		rcx, rdx			; liczba element�w tablicy

	mov		rsi, 0				; bierz�cy indeks

	; RAX b�dzie przechowywa� maksymaln� warto��
	mov		rax, [rbx+rsi*8]	; inicjalizacja maksymalnej warto�ci pierwszym elementem tablicy


	dec		rcx					; zmniejszenie liczby element�w o 1 (pierwszy ju� wzi�ty pod uwag�)

	ptl:
		inc		rsi				; przej�cie do nast�pnego elementu tablicy
		cmp		rax, [rbx+rsi*8] ; por�wnanie bie��cego maksimum z nast�pnym elementem
		jge		dalej			; je�li bie��ce maksimum jest wi�ksze lub r�wne, przejd� dalej
		mov		rax, [rbx+rsi*8] ; aktualizacja maksimum


		dalej:
			loop	ptl			; powtarzaj, a� wszystkie elementy zostan� sprawdzone


	pop		rsi
	pop		rbx
	ret
szukaj64_max	ENDP
END
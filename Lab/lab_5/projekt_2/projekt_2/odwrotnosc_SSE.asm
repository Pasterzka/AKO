; program oblicza odwrotno�� (1/x) z liczby zmiennoprzecionych

.686
.XMM
.model flat

public		_odwrotnosc_SSE

.code
_odwrotnosc_SSE		PROC
	push 	ebp
	mov 	ebp, esp
	push	ebx
	push	esi


	mov		esi, [ebp + 8]	; wska�nik na tablic� A
	mov		ebx, [ebp + 12]	; wska�nik na tablic� wynikow�


	; �adowanie do rejestru xmm6 czterech liczb zmiennoprzecin- kowych 32-bitowych - liczby zostaj� pobrane z tablicy,
	; kt�rej adres pocz�tkowy podany jest w rejestrze ESI
	movups	 xmm6, [esi]

	; obliczanie odwrotno�ci z czterech liczb zmiennoprzinkowych
	; znajduj�cych sie w rejestrze xmm6 - wynik wpisywany jest do xmm5
	rcpps xmm5, xmm6

	movups [ebx], xmm5	; zapisanie wyniku do tablicy wynikowej

	pop		esi
	pop		ebx
	pop 	ebp
	ret
_odwrotnosc_SSE		ENDP
END
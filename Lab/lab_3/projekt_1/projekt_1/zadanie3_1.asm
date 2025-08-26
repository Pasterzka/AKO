; Program wyœwietlaj¹cy na ekranie ci¹g 50 pierwszych liczb 1 2 4 7 11 16 22 29 37 46...

.686
.model flat


extern		__write			:PROC
extern		_ExitProcess@4	:PROC
public		_main

.data
	znaki	db	12 dup (?)	; bufor na znaki tworzonej cyfry

.code
; Funkcja wyœwietlaj¹ca zawartoœæ rejestru EAX jako liczbê dziesiêtn¹
wyswietl_EAX	PROC

	; Zapisz rejestry, które bêdziemy u¿ywaæ
	push	esi
	push	edi
	push	ebx
	push	edx
	push	ecx
	push	eax

	mov		esi, 10				; indeks tablicy znaków
	mov		edi, 10				; dzielnik

	; Konwersja binarno dziesiêtna

	konwersja:
		mov		edx, 0			; zerowanie starszej czêœci
		div		edi				; dzielenie przez 10 i reszta w EDX, iloraz w EAX

		add		dl, 30H			; zmiana reszty z dzielenia na kod ASCII
		mov		znaki[esi], dl	; zapisanie cyfry w ascii
		dec		esi				; zmniejszenie indeksu
		cmp		eax, 0			; sprawdzenie czy iloraz jest równy 0
		jne		konwersja		; skok gdy iloraz nie zerowy


	; Dodanie spacji na pocz¹tku
	wypeln:
		or		esi,esi						; sprawdzenie czy esi = 0
		jz		wyswietl					; skok gdy esi = 0
		mov		byte ptr znaki[esi], 20H	; dodanie spacji
		dec		esi							; nastêpna spacja
		jmp		wypeln


	wyswietl:
		mov		byte ptr znaki[0], 0AH		; nowa linia
		mov		byte ptr znaki[11], 0AH		; nowa linia

	; Wyœwietlenie na konsole
	push	12							; liczba znaków
	push	dword ptr offset znaki		; adres obszaru
	push	dword ptr 1					; urz¹dzenie 1=ekran
	call	__write						; wyœwietlenie
	add		esp, 12						; usuniêcie parametrów ze stosu

	; Przywrócenie rejestrów i powrót do programu
	pop		eax
	pop		ecx
	pop		edx
	pop 	ebx
	pop		edi			
	pop		esi
	ret
wyswietl_EAX	ENDP

_main			PROC

	mov		eax, 1			; Pierwsza liczba
	mov		ecx, 49			; powtórzenia
	mov		ebx, 1			; dodajnik

	call	wyswietl_EAX	; pierwsze wyœeitelnie


	; Pêtla wyœwietlania
	ptl:
		add		eax,ebx			; dodanie indeksu do liczby
		inc		ebx				; zwiêkszenie indeksu
		call	wyswietl_EAX	; wyœwietelnie sumy
		dec		ecx
		cmp		ecx, 0
		jnz		ptl






	; Zakoñczenie programu
	push	0
	call	_ExitProcess@4
_main			ENDP
END
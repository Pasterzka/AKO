; Program wy�wietlaj�cy na ekranie ci�g 50 pierwszych liczb 1 2 4 7 11 16 22 29 37 46...

.686
.model flat


extern		__write			:PROC
extern		_ExitProcess@4	:PROC
public		_main

.data
	znaki	db	12 dup (?)	; bufor na znaki tworzonej cyfry

.code
; Funkcja wy�wietlaj�ca zawarto�� rejestru EAX jako liczb� dziesi�tn�
wyswietl_EAX	PROC

	; Zapisz rejestry, kt�re b�dziemy u�ywa�
	push	esi
	push	edi
	push	ebx
	push	edx
	push	ecx
	push	eax

	mov		esi, 10				; indeks tablicy znak�w
	mov		edi, 10				; dzielnik

	; Konwersja binarno dziesi�tna

	konwersja:
		mov		edx, 0			; zerowanie starszej cz�ci
		div		edi				; dzielenie przez 10 i reszta w EDX, iloraz w EAX

		add		dl, 30H			; zmiana reszty z dzielenia na kod ASCII
		mov		znaki[esi], dl	; zapisanie cyfry w ascii
		dec		esi				; zmniejszenie indeksu
		cmp		eax, 0			; sprawdzenie czy iloraz jest r�wny 0
		jne		konwersja		; skok gdy iloraz nie zerowy


	; Dodanie spacji na pocz�tku
	wypeln:
		or		esi,esi						; sprawdzenie czy esi = 0
		jz		wyswietl					; skok gdy esi = 0
		mov		byte ptr znaki[esi], 20H	; dodanie spacji
		dec		esi							; nast�pna spacja
		jmp		wypeln


	wyswietl:
		mov		byte ptr znaki[0], 0AH		; nowa linia
		mov		byte ptr znaki[11], 0AH		; nowa linia

	; Wy�wietlenie na konsole
	push	12							; liczba znak�w
	push	dword ptr offset znaki		; adres obszaru
	push	dword ptr 1					; urz�dzenie 1=ekran
	call	__write						; wy�wietlenie
	add		esp, 12						; usuni�cie parametr�w ze stosu

	; Przywr�cenie rejestr�w i powr�t do programu
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
	mov		ecx, 49			; powt�rzenia
	mov		ebx, 1			; dodajnik

	call	wyswietl_EAX	; pierwsze wy�eitelnie


	; P�tla wy�wietlania
	ptl:
		add		eax,ebx			; dodanie indeksu do liczby
		inc		ebx				; zwi�kszenie indeksu
		call	wyswietl_EAX	; wy�wietelnie sumy
		dec		ecx
		cmp		ecx, 0
		jnz		ptl






	; Zako�czenie programu
	push	0
	call	_ExitProcess@4
_main			ENDP
END
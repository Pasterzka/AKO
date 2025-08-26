; Program wczytuje liczb� dziesi�tn� do EAX, a nast�pnie wy�wietla j� szesnastkowo


.686
.model flat

extern		__read			:PROC
extern		__write			:PROC
extern		_ExitProcess@4	:PROC
public		_main

.data
	obaszar		db	12 dup (?)			; bufor na znaki tworzonecej si� cyfry
	dziesiec	dd	10					; mno�nik

	text_1		db	'Podaj liczbe: ', 10
	text_2		db	?

	dekoder		db	'0123456789ABCDEF'	; tablica znak�w szesnastkowych


.code
; Funkcja wczytuj�ca liczb� dziesi�tn� z klawiatury do rejestru EAX
Wczytaj_EAX	PROC
	; Zapisanie rejestr�w, kt�re b�dziemy u�ywa�
	push	ebx
	push	ecx

	; Wczytanie z klawiatury
	push	dword ptr 12				; liczba znak�w
	push	dword ptr offset obaszar	; adres obszaru
	push	dword ptr 0					; urz�dzenie 0=klawiatura
	call	__read						; wczytanie
	add		esp, 12						; usuni�cie parametr�w ze stosu

	; Konwersja dziesi�tna na binarn�
	mov		eax, 0						; zerowanie EAX (wynik)
	mov		ebx, offset obaszar			; wska�nik na bufor

	pobierz_znak:
		mov		cl, byte ptr [ebx]		; pobranie znaku
		inc		ebx						; przej�cie do nast�pnego znaku
		cmp		cl, 0AH					; sprawdzenie czy znak to Enter (nowa linia)
		je		koniec_wczytywania		; je�li tak, zako�cz wczytywanie

		sub		cl, 30H					; konwersja z ASCII na warto�� liczbow�
		movzx	ecx, cl					; przeniesienie do ECX

		mul		dword ptr dziesiec		; EAX = EAX * 10
		add		eax, ecx				; EAX = EAX + ECX
		jmp		pobierz_znak			; powr�t do pobierania znaku

	koniec_wczytywania:


	; Odzyskanie rejestr�w i powr�t do programu
	pop		ecx
	pop		ebx
	ret
Wczytaj_EAX ENDP

; Funkcja wy�wietlaj�ca zawarto�� EAX w systemie szesnastkowym
Wyswietl_EAX_HEX	PROC
	pusha

	sub		esp, 12				; miejsce na 8 znak�w + null
	mov		edi, esp			; edi wskazuje na bufor

	; Przygotowanie do konwersji
	mov		ecx, 8				; liczba znak�w do wygenerowania -> obieg�w p�tli
	mov		esi, 1				; indeks pocz�tkowy
	mov		ebp, 0				; flaga czy same zera

	; P�tla konwersji
	ptlhex:
		; Przesuni�cie cykliczne (obr�t) rejestru EAX o 4 bity w lewo w szczeg�lno�ci, w pierwszym obiegu p�tli bity nr 31 - 28 rejestru EAX zostan� przesuni�te na pozycje 3 - 0
		rol		eax, 4

		mov		ebx, eax					; skopiowanie EAX do EBX
		and		ebx, 0000000FH				; wyizolowanie 4 najm�odszych bit�w
		mov		dl, dekoder[ebx]			; pobranie znaku z tablicy dekodera

		cmp		dl, '0'						; sprawdzenie czy znak to '0'
		jne		niezero						; je�li nie '0', to ustawienie flagi
		cmp		ebp, 0						; sprawdzenie czy flaga jest zerowa
		jne		niezero						; je�li flaga nie jest zerowa, to zapisanie '0' do bufora
		mov		dl, ' '						; je�li flaga jest zerowa, to zapisanie spacji do bufora
		jmp		zapisz_znak					; przej�cie do zapisu znaku do bufora

		niezero:
		mov		ebp, 1						; ustawienie flagi na 1 (nie same zera)

		zapisz_znak:
		mov		[edi][esi], dl				; zapisanie znaku do bufora

		dalej:
		inc		esi							; przej�cie do nast�pnej pozycji w buforze
		
		loop	ptlhex						; powr�t do pocz�tku p�tli, a� ECX = 0



	; Wpisanie znaku nowego wiersza przed i po cyfrach
	mov byte PTR [edi][0], 10
	mov byte PTR [edi][9], 10

	; W�wietlenie wyniku
	push	10				; liczba znak�w
	push	edi				; adres bufora
	push	1				; urz�dzenie 1 = ekran
	call	__write			; wy�wietlenie
	add		esp, 12			; usuni�cie parametr�w ze stosu

	add		esp, 12			; usuni�cie bufora ze stosu
	popa
	ret
Wyswietl_EAX_HEX	ENDP


_main		PROC
	
	; Wczytanie liczby do EAX
	
	; Wy�wietlenie komunikatu o wprowadzenie liczby
	mov		ecx, (OFFSET text_2) - (OFFSET text_1)	; liczba znak�w
	push	ecx

	push	OFFSET text_1							; adres tekstu
	push	1										; numer urz�dzenia -> ekran 1
	call	__write									; wy�wietelnie tekstu na konsole
	add		esp, 12									; wyczyszczenie stosu


	call	Wczytaj_EAX		; Wczytanie liczby do EAX

	call	Wyswietl_EAX_HEX	; Wy�wietlenie zawarto�ci EAX w systemie szesnastkowym

	; Zako�czenie programu
	push	0
	call	_ExitProcess@4
_main		ENDP
END	
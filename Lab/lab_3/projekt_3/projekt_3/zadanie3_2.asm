; Program wczytuje liczbê dziesiêtn¹ do EAX, a nastêpnie wyœwietla j¹ szesnastkowo


.686
.model flat

extern		__read			:PROC
extern		__write			:PROC
extern		_ExitProcess@4	:PROC
public		_main

.data
	obaszar		db	12 dup (?)			; bufor na znaki tworzonecej siê cyfry
	dziesiec	dd	10					; mno¿nik

	text_1		db	'Podaj liczbe: ', 10
	text_2		db	?

	dekoder		db	'0123456789ABCDEF'	; tablica znaków szesnastkowych


.code
; Funkcja wczytuj¹ca liczbê dziesiêtn¹ z klawiatury do rejestru EAX
Wczytaj_EAX	PROC
	; Zapisanie rejestrów, które bêdziemy u¿ywaæ
	push	ebx
	push	ecx

	; Wczytanie z klawiatury
	push	dword ptr 12				; liczba znaków
	push	dword ptr offset obaszar	; adres obszaru
	push	dword ptr 0					; urz¹dzenie 0=klawiatura
	call	__read						; wczytanie
	add		esp, 12						; usuniêcie parametrów ze stosu

	; Konwersja dziesiêtna na binarn¹
	mov		eax, 0						; zerowanie EAX (wynik)
	mov		ebx, offset obaszar			; wskaŸnik na bufor

	pobierz_znak:
		mov		cl, byte ptr [ebx]		; pobranie znaku
		inc		ebx						; przejœcie do nastêpnego znaku
		cmp		cl, 0AH					; sprawdzenie czy znak to Enter (nowa linia)
		je		koniec_wczytywania		; jeœli tak, zakoñcz wczytywanie

		sub		cl, 30H					; konwersja z ASCII na wartoœæ liczbow¹
		movzx	ecx, cl					; przeniesienie do ECX

		mul		dword ptr dziesiec		; EAX = EAX * 10
		add		eax, ecx				; EAX = EAX + ECX
		jmp		pobierz_znak			; powrót do pobierania znaku

	koniec_wczytywania:


	; Odzyskanie rejestrów i powrót do programu
	pop		ecx
	pop		ebx
	ret
Wczytaj_EAX ENDP

; Funkcja wyœwietlaj¹ca zawartoœæ EAX w systemie szesnastkowym
Wyswietl_EAX_HEX	PROC
	pusha

	sub		esp, 12				; miejsce na 8 znaków + null
	mov		edi, esp			; edi wskazuje na bufor

	; Przygotowanie do konwersji
	mov		ecx, 8				; liczba znaków do wygenerowania -> obiegów pêtli
	mov		esi, 1				; indeks pocz¹tkowy
	mov		ebp, 0				; flaga czy same zera

	; Pêtla konwersji
	ptlhex:
		; Przesuniêcie cykliczne (obrót) rejestru EAX o 4 bity w lewo w szczególnoœci, w pierwszym obiegu pêtli bity nr 31 - 28 rejestru EAX zostan¹ przesuniête na pozycje 3 - 0
		rol		eax, 4

		mov		ebx, eax					; skopiowanie EAX do EBX
		and		ebx, 0000000FH				; wyizolowanie 4 najm³odszych bitów
		mov		dl, dekoder[ebx]			; pobranie znaku z tablicy dekodera

		cmp		dl, '0'						; sprawdzenie czy znak to '0'
		jne		niezero						; jeœli nie '0', to ustawienie flagi
		cmp		ebp, 0						; sprawdzenie czy flaga jest zerowa
		jne		niezero						; jeœli flaga nie jest zerowa, to zapisanie '0' do bufora
		mov		dl, ' '						; jeœli flaga jest zerowa, to zapisanie spacji do bufora
		jmp		zapisz_znak					; przejœcie do zapisu znaku do bufora

		niezero:
		mov		ebp, 1						; ustawienie flagi na 1 (nie same zera)

		zapisz_znak:
		mov		[edi][esi], dl				; zapisanie znaku do bufora

		dalej:
		inc		esi							; przejœcie do nastêpnej pozycji w buforze
		
		loop	ptlhex						; powrót do pocz¹tku pêtli, a¿ ECX = 0



	; Wpisanie znaku nowego wiersza przed i po cyfrach
	mov byte PTR [edi][0], 10
	mov byte PTR [edi][9], 10

	; Wœwietlenie wyniku
	push	10				; liczba znaków
	push	edi				; adres bufora
	push	1				; urz¹dzenie 1 = ekran
	call	__write			; wyœwietlenie
	add		esp, 12			; usuniêcie parametrów ze stosu

	add		esp, 12			; usuniêcie bufora ze stosu
	popa
	ret
Wyswietl_EAX_HEX	ENDP


_main		PROC
	
	; Wczytanie liczby do EAX
	
	; Wyœwietlenie komunikatu o wprowadzenie liczby
	mov		ecx, (OFFSET text_2) - (OFFSET text_1)	; liczba znaków
	push	ecx

	push	OFFSET text_1							; adres tekstu
	push	1										; numer urz¹dzenia -> ekran 1
	call	__write									; wyœwietelnie tekstu na konsole
	add		esp, 12									; wyczyszczenie stosu


	call	Wczytaj_EAX		; Wczytanie liczby do EAX

	call	Wyswietl_EAX_HEX	; Wyœwietlenie zawartoœci EAX w systemie szesnastkowym

	; Zakoñczenie programu
	push	0
	call	_ExitProcess@4
_main		ENDP
END	
; Wczytywanie liczby dziesi�tnej z klawiatury � powprowadzeniu cyfr nale�y nacisn�� klawisz Enter
; Liczba po wczytaniu ma posta� binarn� w rejestrze EAX

.686
.model flat

extern		__read			:PROC
extern		__write			:PROC
extern		_ExitProcess@4	:PROC
public		_main

.data
	obaszar		db	12 dup (?)		; bufor na znaki tworzonecej si� cyfry
	dziesiec	db	10				; mno�nik
	znaki		db	12 dup (?)		; bufor na znaki tworzonecej cyfry

	text_1		db	'Podaj liczbe: ', 10
	text_2		db	'Wczytana liczba to: ',0
	text_3		db	'Kwadrat liczb wynosi: ', 10
	text_4		db	?


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

_main		PROC

	; Wy�wietlenie komunikatu o wprowadzenie liczby
	mov		ecx, (OFFSET text_2) - (OFFSET text_1)	; liczba znak�w
	push	ecx

	push	OFFSET text_1							; adres tekstu
	push	1										; numer urz�dzenia -> ekran 1
	call	__write									; wy�wietelnie tekstu na konsole
	add		esp, 12									; wyczyszczenie stosu
	
	call	Wczytaj_EAX	; Wczytanie liczby dziesi�tnej z klawiatury do EAX

	push	eax			; zachowanie warto�ci EAX
	mov		ecx, (OFFSET text_3) - (OFFSET text_2)	; liczba znak�w
	push	ecx

	push	OFFSET text_2							; adres tekstu
	push	1										; numer urz�dzenia -> ekran 1
	call	__write									; wy�wietelnie tekstu na konsole
	add		esp, 12									; wyczyszczenie stosu

	pop		eax			; przywr�cenie warto�ci EAX
	call	wyswietl_EAX	; Wy�wietlenie zawarto�ci EAX jako liczby dziesi�tnej


	; ZADANIE 3_2
	; Obliczenie kwadratu liczby w EAX
	mul		eax			; Kwadrat liczby w EAX
	push	eax			; zachowanie warto�ci EAX

	mov		ecx, (OFFSET text_4) - (OFFSET text_3)	; liczba znak�w
	push	ecx

	push	OFFSET text_3							; adres tekstu
	push	1										; numer urz�dzenia -> ekran 1
	call	__write									; wy�wietelnie tekstu na konsole
	add		esp, 12									; wyczyszczenie stosu

	pop		eax			; przywr�cenie warto�ci EAX
	call	wyswietl_EAX	; Wy�wietlenie zawarto�ci EAX jako liczby dziesi�tnej
	; Zako�czenie programu
	push	0
	call	_ExitProcess@4
_main		ENDP
END

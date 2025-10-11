; Wczytywanie liczby dziesiêtnej z klawiatury – powprowadzeniu cyfr nale¿y nacisn¹æ klawisz Enter
; Liczba po wczytaniu ma postaæ binarn¹ w rejestrze EAX

.686
.model flat

extern		__read			:PROC
extern		__write			:PROC
extern		_ExitProcess@4	:PROC
public		_main

.data
	obaszar		db	12 dup (?)		; bufor na znaki tworzonecej siê cyfry
	dziesiec	db	10				; mno¿nik
	znaki		db	12 dup (?)		; bufor na znaki tworzonecej cyfry

	text_1		db	'Podaj liczbe: ', 10
	text_2		db	'Wczytana liczba to: ',0
	text_3		db	'Kwadrat liczb wynosi: ', 10
	text_4		db	?


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

_main		PROC

	; Wyœwietlenie komunikatu o wprowadzenie liczby
	mov		ecx, (OFFSET text_2) - (OFFSET text_1)	; liczba znaków
	push	ecx

	push	OFFSET text_1							; adres tekstu
	push	1										; numer urz¹dzenia -> ekran 1
	call	__write									; wyœwietelnie tekstu na konsole
	add		esp, 12									; wyczyszczenie stosu
	
	call	Wczytaj_EAX	; Wczytanie liczby dziesiêtnej z klawiatury do EAX

	push	eax			; zachowanie wartoœci EAX
	mov		ecx, (OFFSET text_3) - (OFFSET text_2)	; liczba znaków
	push	ecx

	push	OFFSET text_2							; adres tekstu
	push	1										; numer urz¹dzenia -> ekran 1
	call	__write									; wyœwietelnie tekstu na konsole
	add		esp, 12									; wyczyszczenie stosu

	pop		eax			; przywrócenie wartoœci EAX
	call	wyswietl_EAX	; Wyœwietlenie zawartoœci EAX jako liczby dziesiêtnej


	; ZADANIE 3_2
	; Obliczenie kwadratu liczby w EAX
	mul		eax			; Kwadrat liczby w EAX
	push	eax			; zachowanie wartoœci EAX

	mov		ecx, (OFFSET text_4) - (OFFSET text_3)	; liczba znaków
	push	ecx

	push	OFFSET text_3							; adres tekstu
	push	1										; numer urz¹dzenia -> ekran 1
	call	__write									; wyœwietelnie tekstu na konsole
	add		esp, 12									; wyczyszczenie stosu

	pop		eax			; przywrócenie wartoœci EAX
	call	wyswietl_EAX	; Wyœwietlenie zawartoœci EAX jako liczby dziesiêtnej
	; Zakoñczenie programu
	push	0
	call	_ExitProcess@4
_main		ENDP
END

; Dodawanie d�ugich liczb ca�kowitych dodatnich

.686
.model flat

extern		_ExitProcess@4	: PROC
extern		__write			: PROC
extern		__read			: PROC
extern		_MessageBoxA@16	: PROC
public		_main

.data
	tekst_poczatkowy	db	10, 'Program dodaje dwie liczby calkowite dodatnie.', 10
	tekst_1				db	10, 'Podaj pierwsza liczbe i wcisnij Enter.', 10
	tekst_2				db	10, 'Podaj druga liczbe i wcisnij Enter.', 10
	tekst_3				db	?
	liczba_1			db	4 dup (?)
	liczba_2			db	4 dup (?)
	suma				db	5 dup (?), 0
	tekst_4				db	10, 'Suma dwoch liczb to: ', 10
	koniec_tekstu		db	?

.code
_main PROC

	; Wy�wietlenie pierwszego komunikatu
	mov		ecx, (OFFSET tekst_1) - (OFFSET tekst_poczatkowy)	; liczba znak�w
	push	ecx

	push	OFFSET tekst_poczatkowy								; adres tekstu
	push	1													; numer urz�dzenia -> ekran 1
	call	__write												; wy�wietlenie tekstu na konsoli
	add		esp, 12												; wyczyszczenie stosu

	; Wy�wietlenie komunikatu o wczytraniu pierwszej liczby
	mov		ecx, (OFFSET tekst_2) - (OFFSET tekst_1)			; liczba znak�w
	push	ecx

	push	OFFSET tekst_1										; adres tekstu
	push	1													; numer urz�dzenia -> ekran 1
	call	__write												; wy�wietlenie tekstu na konsoli
	add		esp, 12												; wyczyszczenie stosu


	; Czytanie pierwszej liczby z klawiatury
	push	5													; maksymalna liczba znak�w
	push	OFFSET liczba_1										; miejsce w pami�ci
	push	0													; numer urz�dzenia -> klawiatura 0
	call	__read												; czytanie znak�w z klawiatury
	add		esp, 12												; wyczyszczenie stosu

	; Wypisanie wczytanej liczby
	;push	5
	;push	offset liczba_1										; adres pierwszej liczby
	;push	1													; pierwsza liczba
	;call	__write												; wy�wietlenie pierwszej liczby
	;add		esp, 12												; wyczyszczenie stosu

	; Wy�wietlenie komuniaktu o wczytraniu drugiej liczby
	mov		ecx, (OFFSET tekst_3) - (OFFSET tekst_2)			; liczba znak�w
	push	ecx

	push	OFFSET tekst_2										; adres tekstu
	push	1													; numer urz�dzenia -> ekran 1
	call	__write												; wy�wietlenie tekstu na konsoli
	add		esp, 12												; wyczyszczenie stosu


	; Czytanie drugiej liczby z klawiatury
	push	5													; maksymalna liczba znak�w
	push	OFFSET liczba_2										; miejsce w pami�ci
	push	0													; numer urz�dzenia -> klawiatura 0
	call	__read												; czytanie znak�w z klawiatury
	add		esp, 12												; wyczyszczenie stosu

	; Wypisanie wczytanej liczby
	;push	5
	;push	offset liczba_2										; adres pierwszej liczby
	;push	1													; pierwsza liczba
	;call	__write												; wy�wietlenie pierwszej liczby
	;add		esp, 12												; wyczyszczenie stosu


	; P�tla dodawania liczb
	mov		ecx, 3												; liczba znak�w do dodania
	mov		ebx, 2												; indeks pocz�tkowy
	mov		eax, 0												; zerowanie EAX dla dodawania
	mov		edx, 0												; zerowanie przeniesienia

	ptl:
		;konwersja znak�w ASCII na liczby
		mov		al, [liczba_1 + ebx]							; wczytanie znaku z pierwszej liczby
		sub		al, '0'											; konwersja ASCII na warto�� liczbow�
		mov		ah, [liczba_2 + ebx]							; wczytanie znaku z drugiej liczby
		sub		ah, '0'											; konwersja ASCII na warto�� liczbow�
		;sprawdzenie przeniesienia
		cmp		dl, 0											; sprawdzenie, czy znak jest zerem
		jz		zero											; je�li tak, przejd� do dodawania
		;dodanie przeniesienia do pierwszej liczby
		add		al,1											; je�li nie, dodaj 1 do pierwszej liczby
		mov		dl, 0											; ustawienie przeniesienia na 0

		;dzia�anie gdy nie ma przeniesienia i po jego dodaniu
		zero:
			add		al, ah											; dodanie obu znak�w
			;sprawdzenie, czy suma przekracza 9
			cmp		al, 10											; sprawdzenie, czy suma przekracza 9
			jb		dodaj											; je�li nie, przejd� do dodawania
			;dodanie przeniesienia do nast�pnej liczby
			mov		dl, 1											; je�li tak, ustaw przeniesienie na 1
			sub		al, 10											; je�li tak, odejmij 10
			jmp		dodaj											; przej�cie do dodawania


		;zamiana liczby na ASCII i wpisanie do suma
		dodaj:
			add		al, '0'										; konwersja z powrotem na ASCII
			mov		[suma + ebx + 1], al						; zapisz wynik do sumy
			dec		ecx											; zmniejsz licznik
			dec		ebx											; przej�cie do nast�pnego znaku
			cmp		ecx, 0										; sprawdzenie, czy wszystkie znaki zosta�y dodane
			jg		ptl											; je�li tak, kontynuuj p�tl�


	cmp		dl, 0												; sprawdzenie, czy jest przeniesienie
	jz		koniec												; je�li nie, przejd� do ko�ca
	mov		[suma], '1'											; dodanie przeniesienia do sumy

koniec:
	; Wypisanie tekstu ko�cowego
	mov		ecx, (OFFSET koniec_tekstu) - (OFFSET tekst_4)		; liczba znak�w
	push	ecx

	push	offset tekst_4										; adres 
	push	1													; pierwsza liczba
	call	__write												; wy�wietlenie 
	add		esp, 12												; wyczyszczenie stosu

	; Wypisanie sumy liczb
	push	5
	push	offset suma											; adres 
	push	1													; pierwsza liczba
	call	__write												; wy�wietlenie 
	add		esp, 12												; wyczyszczenie stosu



	push	0
	call	_ExitProcess@4										; zako�czenie programu
_main ENDP
END

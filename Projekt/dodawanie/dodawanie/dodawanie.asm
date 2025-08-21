; Dodawanie d³ugich liczb ca³kowitych dodatnich

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

	; Wyœwietlenie pierwszego komunikatu
	mov		ecx, (OFFSET tekst_1) - (OFFSET tekst_poczatkowy)	; liczba znaków
	push	ecx

	push	OFFSET tekst_poczatkowy								; adres tekstu
	push	1													; numer urz¹dzenia -> ekran 1
	call	__write												; wyœwietlenie tekstu na konsoli
	add		esp, 12												; wyczyszczenie stosu

	; Wyœwietlenie komunikatu o wczytraniu pierwszej liczby
	mov		ecx, (OFFSET tekst_2) - (OFFSET tekst_1)			; liczba znaków
	push	ecx

	push	OFFSET tekst_1										; adres tekstu
	push	1													; numer urz¹dzenia -> ekran 1
	call	__write												; wyœwietlenie tekstu na konsoli
	add		esp, 12												; wyczyszczenie stosu


	; Czytanie pierwszej liczby z klawiatury
	push	5													; maksymalna liczba znaków
	push	OFFSET liczba_1										; miejsce w pamiêci
	push	0													; numer urz¹dzenia -> klawiatura 0
	call	__read												; czytanie znaków z klawiatury
	add		esp, 12												; wyczyszczenie stosu

	; Wypisanie wczytanej liczby
	;push	5
	;push	offset liczba_1										; adres pierwszej liczby
	;push	1													; pierwsza liczba
	;call	__write												; wyœwietlenie pierwszej liczby
	;add		esp, 12												; wyczyszczenie stosu

	; Wyœwietlenie komuniaktu o wczytraniu drugiej liczby
	mov		ecx, (OFFSET tekst_3) - (OFFSET tekst_2)			; liczba znaków
	push	ecx

	push	OFFSET tekst_2										; adres tekstu
	push	1													; numer urz¹dzenia -> ekran 1
	call	__write												; wyœwietlenie tekstu na konsoli
	add		esp, 12												; wyczyszczenie stosu


	; Czytanie drugiej liczby z klawiatury
	push	5													; maksymalna liczba znaków
	push	OFFSET liczba_2										; miejsce w pamiêci
	push	0													; numer urz¹dzenia -> klawiatura 0
	call	__read												; czytanie znaków z klawiatury
	add		esp, 12												; wyczyszczenie stosu

	; Wypisanie wczytanej liczby
	;push	5
	;push	offset liczba_2										; adres pierwszej liczby
	;push	1													; pierwsza liczba
	;call	__write												; wyœwietlenie pierwszej liczby
	;add		esp, 12												; wyczyszczenie stosu


	; Pêtla dodawania liczb
	mov		ecx, 3												; liczba znaków do dodania
	mov		ebx, 2												; indeks pocz¹tkowy
	mov		eax, 0												; zerowanie EAX dla dodawania
	mov		edx, 0												; zerowanie przeniesienia

	ptl:
		;konwersja znaków ASCII na liczby
		mov		al, [liczba_1 + ebx]							; wczytanie znaku z pierwszej liczby
		sub		al, '0'											; konwersja ASCII na wartoœæ liczbow¹
		mov		ah, [liczba_2 + ebx]							; wczytanie znaku z drugiej liczby
		sub		ah, '0'											; konwersja ASCII na wartoœæ liczbow¹
		;sprawdzenie przeniesienia
		cmp		dl, 0											; sprawdzenie, czy znak jest zerem
		jz		zero											; jeœli tak, przejdŸ do dodawania
		;dodanie przeniesienia do pierwszej liczby
		add		al,1											; jeœli nie, dodaj 1 do pierwszej liczby
		mov		dl, 0											; ustawienie przeniesienia na 0

		;dzia³anie gdy nie ma przeniesienia i po jego dodaniu
		zero:
			add		al, ah											; dodanie obu znaków
			;sprawdzenie, czy suma przekracza 9
			cmp		al, 10											; sprawdzenie, czy suma przekracza 9
			jb		dodaj											; jeœli nie, przejdŸ do dodawania
			;dodanie przeniesienia do nastêpnej liczby
			mov		dl, 1											; jeœli tak, ustaw przeniesienie na 1
			sub		al, 10											; jeœli tak, odejmij 10
			jmp		dodaj											; przejœcie do dodawania


		;zamiana liczby na ASCII i wpisanie do suma
		dodaj:
			add		al, '0'										; konwersja z powrotem na ASCII
			mov		[suma + ebx + 1], al						; zapisz wynik do sumy
			dec		ecx											; zmniejsz licznik
			dec		ebx											; przejœcie do nastêpnego znaku
			cmp		ecx, 0										; sprawdzenie, czy wszystkie znaki zosta³y dodane
			jg		ptl											; jeœli tak, kontynuuj pêtlê


	cmp		dl, 0												; sprawdzenie, czy jest przeniesienie
	jz		koniec												; jeœli nie, przejdŸ do koñca
	mov		[suma], '1'											; dodanie przeniesienia do sumy

koniec:
	; Wypisanie tekstu koñcowego
	mov		ecx, (OFFSET koniec_tekstu) - (OFFSET tekst_4)		; liczba znaków
	push	ecx

	push	offset tekst_4										; adres 
	push	1													; pierwsza liczba
	call	__write												; wyœwietlenie 
	add		esp, 12												; wyczyszczenie stosu

	; Wypisanie sumy liczb
	push	5
	push	offset suma											; adres 
	push	1													; pierwsza liczba
	call	__write												; wyœwietlenie 
	add		esp, 12												; wyczyszczenie stosu



	push	0
	call	_ExitProcess@4										; zakoñczenie programu
_main ENDP
END

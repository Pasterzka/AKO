; wczytywanie i wyœwietlanie tekstu wielkimi literami

.686
.model flat

extern		_ExitProcess@4	: PROC
extern		__write			: PROC
extern		__read			: PROC
public		_main

.data
	tekst_poczatkowy	db	10, 'Prosz',0A9H,' napisa',086H,' jaki',098H,' tekst i wcisn',0A5H,086H,' Enter.', 10
	koniec_tekstu		db	?
	magazyn				db	80 dup (?)
	nowa_linia			db	10
	liczba_znakow		dd	?


.code
_main PROC
	
	; Wyœwietlenie tekstu informacyjnego
	mov		ecx,(OFFSET koniec_tekstu) - (OFFSET tekst_poczatkowy)	; liczba znaków
	push	ecx

	push	OFFSET tekst_poczatkowy									; adres tekstu
	push	1														; numer urz¹dzenia -> ekran 1
	call	__write													; wyœwietelnie tekstu na konsole

	add		esp,12													; wyczyszczenie stosu


	; Czytanie wiersza z klawiatury
	push	80														; maksymalna liczba znaków
	push	OFFSET magazyn											; miejsce w pamiêci
	push	0														; numer urz¹dzenia -> klawiatura 0
	call	__read													; czytanie znaków z klawiatury

	add		esp,12													; wyczyszczenie stosu
	
	; Kody ASCII zosta³y wpisane do 'magazynu'

	; funkcja __read wpisuje do EAX liczbê wprowadzonych znaków
	mov		liczba_znakow, eax

	; Zamiana kodów na wielkie litery
	mov		ecx,eax													; rejestr ECX pe³ni rolê licznika obiegów pêtli
	mov		ebx,0													; indeks pocz¹tkowy

	ptl:
		mov		dl,magazyn[ebx]									; wczytanie znaku
		cmp		dl,165
		je		odejmij_jeden
		cmp		dl,169
		je		odejmij_jeden
		cmp		dl,228
		je		odejmij_jeden
		cmp		dl,190
		je		odejmij_jeden
		cmp		dl,152
		je		odejmij_jeden
		cmp		dl,134
		je		dodaj_dziewiec
		cmp		dl,136
		je		dodaj_dwajeden
		cmp		dl,162
		je		dodaj_szescdwa
		cmp		dl,171
		je		odejmij_trzyzero


		cmp		dl,'a'												
		jb		dalej												; skok gdy kod ascii mniejszy
		cmp		dl,'z'
		ja		dalej												; skok gdy kod ascii wiêkszy
		jmp		zmien

		odejmij_trzyzero:
			sub		dl,30
			mov		magazyn[ebx],dl										; odes³anie znaku do pamiêci
			jmp		dalej

		dodaj_szescdwa:
			add		dl,62
			mov		magazyn[ebx],dl										; odes³anie znaku do pamiêci
			jmp		dalej

		dodaj_dwajeden:
			add		dl,21
			mov		magazyn[ebx],dl										; odes³anie znaku do pamiêci
			jmp		dalej

		dodaj_dziewiec:
			add		dl,9
			mov		magazyn[ebx],dl										; odes³anie znaku do pamiêci
			jmp		dalej

		odejmij_jeden:
			sub		dl,1
			mov		magazyn[ebx],dl										; odes³anie znaku do pamiêci
			jmp		dalej

		zmien:
			sub		dl,20H												; zmiana znaku na wielk¹ literê
			mov		magazyn[ebx],dl										; odes³anie znaku do pamiêci
			jmp		dalej

		dalej:
			inc		ebx
			dec		ecx
			jnz		ptl

	; Wyœwietlenie nowego tekstu
	push	liczba_znakow
	push	OFFSET magazyn
	push	1
	call	__write

	add		esp,12


	; Zakoñczenie programu
	push	0
	call	_ExitProcess@4

_main ENDP
END
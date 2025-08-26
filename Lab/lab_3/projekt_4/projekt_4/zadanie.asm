; Program wczytuje liczbê dziesiêtn¹ do EAX, a nastêpnie wyœwietla j¹ szesnastkowo

.686
.model flat

extern		__read			:PROC
extern		__write			:PROC
extern		_ExitProcess@4	:PROC
public		_main

.data
	znaki		db	12 dup (?)			; bufor na znaki tworzonecej siê cyfry

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

; Funkcja wczytuje liczbê szesnastkow¹ z klawiatury do rejestru EAX
Wczytaj_EAX_HEX	PROC
	push ebx
	push ecx
	push edx
	push esi
	push edi
	push ebp
	
	sub		esp, 12			; miejsce na 8 znaków + null
	mov		esi, esp		; esi wskazuje na bufor

	push	dword ptr 10				; max liczba znaków
	push	esi							; adres obszaru
	push	dword ptr 0					; urz¹dzenie 0=klawiatura
	call	__read						; wczytanie
	add		esp, 12						; usuniêcie parametrów ze stosu

	mov		eax, 0			; zerowanie EAX (wynik)

	konwersja_poczatek:
		mov		dl,[esi]			; pobranie znaku
		inc		esi				; przejœcie do nastêpnego znaku
		cmp		dl, 10			; sprawdzenie czy enter
		je		gotowe			; jeœli tak, zakoñcz wczytywanie

		; Sprawdzenie czy znak jest cyfr¹
		cmp		dl, '0'
		jb		konwersja_poczatek		; jeœli mniejszy ni¿ '0', pobierz nastêpny znak
		cmp		dl, '9'
		ja		sprawdz_litery			; jeœli wiêkszy ni¿ '9', sprawdŸ czy to litera
		sub		dl, '0'					; konwersja z ASCII na wartoœæ liczbow¹

	dopisz:
		shl		eax, 4					; przesuniêcie w lewo o 4 bity (mno¿enie przez 16)
		or		al,dl					; dodanie wartoœci
		jmp		konwersja_poczatek		; pobierz nastêpny znak

	sprawdz_litery:
		cmp		dl, 'A'
		jb		konwersja_poczatek		; jeœli mniejszy ni¿ 'A', pobierz nastêpny znak
		cmp		dl, 'F'
		ja		konwersj_litery2		; jeœli wiêkszy ni¿ 'F', sprawdz male
		sub		dl, 'A' - 10			; konwersja z ASCII na wartoœæ liczbow¹ (A-F)
		jmp		dopisz

	konwersj_litery2:
		cmp		dl, 'a'
		jb		konwersja_poczatek		; jeœli mniejszy ni¿ 'a', pobierz nastêpny znak
		cmp		dl, 'f'
		ja		konwersja_poczatek		; jeœli wiêkszy ni¿ 'f', pobierz nastêpny znak
		sub		dl, 'a' - 10			; konwersja z ASCII na wartoœæ liczbow¹ (a-f)
		jmp		dopisz

	gotowe:
	; Odzyskanie rejestrów i powrót do programu
		add		esp, 12

	pop ebp
	pop edi
	pop esi
	pop edx
	pop ecx
	pop ebx
	ret
Wczytaj_EAX_HEX	ENDP

; G³ówna funkcja programu
_main		PROC
	
	call	Wczytaj_EAX_HEX

	call	wyswietl_EAX


	push	0
	call	_ExitProcess@4
_main		ENDP
END
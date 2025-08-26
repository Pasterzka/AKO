; Program wczytuje liczb� dziesi�tn� do EAX, a nast�pnie wy�wietla j� szesnastkowo

.686
.model flat

extern		__read			:PROC
extern		__write			:PROC
extern		_ExitProcess@4	:PROC
public		_main

.data
	znaki		db	12 dup (?)			; bufor na znaki tworzonecej si� cyfry

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

; Funkcja wczytuje liczb� szesnastkow� z klawiatury do rejestru EAX
Wczytaj_EAX_HEX	PROC
	push ebx
	push ecx
	push edx
	push esi
	push edi
	push ebp
	
	sub		esp, 12			; miejsce na 8 znak�w + null
	mov		esi, esp		; esi wskazuje na bufor

	push	dword ptr 10				; max liczba znak�w
	push	esi							; adres obszaru
	push	dword ptr 0					; urz�dzenie 0=klawiatura
	call	__read						; wczytanie
	add		esp, 12						; usuni�cie parametr�w ze stosu

	mov		eax, 0			; zerowanie EAX (wynik)

	konwersja_poczatek:
		mov		dl,[esi]			; pobranie znaku
		inc		esi				; przej�cie do nast�pnego znaku
		cmp		dl, 10			; sprawdzenie czy enter
		je		gotowe			; je�li tak, zako�cz wczytywanie

		; Sprawdzenie czy znak jest cyfr�
		cmp		dl, '0'
		jb		konwersja_poczatek		; je�li mniejszy ni� '0', pobierz nast�pny znak
		cmp		dl, '9'
		ja		sprawdz_litery			; je�li wi�kszy ni� '9', sprawd� czy to litera
		sub		dl, '0'					; konwersja z ASCII na warto�� liczbow�

	dopisz:
		shl		eax, 4					; przesuni�cie w lewo o 4 bity (mno�enie przez 16)
		or		al,dl					; dodanie warto�ci
		jmp		konwersja_poczatek		; pobierz nast�pny znak

	sprawdz_litery:
		cmp		dl, 'A'
		jb		konwersja_poczatek		; je�li mniejszy ni� 'A', pobierz nast�pny znak
		cmp		dl, 'F'
		ja		konwersj_litery2		; je�li wi�kszy ni� 'F', sprawdz male
		sub		dl, 'A' - 10			; konwersja z ASCII na warto�� liczbow� (A-F)
		jmp		dopisz

	konwersj_litery2:
		cmp		dl, 'a'
		jb		konwersja_poczatek		; je�li mniejszy ni� 'a', pobierz nast�pny znak
		cmp		dl, 'f'
		ja		konwersja_poczatek		; je�li wi�kszy ni� 'f', pobierz nast�pny znak
		sub		dl, 'a' - 10			; konwersja z ASCII na warto�� liczbow� (a-f)
		jmp		dopisz

	gotowe:
	; Odzyskanie rejestr�w i powr�t do programu
		add		esp, 12

	pop ebp
	pop edi
	pop esi
	pop edx
	pop ecx
	pop ebx
	ret
Wczytaj_EAX_HEX	ENDP

; G��wna funkcja programu
_main		PROC
	
	call	Wczytaj_EAX_HEX

	call	wyswietl_EAX


	push	0
	call	_ExitProcess@4
_main		ENDP
END
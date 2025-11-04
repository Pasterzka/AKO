;  Program wyczytuje liczbê 64-biow¹ w formacie hex a nastêpnie wypisuje j¹ ze wzoru

.686
.model flat

public		_main
extern		_ExitProcess@4		: PROC
extern		__read				: PROC
extern		__write				: PROC


.data
	inBuff		db	17 dup(?)	; bufor na dane wejsciowe
	outBuff		db	'0.', 8 dup(?), 0
	dziesiec    dd  10
	milion      dd  100000000          

	dekoder     db  '0123456789ABCDEF' 

.code
; WCZYTANIE DANYCH - instrukcja do labów
wczytaj PROC
	push	ebp
	mov		ebp, esp

	mov esi, OFFSET inBuff			; ustawienie wskaŸnika na pocz¹tek bufora

	; Wczytanie liczby
	push	17				; rozmiar bufora
	push	offset inBuff	; adres bufora
	push	0				; flaga (0 - standardowe wejœcie)
	call	__read
	add		esp, 12			; czyszczenie stosu

	mov  edx, 0 
	mov	 ecx, 9
	pocz_konw:
		dec		ecx
		jz		koniec_konw
		mov		bl, [esi]		; pobranie kolejnego bajtu
		inc		esi			
		cmp		bl, '0' 
		jb		pocz_konw
		cmp		bl, '9'  
		ja		sprawdzaj_dalej  
		sub		bl, '0'			; zamiana kodu ASCII na wartoœæ cyfry
		
		dopisz:
			shl		edx, 4		; przesuniêcie logiczne w lewo o 4 bity
			or		dl, bl		; dopisanie utworzonego kodu 4-bitowego
			jmp  pocz_konw

		sprawdzaj_dalej:
			cmp		bl, 'A'  
			jb		pocz_konw	; inny znak jest ignorowany  
			cmp		bl, 'F'  
			ja		sprawdzaj_dalej2  
			sub		bl, 'A' - 10	; wyznaczenie kodu binarnego  
			jmp		dopisz 

			sprawdzaj_dalej2:  
				cmp		bl, 'a'  
				jb		pocz_konw   ; inny znak jest ignorowany  
				cmp		bl, 'f'  
				ja		pocz_konw   ; inny znak jest ignorowany  
				sub		bl, 'a' - 10  
				jmp		dopisz 

	koniec_konw:

	mov  eax, 0 
	mov	 ecx, 9
	pocz_konw_2:
		dec		ecx
		jz		koniec_konw_2
		mov		bl, [esi]		; pobranie kolejnego bajtu
		inc		esi			
		cmp		bl, '0' 
		jb		pocz_konw_2
		cmp		bl, '9'  
		ja		sprawdzaj_dalej_2  
		sub		bl, '0'			; zamiana kodu ASCII na wartoœæ cyfry
		
		dopisz_2:
			shl		eax, 4		; przesuniêcie logiczne w lewo o 4 bity
			or		al, bl		; dopisanie utworzonego kodu 4-bitowego
			jmp  pocz_konw_2

		sprawdzaj_dalej_2:
			cmp		bl, 'A'  
			jb		pocz_konw_2	; inny znak jest ignorowany  
			cmp		bl, 'F'  
			ja		sprawdzaj_dalej2_2  
			sub		bl, 'A' - 10	; wyznaczenie kodu binarnego  
			jmp		dopisz_2 

			sprawdzaj_dalej2_2:  
				cmp		bl, 'a'  
				jb		pocz_konw_2   ; inny znak jest ignorowany  
				cmp		bl, 'f'  
				ja		pocz_konw_2   ; inny znak jest ignorowany  
				sub		bl, 'a' - 10  
				jmp		dopisz_2 

	koniec_konw_2:
	
	pop		ebp
	ret
wczytaj ENDP



_main PROC
    ; --- wczytanie liczby do EDX:EAX ---
    call wczytaj          ; po wykonaniu: EDX = high32, EAX = low32

    ; --- obliczenie floor((EDX:EAX * 10^8) / 2^64) bez FPU ---
    ; Zastosowane rejestry:
    ; EAX - zostanie u¿yty podczas mno¿eñ; EDX te¿ (standard dla MUL)
    ; ECX, EBX, EDI, EBP u¿yte tymczasowo

    mov     ecx, edx            ; zapamiêtaj high32 (H) w ECX
    mov     ebx, 100000000      ; mno¿nik 10^8

    ; B = L * 10^8  (L = pierwotne EAX)
    ; mul ebx -> EDX:EAX = B_hi:B_lo
    ; po mul: EAX = B_lo, EDX = B_hi
    mul     ebx                 ; mno¿enie L * 10^8
    mov     edi, eax            ; edi = B_lo
    mov     ebp, edx            ; ebp = B_hi

    ; C = H * 10^8  (H = ECX)
    mov     eax, ecx
    mul     ebx                 ; EDX:EAX = C_hi:C_lo
    mov     ecx, eax            ; ecx = C_lo
    mov     ebx, edx            ; ebx = C_hi

    ; t = (N*10^8) >> 64 = C_hi + carry, gdzie carry = (C_lo + B_hi) >> 32
    add     ecx, ebp            ; ecx = C_lo + B_hi  (ustawia flagê przeniesienia)
    setc    dl                  ; dl = CF (0 lub 1)
    movzx   edx, dl             ; edx = carry (0 lub 1)
    add     ebx, edx            ; ebx = wynik t (ca³kowity, <= 99_999_999)

    ; ebx zawiera wynik jako integer (0 .. 99_999_999)
    ; KONWERSJA NA ASCII: wpisz 8 cyfr do outBuff[2..9]. outBuff[0..1] = '0','.'
    ; u¿yj dzielenia przez 10 w pêtli

    mov     eax, ebx            ; eax = liczba do konwersji
    lea     edi, outBuff+9      ; wskaŸnik na ostatni¹ pozycjê cyfr (index 9)
    mov     ecx, 8              ; 8 cyfr do wygenerowania

konwersja_petla:
    xor     edx, edx
    mov     ebx, 10
    div     ebx                 ; EAX = EAX / 10, EDX = reszta (0..9)
    add     dl, '0'
    mov     [edi], dl
    dec     edi
    loop    konwersja_petla

    ; outBuff[0..1] to ju¿ '0' i '.' z definicji, jeœli chcesz je ustawiæ jawnie:
    ; mov byte ptr outBuff, '0'
    ; mov byte ptr outBuff+1, '.'

    ; Wyœwietlenie wyniku (10 znaków: '0.' + 8 cyfr)
    push    10
    push    offset outBuff
    push    1
    call    __write
    add     esp, 12

    ; zakoñczenie programu
    push    0
    call    _ExitProcess@4
_main ENDP
END
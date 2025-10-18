; PRORGRAM SPRAWDZA CZY PLIK JEST ZAPISANY W UTF-8


.686
.model flat

extern		_fopen			:PROC
extern		_fread			:PROC
extern		_fclose			:PROC
extern		_ExitProcess@4	:PROC
extern		_MessageBoxW@16	:PROC
public		_main

ROZMIAR_PLIKU  EQU  48

.data
	bufor		db	ROZMIAR_PLIKU dup (?)
	wynik		dw	rozmiar_pliku dup (0)
	fname		db	"test.txt", 0
	mode		db	"r", 0

	tytul_b		dw 'B','L','A','D',0
	tekst_b		dw 'T','e','k','s','t',' ','n','i','e',' ','w',' ','U','T','F','-','8',0
	tytul_p		dw 'G','I','T',0
	tekst_p		dw 'T','e','k','s','t',' ','w',' ','U','T','F','-','8',0

.code
;=== WCZYTANIE DANYCH ===
read2buf PROC

	push	offset mode
	push	offset fname
	call	_fopen
	add		esp,8

	push	eax

	push	eax				; uchwyt do pliku
	push	rozmiar_pliku	; liczba itemów
	push	1				; rozmiar itema
	push	offset bufor
	call	_fread
	add		esp,16

	call	_fclose
	add		esp,4

	ret
read2buf ENDP


;=== SPRAWDZENIE DANYCH ===
funkcja	PROC
	nastepny_bajt:
		cmp		ecx, 0		; sprawdzenie czy koniec
		je		koniec

		mov		al, [esi]

		; --- sprawdzenie czy 10xxxxxx ---
		mov		ah,al
		and		ah, 11000000b
		cmp		ah, 10000000b
		je		utf_blad
	
		; --- sprawdzenie czy 1-bajt ---
		test    al, 10000000b
		jz      bajt_jeden
		
		; --- sprawdzenie 2-bajt ---
		mov 	ah, al
		cmp		ah, 0c2h
		jb		utf_blad
		cmp		ah, 0dfh
		jbe		bajt_dwa

		; --- sprawdzenie 3-bajt ---
		mov 	ah, al
		cmp		ah, 0e0h
		jb		utf_blad
		cmp		ah, 0efh
		jbe		bajt_trzy

		; --- sprawdzenie 4-bajt ---
		mov 	ah, al
		cmp		ah, 0f0h
		jb		utf_blad
		cmp		ah, 0f7h
		jbe		bajt_cztery

		; --- sprawdzenie 5-bajt ---
		mov 	ah, al
		cmp		ah, 0f8h
		jb		utf_blad
		cmp		ah, 0fBh
		jbe		bajt_piec

		; --- sprawdzenie 6-bajt ---
		mov 	ah, al
		cmp		ah, 0fch
		jb		utf_blad
		cmp		ah, 0fdh
		jbe		bajt_szesc


		jmp		utf_blad
						
			bajt_jeden:
				dec		ecx
				inc		esi
				jmp		nastepny_bajt

			bajt_dwa:
				cmp		ecx, 2			; sprawdzenie czy znak nie przekracza rozmiaru
				jb		utf_blad


				mov     al, [esi+1]
				and     al, 11000000b
				cmp     al, 10000000b
				jne     utf_blad

				add     esi, 2
				sub     ecx, 2
				jmp     nastepny_bajt

			bajt_trzy:
				cmp     ecx, 3			; sprawdzenie czy znak nie przekracza rozmiaru
				jb      utf_blad

				mov     al, [esi+1]		; sprawdzenie czy znak zaczyna siê 10xxxxxx
				and     al, 11000000b
				cmp     al, 10000000b
				jne     utf_blad

				mov     al, [esi+2]		; sprawdzenie czy znak zaczyna siê 10xxxxxx
				and     al, 11000000b
				cmp     al, 10000000b
				jne     utf_blad

				add     esi, 3
				sub     ecx, 3
				jmp     nastepny_bajt

			bajt_cztery:
				
				cmp     ecx, 4			; sprawdzenie czy znak nie przekracza rozmiaru
				jb      utf_blad

				mov     ebx, 3
				sprawdz4:				; sprawdzenie czy znak zaczyna siê 10xxxxxx
					mov     al, [esi+ebx]
					and     al, 11000000b
					cmp     al, 10000000b
					jne     utf_blad
					dec     ebx
					jnz     sprawdz4

				add     esi, 4
				sub     ecx, 4
				jmp     nastepny_bajt

			bajt_piec:
				
				cmp     ecx, 5			; sprawdzenie czy znak nie przekracza rozmiaru
				jb      utf_blad

				mov     ebx, 4			; sprawdzenie czy znak zaczyna siê 10xxxxxx
				sprawdz5:
					mov     al, [esi+ebx]
					and     al, 11000000b
					cmp     al, 10000000b
					jne     utf_blad
					dec     ebx
					jnz     sprawdz5

				add     esi, 5
				sub     ecx, 5
				jmp     nastepny_bajt

			bajt_szesc:

				cmp     ecx, 6				; sprawdzenie czy znak nie przekracza rozmiaru
				jb      utf_blad

				mov     ebx, 5
				sprawdz6:
				
					mov     al, [esi+ebx]
					and     al, 11000000b
					cmp     al, 10000000b
					jne     utf_blad
					dec     ebx
					jnz     sprawdz6

				add     esi, 6
				sub     ecx, 6
				jmp     nastepny_bajt

	utf_blad:
		push	0
		push	offset tytul_b
		push	offset tekst_b
		push	0
		call	_MessageBoxW@16
		ret
	
	koniec:
		push	0
		push	offset tytul_p
		push	offset tekst_p
		push	0
		call	_MessageBoxW@16
		ret
funkcja ENDP

;=== FUNKCJA G£ÓWNA ===
_main	PROC
	call read2buf			; odczyt danych z pliku do obszaru oznaczonego jako bufor
	
	mov esi,offset bufor
	mov ecx,rozmiar_pliku
	
	call funkcja			; funkcja sprawdza czy plik zapisany jest w utf-8
	
	push	0
	call	_ExitProcess@4
_main	ENDP
END
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
		
		; --- sprawdzenie czy 2-bajty ---
		mov		ah, al
		and		ah, 11100000b
		cmp		ah, 11000000b
		je		bajt_dwa

		; --- sprawdzenie czy 3-bajty ---
		mov		ah, al
		and		ah, 11110000b
		cmp		ah, 11100000b
		je		bajt_trzy

		; --- sprawdzenie czy 4-bajty ---
		mov		ah, al
		and		ah, 11111000b
		cmp		ah, 11110000b
		je		bajt_cztery

		; --- sprawdzenie czy 5-bajty ---
		mov		ah, al
		and		ah, 11111100b
		cmp		ah, 11111000b
		je		bajt_piec

		; --- sprawdzenie czy 6-bajty ---
		mov		ah, al
		and		ah, 11111110b
		cmp		ah, 11111100b
		je		bajt_szesc
						
			bajt_jeden:
				dec		ecx
				inc		esi
				jmp		nastepny_bajt

			bajt_dwa:
				dec		ecx
				inc		esi

				cmp		ecx, 0			; sprawdzenie czy znak nie przekracza rozmiaru
				je		utf_blad

				mov		al,[esi]		
				and		al, 11000000b
				cmp		al, 10000000b	; sprawdzenie czy bajt zaczyna siê 110xxxxx
				jnz		utf_blad
				
				dec		ecx
				inc		esi
				jmp		nastepny_bajt

			bajt_trzy:
				dec		ecx
				inc		esi

				cmp		ecx, 0			; sprawdzenie czy znak nie przekracza rozmiaru
				je		utf_blad

				mov		al,[esi]		; sprawdzenie czy znak zaczyna siê 10xxxxxx
				and		al, 11000000b
				cmp		al, 10000000b
				jne		utf_blad

				dec		ecx
				inc		esi
				
				cmp		ecx, 0			; sprawdzenie czy znak nie przekracza rozmiaru
				je		utf_blad

				mov		al, [esi]		; sprwadzenie 
				and		al, 11000000b
				cmp		al, 10000000b
				jne		utf_blad

				dec		ecx
				inc		esi
				jmp		nastepny_bajt

			bajt_cztery:
				
				dec		ecx
				inc		esi

				cmp		ecx, 0			; sprawdzenie czy znak nie przekracza rozmiaru
				je		utf_blad

				mov		al,[esi]		; sprawdzenie czy znak zaczyna siê 10xxxxxx
				and		al, 11000000b
				cmp		al, 10000000b
				jne		utf_blad

				dec		ecx
				inc		esi
				
				cmp		ecx, 0			; sprawdzenie czy znak nie przekracza rozmiaru
				je		utf_blad

				mov		al, [esi]		; sprwadzenie 
				and		al, 11000000b
				cmp		al, 10000000b
				jne		utf_blad

				dec		ecx
				inc		esi

				cmp		ecx, 0			; sprawdzenie czy znak nie przekracza rozmiaru
				je		utf_blad

				mov		al,[esi]		; sprawdzenie czy znak zaczyna siê 10xxxxxx
				and		al, 11000000b
				cmp		al, 10000000b
				jne		utf_blad

				dec		ecx
				inc		esi
				jmp		nastepny_bajt
			
			bajt_piec:
				
				dec		ecx
				inc		esi

				cmp		ecx, 0			; sprawdzenie czy znak nie przekracza rozmiaru
				je		utf_blad

				mov		al,[esi]		; sprawdzenie czy znak zaczyna siê 10xxxxxx
				and		al, 11000000b
				cmp		al, 10000000b
				jne		utf_blad

				dec		ecx
				inc		esi
				
				cmp		ecx, 0			; sprawdzenie czy znak nie przekracza rozmiaru
				je		utf_blad

				mov		al, [esi]		; sprwadzenie 
				and		al, 11000000b
				cmp		al, 10000000b
				jne		utf_blad

				dec		ecx
				inc		esi

				cmp		ecx, 0			; sprawdzenie czy znak nie przekracza rozmiaru
				je		utf_blad

				mov		al,[esi]		; sprawdzenie czy znak zaczyna siê 10xxxxxx
				and		al, 11000000b
				cmp		al, 10000000b
				jne		utf_blad

				dec		ecx
				inc		esi

				cmp		ecx, 0			; sprawdzenie czy znak nie przekracza rozmiaru
				je		utf_blad

				mov		al,[esi]		; sprawdzenie czy znak zaczyna siê 10xxxxxx
				and		al, 11000000b
				cmp		al, 10000000b
				jne		utf_blad

				dec		ecx
				inc		esi
				jmp		nastepny_bajt


			bajt_szesc:
				
				dec		ecx
				inc		esi

				cmp		ecx, 0			; sprawdzenie czy znak nie przekracza rozmiaru
				je		utf_blad

				mov		al,[esi]		; sprawdzenie czy znak zaczyna siê 10xxxxxx
				and		al, 11000000b
				cmp		al, 10000000b
				jne		utf_blad

				dec		ecx
				inc		esi
				
				cmp		ecx, 0			; sprawdzenie czy znak nie przekracza rozmiaru
				je		utf_blad

				mov		al, [esi]		; sprwadzenie 
				and		al, 11000000b
				cmp		al, 10000000b
				jne		utf_blad

				dec		ecx
				inc		esi

				cmp		ecx, 0			; sprawdzenie czy znak nie przekracza rozmiaru
				je		utf_blad

				mov		al,[esi]		; sprawdzenie czy znak zaczyna siê 10xxxxxx
				and		al, 11000000b
				cmp		al, 10000000b
				jne		utf_blad

				dec		ecx
				inc		esi

				cmp		ecx, 0			; sprawdzenie czy znak nie przekracza rozmiaru
				je		utf_blad

				mov		al,[esi]		; sprawdzenie czy znak zaczyna siê 10xxxxxx
				and		al, 11000000b
				cmp		al, 10000000b
				jne		utf_blad

				dec		ecx
				inc		esi

				cmp		ecx, 0			; sprawdzenie czy znak nie przekracza rozmiaru
				je		utf_blad

				mov		al,[esi]		; sprawdzenie czy znak zaczyna siê 10xxxxxx
				and		al, 11000000b
				cmp		al, 10000000b
				jne		utf_blad

				dec		ecx
				inc		esi
				jmp		nastepny_bajt


	

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
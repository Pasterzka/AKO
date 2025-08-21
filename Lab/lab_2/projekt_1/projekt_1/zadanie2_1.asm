; Program przyk³adowy w trybie 32-bitowym

.686
.model flat

extern	_ExitProcess@4	:PROC
extern	__write			:PROC
public  _main

.data
	tekst	db	10, 'Nazywam si', 169 ,' Jakub Pastuszka', 10								;29
			db	'M', 162 ,'j pierwszy program assemblerowy dzia', 136 ,'a poprawnie!', 10	;52

			; POLSKIE ZNAKI TO LATIAN 2 -> wersja dziesiêtna
			
.code
_main PROC

	mov		ecx, 29+52				; dlugosc tekstu

	; Wywwolanie funkcji __write
	push	ecx						; dlugosc tekstu
	push	dword PTR OFFSET tekst	; polozenie tekstu
	push	dword PTR 1				; uchwyt urz¹zenia (stdout)
	call	__write					; wywolanie funkcji __write
	add		esp,12					; usuniecie argumentow ze stosu

	push	dword PTR 0				; kod powrotu
	call	_ExitProcess@4			; wywolanie funkcji ExitProcess

_main ENDP
END
			
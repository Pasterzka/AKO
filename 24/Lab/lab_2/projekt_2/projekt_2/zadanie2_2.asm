; Przyk³ad wywo³ywania funkcji MessageBoxA i MessageBoxW

.686
.model flat

extern _ExitProcess@4	:PROC
extern _MessageBoxA@16	:PROC
extern _MessageBoxW@16	:PROC
public _main

.data
	tytul_unicode	dw	'T','e','k','s','t',' ','w',' ','f','o','r','m','a','c','i','e',' ','U','T','F','-','1','6', 0
	tekst_unicode	dw	'K','a',017CH,'d','y',' ','z','n','a','k',' ','z','a','j','m','u','j','e',' ','1','6',' ','b','i','t',00F3H,'w', 0

	tytul_win1250	db	'Tekst w standardzie Windows 1250', 0
	tekst_win1250	db	'Ka',0BFH,'dy znak zajmuje 8 bit',0F3H,'w', 0

.code
_main PROC
	
	; Wywo³anie MessageBoxA
	push	0						; MB_OK
	push	offset tytul_win1250	; tytul
	push	offset tekst_win1250	; tekst
	push	0						; NULL
	call	_MessageBoxA@16
	add		esp, 16					; Oczyszczenie stosu

	; Wywo³anie MessageBoxW
	push	0						; MB_OK
	push	offset tytul_unicode	; tytul
	push	offset tekst_unicode			; tekst
	push	0						; NULL
	call	_MessageBoxW@16
	add		esp, 16					; Oczyszczenie stosu

	push	0						
	call	_ExitProcess@4			; Zakoñczenie programu
_main ENDP
END
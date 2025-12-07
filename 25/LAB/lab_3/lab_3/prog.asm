.686
.model flat


public		_ustaw_zmienna
extern		_GetEnvironmentVariableA@12 : PROC
extern		_SetEnvironmentVariableA@8 : PROC


.data

.code
_ustaw_zmienna	PROC
	
	; PROLOG
	push	ebp
	mov		ebp, esp

	; Rezerwacja miejsca na bufor (260 bajtów) na stosie.
	sub		esp, 8000h
	mov		esi, esp						; pocz¹tek zarezerwowanego miejsca

	push	8000h							; nSize
	push	esi								; lpBuffer

	mov		eax, [ebp+8]
	push	eax								; lpName
	call	_GetEnvironmentVariableA@12

	; je¿eli nazwa nie istnieje eax=0
	cmp		eax,0
	jz		nie_istnieje
	jmp		istnieje



	nie_istnieje:

		mov		eax, [ebp + 12]
		push	eax							; lpValue

		mov		eax, [ebp+8]
		push	eax							; lpName
		call	_SetEnvironmentVariableA@8

		cmp		eax,0
		je		blad

		mov		eax, 1
		jmp		koniec

	istnieje:
		mov		eax, 0
		jmp		koniec

	blad:
		mov		eax, -1

	koniec:
		mov		edx, 0
		sub 	esp, 8000h					; zwolnienie miejsca na stosie
		pop		ebp
		ret
_ustaw_zmienna	ENDP
END
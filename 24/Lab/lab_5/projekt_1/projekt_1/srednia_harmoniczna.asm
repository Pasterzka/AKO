.686
.model flat

public		_srednia_harmoniczna


.code
_srednia_harmoniczna		PROC
	finit

	push	ebp

	mov		ebp, esp
	mov		ecx, [ebp + 12]			; wczytanie n

	; WCZYTANIE n na stos
	;fild	dword ptr [ebp + 12]	; wczytanie n

	mov		esi, 0					; indeks tablicy
	fldz							; zerowanie sumy

	; suma odwrotno�ci
	ptl:
		mov		eax, [ebp + 8]		; wczytanie adresu tablicy
		push	eax					; zachowanie eax na stosie
		fild	dword ptr [eax+esi]	; wczytanie elementu tablicy
		add		esi, 4				; przesuni�cie do nast�pnego elementu
		add		esp, 4				; zabranie eax ze stosu


		fld1						; wczytanie 1
		fdiv	st(0), st(1)		; 1 / element tablicy
		fstp	st(1)				; usuni�cie elementu tablicy ze stosu

		faddp	st(1), st(0)		; dodanie do sumy

		loop	ptl					; powt�rzenie dla wszystkich element�w

	fild	dword ptr [ebp + 12]	; wczytanie n

	fdiv	st(0), st(1)		; n / suma odwrotno�ci
		
	
	pop		ebp
	ret
_srednia_harmoniczna		ENDP
END
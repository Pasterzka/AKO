.686
.model flat

; float simpson(float a, float b, int n)
public		_simpson


.code
; float funkcjaX(float x)
_funkcjaX proc
	; prolog
	push	ebp
	mov		ebp, esp
	sub		esp, 8
	push	ebx
	push	esi
	push	edi

	; funkcja funkcjaX(x) = x^3 * sin(x) - 5x
	push	DWORD PTR 5
	fild	DWORD PTR [esp]		; st(0) = 5
	add		esp, 4
	fld		DWORD PTR [ebp + 8]	; st(0) = x, st(1) = 5
	fmulp	st(1), st(0)		; st(0) = 5x

	fld		DWORD PTR [ebp + 8]	; st(0) = x, st(1) = 5x
	fld		DWORD PTR [ebp + 8]	; st(0) = x, st(1) = x, st(2) = 5x
	fmul	st(1), st(0)		; st(0) = x^2, st(1) = x, st(2) = 5x
	fmulp	st(1), st(0)		; st(0) = x^3, st(1) = 5x

	fld		DWORD PTR [ebp + 8]	; st(0) = x, st(1) = x^3, st(2) = 5x
	fsin						; st(0) = sin(x), st(1) = x^3, st(2) = 5x

	fmulp	st(1), st(0)		; st(0) = x^3 * sin(x), st(1) = 5x

	fxch    st(1)				; st(0) = 5x, st(1)
	fsubp						; st(0) = x^3 * sin(x) - 5x

	pop		edi
	pop		esi
	pop		ebx
	add		esp, 8
	pop		ebp
	ret 
_funkcjaX endp

; float simpson(float a, float b, int n)
_simpson	proc
	; prolog
	push	ebp
	mov		ebp, esp
	sub		esp, 32
	push	ebx
	push	esi
	push	edi

	finit


	; WALIDACJA
	; sprawdzenie czy n jest parzyste

	mov		eax, [ebp + 16]	; n
	and		eax, 1			; sprawdzanie czy ostatni bit jest 0
	cmp		eax, 0
	je		program			; n jest parzyste, kontynuuj
	jmp		error			; n jest nieparzyste, b³¹d



	program:

		; obliczanie h = (b - a) / n
		fld		DWORD PTR [ebp + 12]	; st(0) = b
		fld		DWORD PTR [ebp + 8]		; st(0) = a, st(1) = b
		fsubp	st(1), st(0)			; st(0) = b - a
		fild	DWORD PTR [ebp + 16]	; st(0) = n, st(1) = b - a
		fdivp	st(1), st(0)			; st(0) = h

		fstp	DWORD PTR [ebp-4]		; zapis h na stosie (zmienna lokalna)

		push	DWORD PTR [ebp + 8]		; a
		call	_funkcjaX
		add		esp, 4

		fstp	DWORD PTR [ebp-8]		; zapis f(a) na stosie (zmienna lokalna)

		push	DWORD PTR [ebp + 12]	; b
		call	_funkcjaX
		add		esp, 4

		fstp	DWORD PTR [ebp-12]		; zapis f(b) na stosie (zmienna lokalna)



		; suma = f(a) + f(b)
		fld		DWORD PTR [ebp-8]		; st(0) = f(a)
		fld		DWORD PTR [ebp-12]		; st(0) = f(b), st(1) = f(a)
		faddp	st(1), st(0)			; st(0) = f(a) + f(b)
		fstp	DWORD PTR [ebp-20]		; zapis suma na stosie (zmienna lokalna)


		; pêtla for i = 1 to n-1
		mov		ecx, 1
		mov		ebx, [ebp + 16]		; n
		petla:
			cmp		ecx, ebx
			jge		koniec_petli

			; x_i = a + i * h
			fld		DWORD PTR [ebp + 8]		; st(0) = a
			push	DWORD PTR ecx
			fild	DWORD PTR [esp]			; st(0) = i, st(1) = a
			add		esp, 4
			fld		DWORD PTR [ebp-4]		; st(0) = h, st(1) = i, st(2) = a
			fmulp							; st(0) = i * h, st(1) = a
			faddp							; st(0) = x_i
			fstp	DWORD PTR [ebp-16]		; zapis x_i na stosie (zmienna lokalna)

			; oblicz f(x_i)
			push	DWORD PTR [ebp-16]		; x_i
			call	_funkcjaX
			add		esp, 4

			; sprawdzanie czy i jest parzyste
			mov  	eax, ecx
			and		eax, 1
			cmp		eax, 0
			je		parzyste
			jmp		nieparzyste

			; 2*f(x_i)
			parzyste:
				push	DWORD PTR 2
				fild	DWORD PTR [esp]				; st(0) = 2, st(1) = x_i
				add		esp, 4
				fmulp								; st(0) = 2*x_i
				fld		DWORD PTR [ebp - 20]		; st(0) = f(a), st(0) = 2*x_i
				faddp								; st(0) = f(a) + 2*x_i
				fstp	DWORD PTR [ebp - 20]		; zapis suma na stosie (zmienna lokalna)
				jmp		dalej


			; 4*f(x_i)
			nieparzyste:
				push	DWORD PTR 4
				fild	DWORD PTR [esp]				; st(0) = 4, st(1) = x_i
				add		esp, 4
				fmulp								; st(0) = 4*x_i
				fld		DWORD PTR [ebp - 20]		; st(0) = f(a), st(0) = 4*x_i
				faddp								; st(0) = f(a) + 4*x_i
				fstp	DWORD PTR [ebp - 20]		; zapis suma na stosie (zmienna lokalna)
				jmp		dalej

			dalej:
				inc		ecx
				jmp		petla
				

		koniec_petli:
			push	DWORD PTR [ebp - 4]
			fld		DWORD PTR [esp]			; st(0) = h
			add		esp, 4

			push	DWORD PTR 3
			fild	DWORD PTR [esp]			; st(0) = 3, st(1) = h
			add		esp, 4
			fdivp

			fld		DWORD PTR [ebp -20]
			fmulp
			jmp		koniec


	error:
		fldz						; zwracanie 0.0 w przypadku b³êdu
		jmp 	koniec


	koniec:
		pop		edi
		pop		esi
		pop		ebx
		add		esp, 32				; ju¿ nie mov esp, ebp ;p
		pop		ebp
		ret
_simpson	endp
end

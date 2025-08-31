public		suma_siedmiu_liczb
		


.code
suma_siedmiu_liczb		PROC
	push	rbx
	mov		rbx, rsp
	push	rsi

	mov		rax, rcx		; pierwsza liczba
	add		rax, rdx		; druga liczba
	add		rax, r8			; trzecia liczba
	add		rax, r9			; czwarta liczba

	add		rax, [rbx+30h]	; pi¹ta liczba
	add		rax, [rbx+38h]	; pi¹ta liczba
	add		rax, [rbx+40h]	; pi¹ta liczba

	


	pop		rsi	
	pop		rbx
	ret
suma_siedmiu_liczb		ENDP
END

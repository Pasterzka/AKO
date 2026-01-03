; program asemblerowy demonstrujący obsługę przerwań

.386
rozkazy     SEGMENT use16
            ASSUME  cs:rozkazy

;============================================================
; procedura obslugi przerwania zegarowego
obsluga_zegara  PROC
    
    ; zachowanie używanych rejestrów
    push    ds      
    push    ax
    push    bx
    push    cx      
    push    dx     
    push    es

    ; Ustawienie ES na pamięć ekranu
    mov     ax, 0B800h
    mov     es, ax

    ; Ustawienie DS na BIOS Data Area 
    mov     ax, 0040h
    mov     ds, ax

    ; przesuniecie na koniec ekranu
    mov     bx, 3980

    ; pobranie kolumny kursora (0050h)
    mov     al, ds:[50h]
    call    wyswietl_AL

    ; spacja
    add     bx, 6
    mov     byte ptr es:[bx], ' '
    mov     byte ptr es:[bx+1], 07h
    add     bx, 2

    ; pobranie wierwsza kursora (0051h)
    mov     al, ds:[51h]
    call    wyswietl_AL

    pop     es
    pop     dx
    pop     cx
    pop     bx
    pop     ax
    pop     ds      

    jmp     dword PTR cs:wektor8

    wektor8     dd  ?

obsluga_zegara  ENDP

;============================================================
; procedura obslugi przerwania klawiaturowego
obsluga_klawiatury PROC
    push    ax
    push    bx
    push    es
    
    ; ustawienie segmentu ekranu
    mov     ax, 0B800h
    mov     es, ax

    in      al, 60h     ; odczyt kodu klawisza

    ; sprawdzenie break code i odpowiedni ruch kursora (f0h + kod klawisza)
    cmp     al, 9Eh     ; A
    je      ruch_lewo
    cmp     al, 0A0h    ; D
    je      ruch_prawo
    cmp     al, 91h     ; W
    je      ruch_gora
    cmp     al, 9Fh     ; S
    je      ruch_dol

    jmp     koniec_klaw ; Inny klawisz

    ruch_lewo:
        call    czysc_kursor                ; Czyszczenie starej pozycji kursora
        dec     word ptr cs:pos_x           ; Przesunięcie w lewo
        cmp     word ptr cs:pos_x, 0        ; Sprawdzenie granicy
        jge     rysuj_nowy                  ; Skok jeśli w granicach
        mov     word ptr cs:pos_x, 79       ; Zawijanie na koniec wiersza
        jmp     rysuj_nowy

    ruch_prawo:
        call    czysc_kursor
        inc     word ptr cs:pos_x
        cmp     word ptr cs:pos_x, 80
        jl      rysuj_nowy
        mov     word ptr cs:pos_x, 0
        jmp     rysuj_nowy

    ruch_gora:
        call    czysc_kursor
        dec     word ptr cs:pos_y
        cmp     word ptr cs:pos_y, 0
        jge     rysuj_nowy
        mov     word ptr cs:pos_y, 24   
        jmp     rysuj_nowy

    ruch_dol:
        call    czysc_kursor
        inc     word ptr cs:pos_y
        cmp     word ptr cs:pos_y, 25
        jl      rysuj_nowy
        mov     word ptr cs:pos_y, 0
        jmp     rysuj_nowy

    rysuj_nowy:
        call    oblicz_offset               ; Obliczenie offsetu nowej pozycji
        mov     byte ptr es:[bx+1], 70h     ; Ustawienie tła na inwersję
        

        ; zapisanie pozycji kursora do BIOSu -> nie wiem coś nie działa
        push    ds              
        push    ax             

        ; segment danych BIOSu
        mov     ax, 0040h       
        mov     ds, ax

        ; zapis do bios pozycji x i y
        mov     ax, cs:pos_x    
        mov     ds:[50h], al    

        mov     ax, cs:pos_y    
        mov     ds:[51h], al    

        pop     ax              
        pop     ds              
        
        jmp     koniec_klaw

    koniec_klaw:
        pop     es
        pop     bx
        pop     ax

        jmp     dword ptr cs:wektor9

    wektor9     dd  ?

    pos_x       dw  0  
    pos_y       dw  0  

    
    ; procedury pomocnicze ;/

    czysc_kursor:
        call    oblicz_offset               ; obliczenie offsetu w bx
        mov     byte ptr es:[bx+1], 07h     ; zmiana tła
        ret

    ; obliczenie offsetu kursora w pamięci ekranu
    ; wynik w bx
    oblicz_offset:
        push    ax
        push    dx
        
        mov     ax, cs:pos_y
        mov     bx, 160
        mul     bx          ; AX = Y * 160
        mov     bx, ax
        
        mov     ax, cs:pos_x
        shl     ax, 1       ; AX = X * 2
        add     bx, ax
        
        pop     dx
        pop     ax
        ret
obsluga_klawiatury ENDP

;============================================================
; procedura wyświetlania wartości AL jako liczby dziesiętnej
wyswietl_AL PROC
    push    ax
    push    cx
    push    dx

    mov     cl, 10
    mov     ah, 0

    div     cl
    add     ah, 30h
    mov     es:[bx+4], ah   ; Jedności

    mov     ah, 0
    div     cl
    add     ah, 30H
    mov     es:[bx+2], ah   ; Dziesiątki
    add     al, 30H
    mov     es:[bx+0], al   ; Setki

    mov     al, 00001111B   ; Intensywny biały
    mov     es:[bx+1],al
    mov     es:[bx+3],al
    mov     es:[bx+5],al

    pop     dx
    pop     cx
    pop     ax
    ret
wyswietl_AL ENDP

;============================================================
; program główny
zacznij:
    ; Ustawienie strony 0
    mov     al, 0
    mov     ah, 5
    int     10h

    mov     ax, 0
    mov     ds, ax

    ; odczytanie zawartości wektora nr 8 i zapisanie go w zmiennej 'wektor8' (wektor nr 8 zajmuje w pamięci 4 bajty począwszy od adresu fizycznego 8 * 4 = 32)
    
    mov     eax, ds:[32]
    mov     cs:wektor8, eax
    
    mov     ax, SEG obsluga_zegara
    mov     bx, OFFSET obsluga_zegara

    cli
    mov     ds:[32], bx
    mov     ds:[34], ax
    sti

    ; odczytanie zawartości wektora nr 9 i zapisanie go w zmiennej 'wektor9' (wektor nr 9 zajmuje w pamięci 4 bajty począwszy od adresu fizycznego 9 * 4 = 36)
    cli
    mov     eax, ds:[36]
    mov     cs:wektor9, eax

    mov     ax, SEG obsluga_klawiatury
    mov     bx, OFFSET obsluga_klawiatury

    mov     ds:[36], bx
    mov     ds:[38], ax
    sti

    ; oczekiwanie na naciśnięcie klawisza 'k'
    aktywne_oczekiwanie:
        mov     ah, 1
        int     16h
        jz      aktywne_oczekiwanie

        mov     ah, 0
        int     16h
        cmp     al, 'k'
        jne     aktywne_oczekiwanie

    ; deinstalacja procedury obsługi przerwania zegarowego
    ; odtworzenie oryginalnej zawartości wektora nr 8 i 9
    mov     eax, cs:wektor8
    cli
    mov     ds:[32], eax
    
    mov     eax, cs:wektor9
    mov     ds:[36], eax
    sti

    ; zakończenie programu
    mov     al, 0
    mov     ah, 4Ch
    int     21h

rozkazy     ENDS

nasz_stos SEGMENT stack
    db 128 dup (?)
nasz_stos ENDS

END zacznij
; prog.asm
; program sprawdza miejsce kursora tekstowego w trybie tekstowym oraz przesówa ten kursor
.386
rozkazy     SEGMENT use16
            ASSUME  cs:rozkazy

;============================================================
; procedura obslugi przerwania zegarowego
obsluga_zegara  PROC
    
    ; przechowanie używanych rejestrów
    push    ds          
    push    ax
    push    bx
    push    cx
    push    dx
    push    es

    ; Ustawnienie segmentów 
    ; B0800h - pamięć ekranu
    ; 0040:0050h - kolumna kursora
    ; 0040:0051h - wiersz kursora
    mov     ax, 0B800h
    mov     es, ax      ; Pamięć wideo
    mov     ax, 0040h
    mov     ds, ax      ; Dane BIOS

    ; Wyświetlanie w prawym dolnym rogu -> prawie xd
    mov     bx, 3980    

    ; kolumna kursora 
    mov     al, ds:[50h]    
    call    wyswietl_AL
    
    ; odstep
    add     bx, 6
    mov     byte ptr es:[bx], ' '
    mov     byte ptr es:[bx+1], 07h
    add     bx, 2

    ; wierwsz kursora
    mov     al, ds:[51h]    
    call    wyswietl_AL

    ; odtwarzanie rejestrów
    pop     es
    pop     dx
    pop     cx
    pop     bx
    pop     ax
    pop     ds          

    ; skok do oryginalnej procedury obsługi przerwania zegarowego
    jmp         dword PTR cs:wektor8

    wektor8     dd  ?
obsluga_zegara  ENDP

;============================================================
; procedura obslugi przerwania klawiaturowego
obsluga_klawiatury PROC

    ; przechowanie używanych rejestrów
    push    ax
    push    bx
    push    ds
    push    es

    ; Ustawienie ES ekran
    mov     ax, 0B800h
    mov     es, ax

    ; Odczyt z klawiatury
    in      al, 60h

    ; sprawdzenie break code -> F0h + kod klawisza
    cmp     al, 9Eh     ; A
    je      ruch_lewo
    cmp     al, 0A0h    ; D
    je      ruch_prawo
    cmp     al, 91h     ; W
    je      ruch_gora
    cmp     al, 9Fh     ; S
    je      ruch_dol
    jmp     koniec_klaw

    ; logika ruchu kursora

    ruch_lewo:
        call    czysc_tlo               ; czyszczenie tła na czarne
        dec     word ptr cs:pos_x       ; przesunięcie w lewo
        cmp     word ptr cs:pos_x, 0    ; sprawdzenie czy nie wyszliśmy za lewy brzeg
        jge     zmien_nowe_tlo          ; jeśli nie to zmiana tła
        mov     word ptr cs:pos_x, 79   ; jeśli tak to ustawienie na prawy brzeg
        jmp     zmien_nowe_tlo          ; zmiana tła kursora na nowe miejsce

    ruch_prawo:
        call    czysc_tlo
        inc     word ptr cs:pos_x
        cmp     word ptr cs:pos_x, 80
        jl      zmien_nowe_tlo
        mov     word ptr cs:pos_x, 0
        jmp     zmien_nowe_tlo

    ruch_gora:
        call    czysc_tlo
        dec     word ptr cs:pos_y
        cmp     word ptr cs:pos_y, 0
        jge     zmien_nowe_tlo
        mov     word ptr cs:pos_y, 24
        jmp     zmien_nowe_tlo

    ruch_dol:
        call    czysc_tlo
        inc     word ptr cs:pos_y
        cmp     word ptr cs:pos_y, 25
        jl      zmien_nowe_tlo
        mov     word ptr cs:pos_y, 0
        jmp     zmien_nowe_tlo

    zmien_nowe_tlo:
        call    oblicz_offset                   ; obliczenie offsetu w bx
        mov     byte ptr es:[bx+1], 70h         ; ustawienie tła na inwersję

        ; ręczna zmiana pozycji kursora w BIOSie
        mov     ax, 0040h
        mov     ds, ax
        
        mov     ax, cs:pos_x
        ;mov     ds:[50h], al    ; zapisanie x
        
        mov     ax, cs:pos_y
        ;mov     ds:[51h], al    ; xapisanie y

    koniec_klaw:
        pop     es
        pop     ds
        pop     bx
        pop     ax

        jmp     dword ptr cs:wektor9

    wektor9     dd  ?
    pos_x       dw  0
    pos_y       dw  0

    ; funkcje pomocnicze ;/

    ; ustaw tło kursora na czarne
    czysc_tlo:
        call    oblicz_offset
        mov     byte ptr es:[bx+1], 07h
        ret

    ; oblicz offset w pamięci ekranu na podstawie pozycji kursora (pos_x, pos_y) -> wynik bx
    oblicz_offset:
        push    ax
        push    dx

        ; Offset = (Y * 160) + (X * 2)
        mov     ax, cs:pos_y
        mov     bx, 160
        mul     bx
        mov     bx, ax
        mov     ax, cs:pos_x
        shl     ax, 1
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

    div     cl              ; pierwsze dzielenie
    add     ah, 30h         ; konwersja na ASCII
    mov     es:[bx+4], ah   ; zapis jednostek

    mov     ah, 0           ; zerowanie AH przed drugim dzieleniem
    div     cl              ; drugie dzielenie
    add     ah, 30H         ; konwersja na ASCII
    mov     es:[bx+2], ah   ; zapis dziesiątek

    add     al, 30H         ; konwersja na ASCII
    mov     es:[bx+0], al   ; zapis setek
    
    ; Kolor licznika
    mov     al, 0Fh         
    mov     es:[bx+1],al
    mov     es:[bx+3],al
    mov     es:[bx+5],al
    
    pop     dx
    pop     cx
    pop     ax
    ret
wyswietl_AL ENDP

;============================================================
; program głowny
zacznij:
    mov     al, 0
    mov     ah, 5
    int     10h
    
    ; Ukrycie kursora
    ;mov     ah, 1
    ;mov     ch, 20h
    ;int     10h

    mov     ax, 0
    mov     ds, ax

    ; rysowanie startowego kursora
    mov     ax, 0B800h
    mov     es, ax
    mov     bx, 0
    ; Zmieniamy tylko tła
    mov     byte ptr es:[bx+1], 70h 
    
    ; zerowanie pozycji kursora
    ;mov     ax, 0040h
    ;mov     ds, ax
    ;mov     byte ptr ds:[50h], 0
    ;mov     byte ptr ds:[51h], 0
    ;mov     ax, 0
    ;mov     ds, ax

    
    cli
    ; odczytanie zawartości wektora nr 8 i zapisanie go w zmiennej 'wektor8' (wektor nr 8 zajmuje w pamięci 4 bajty począwszy od adresu fizycznego 8 * 4 = 32)
    mov     eax, ds:[32]
    mov     cs:wektor8, eax
    mov     ax, SEG obsluga_zegara
    mov     bx, OFFSET obsluga_zegara
    mov     ds:[32], bx
    mov     ds:[34], ax

    ; odczytanie zawartości wektora nr 9 i zapisanie go w zmiennej 'wektor9' (wektor nr 9 zajmuje w pamięci 4 bajty począwszy od adresu fizycznego 9 * 4 = 36)
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
    cli
    mov     eax, cs:wektor8
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
    db 256 dup (?)
nasz_stos ENDS

END zacznij
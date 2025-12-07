#include <stdio.h>
#include <windows.h>

extern long long ustaw_zmienna(char* zmienna, char* wartosc);

int main() {
	printf("hello world\n");

    char nazwa[] = "TEST_VAR";
    char wartosc[] = "12345";
    char bufor_sprawdzajacy[260];

    long long wynik = ustaw_zmienna(nazwa, wartosc);

    if (wynik == 0) {
        printf("Zmienna istnia³a — nie zostala nadpisana.\n");
    }
    else if (wynik == 1) {
        printf("Zmienna zostala ustawiona.\n");
    }
    else {
        printf("Blad wykonania funkcji.\n");
    }

    DWORD ret = GetEnvironmentVariableA(nazwa, bufor_sprawdzajacy, 260);

    if (ret > 0) {
        printf("SUKCES: Zmienna w systemie ma wartosc: %s\n", bufor_sprawdzajacy);
    }
    else {
        printf("PORAZKA: Zmienna nie zostala odnaleziona przez Windows.\n");
    }

    long long wynik2 = ustaw_zmienna(nazwa, "23456");
    if (wynik2 == 0) {
        printf("Test nadpisywania: OK (zwrocono 0, zmienna istnieje).\n");
    }
    else {
        printf("Test nadpisywania: BLAD (zwrocono %lld).\n", wynik2);
    }


	return 0;
}
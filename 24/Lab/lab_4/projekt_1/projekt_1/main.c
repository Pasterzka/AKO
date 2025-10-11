#include <stdio.h>

int szukajmax3(int a, int b, int c);

int szukajmax4(int a, int b, int c, int d);

int main() {
	//int a, b, c, max;
	//
	//printf("Podaj trzy liczby calkowite: ");
	//scanf_s("%d %d %d", &a, &b, &c);
	//
	//
	//max = szukajmax3(a, b, c);
	//printf("Najwieksza liczba to: %d\n", max);
	//


	int wynik = szukajmax4(7, 6, 8, 4);
	printf("Najwieksza liczba to: %d\n", wynik);

	return 0;
}
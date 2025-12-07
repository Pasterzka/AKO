#define _CRT_SECURE_NO_WARNINGS

#include <stdio.h>

float simpson(float a, float b, int n);

int main() {
	float a, b;
	int n;


	printf("Wczytaj (a): ");
	scanf("%f", &a);

	printf("Wczytaj (b): ");
	scanf("%f", &b);

	printf("Wczytaj liczbe podzialow (musi byæ parzyste): ");
	scanf("%d", &n);

	// sprawdzenie parzystoœci n -> walidacja w simpson.asm
	//if (n % 2 != 0) {
	//	printf("Liczba podzialow musi byc parzysta.\n");
	//	return 1;
	//}

	float result = simpson(a, b, n);
	printf("Wynik calkowania metoda Simpsona: %f\n", result);
	return 0;
}
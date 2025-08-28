#include <stdio.h>

void odejmij_jeden(int** x);


int main() {
	int a = 5;

	int* p = &a;

	printf("Przed wywolaniem funkcji: %d\n", a);

	odejmij_jeden(&p);
	printf("Po wywolaniu funkcji: %d\n", a);
	return 0;
}
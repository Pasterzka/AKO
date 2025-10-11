// Program wywo³uje funkcje z programu.asm która za pomoc¹ kooprocesora obliczy œredni¹ harmoniczn¹ tablicy n elementów

#include <stdio.h>

float srednia_harmoniczna(int tab[], int n);

int main() {

	int n = 5;

	int tab[] = { 2, 2, 3, 4, 5 };

	printf("Srednia harmoniczna wynosi: %.2f\n", srednia_harmoniczna(tab, n));

	return 0;
}
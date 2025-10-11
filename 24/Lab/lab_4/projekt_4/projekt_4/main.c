// sortowanie b¹belkowe za pomoc¹ funkcji przestaw

#include <stdio.h>

void przestaw(int tab[], int n);

int main() {
	int tab[] = {5, 2, 8, 4, 1};
	int n = sizeof(tab) / sizeof(tab[0]);
	
	printf("Przed przestawieniem:\n");
	for(int i = 0; i < n; i++) {
		printf("%d ", tab[i]);
	}
	printf("\n");

	for (int i = n; i > 0; i--)
	{
		przestaw(tab, n);
	}
	
	
	printf("Po przestawieniu:\n");
	for(int i = 0; i < n; i++) {
		printf("%d ", tab[i]);
	}
	printf("\n");
	
	return 0;
}
#include <stdio.h>

void plus_jeden(int *a);
void przeciwna(int* a);


int main() {

	int a = 0;
	printf("Przed: %d\n", a);

	//plus_jeden(&a);
	//printf("Po: %d\n", a);
	

	przeciwna(&a);
	printf("Po: %d\n", a);

	return 0;
}
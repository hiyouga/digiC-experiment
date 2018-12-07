#include <cstdio>

using namespace std;

void dec2bin(int x)
{
	if (x > 1)
		dec2bin(x >> 1);
	printf("%d", x & 1);
}

int main()
{
	for (int i = 0; i < 128; i++) {
		printf("7'b");
		dec2bin(i);
		printf(": begin ");
		printf("Print[0] <= 8'd%d; ", i / 100 + '0');
		printf("Print[2] <= 8'd%d; ", i / 10 % 10 + '0');
		printf("Print[3] <= 8'd%d; ", i % 10 + '0');
		printf("end // %d\n", i);
	}
}
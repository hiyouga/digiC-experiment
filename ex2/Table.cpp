#include <cstdio>

int transfer(int x)
{
    int p = 1, y = 0, r;
    while (x > 0) {
        r = x & 1;
        x >>= 1;
        y += r * p;
        p *= 10;
    }
    return y;
}

int length(int n)
{
    int sum = 0;
    while (n) {
        n /= 10;
        sum++;
    }
    return sum;
}

int main()
{
	int binary;//二进制数
	int L;//二进制数长度
	int power;//幂指数

	int table[256][11];//储存8位二进制数对应表

	for(int i = 0; i < 256; i++){
		binary = transfer(i);
		L = length(binary);
		power = transfer(L-1);

		for(int j = 7; j >= 0; j--){
			table[i][j] = binary % 10;
			binary = binary / 10;
		}
		for(int j = 10; j >= 8; j--){
			table[i][j] = power % 10;
			power = power / 10;
		}
	}
	table[0][10]=0;
	//初始化完成
	for(int x = 0; x < 256; x++)
	{
		//输出移位之后的结果
		printf("8\'d%d:\tbegin ", x);
		printf("F <= 8\'b");
		for(int i = 8-length(transfer(x)); i < 8; i++)
			printf("%d",table[x][i]);
		for(int i = 0; i < 8-length(transfer(x)); i++)
			printf("%d",table[x][i]);
        printf("; P <= 3\'b");
		//输出幂指数
		for(int i = 8; i < 11; i++)
			printf("%d",table[x][i]);

		printf("; end\n");
	}

}

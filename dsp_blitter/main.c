#include <stdio.h>

extern void dspblit();

int main(int argc, char** argv)
{
	printf("blitter test\n");
	getchar();
	dspblit();
	return 0;
}

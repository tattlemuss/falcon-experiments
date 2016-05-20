#include <stdint.h>
#include <stdio.h>
#include <mint/mintbind.h>

extern int32_t dspinit();
extern int32_t dspblit();

int main(int argc, char** argv)
{
	int32_t ret;
	
	ret = Supexec(dspinit);
	//printf("blitter test\n");
	//printf("Init code: %x\n", ret);
	//getchar();
	
	while (1)
	{
		ret = Supexec(dspblit);
	}
	
	//printf("Return code: %x\n", ret);
	//getchar();
	return 0;
}

int __main()
{
	return 0;
}


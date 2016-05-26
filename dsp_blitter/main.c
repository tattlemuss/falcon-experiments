#include <stdint.h>
#include <mint/mintbind.h>

extern int32_t dspinit();
extern int32_t dspblit();
extern int32_t cpublit();
extern int32_t screenbase;		// Base screen address


int main(int argc, char** argv)
{
	int32_t ret;
	printf("blitter test\n");
	getchar();
	
	ret = Supexec(dspinit);
	
	ret = Supexec(cpublit);
	ret = save_file((void*)screenbase, 320*200*2, "CPU.DAT");
	getchar();
	ret = Supexec(dspblit);
	ret = save_file((void*)screenbase, 320*200*2, "DSP.DAT");
	getchar();
	
	return 0;
}

int save_file(void* base, int32_t size, const char* pFilename)
{
	int16_t handle;
	int32_t ret;
	
	handle = Fcreate(pFilename, 0);
	if (handle < 0)
		return handle;
	
	ret = Fwrite(handle, size, base);
	if (ret < 0)
		return ret;
	
	ret = Fclose(handle);
	return ret;
}



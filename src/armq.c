#include "../bin/armq.h"
#include <string>
#ifdef _WIN32

#include <windows.h>

BOOL APIENTRY DllMain( HMODULE hModule, DWORD  ul_reason_for_call, LPVOID lpReserved)
{
	switch (ul_reason_for_call)
	{
	case DLL_PROCESS_ATTACH:
	case DLL_THREAD_ATTACH:
	case DLL_THREAD_DETACH:
	case DLL_PROCESS_DETACH:
		break;
	}
	return TRUE;
}

extern "C"
{
  __declspec(dllexport) void __stdcall RVExtension(char *output, int outputSize, const char *function);
};
#else
#define __stdcall
#endif


void __stdcall RVExtension(char *output, int outputSize, const char *function)
{
  outputSize -= 1;
  GoString goOutput;
  goOutput.p = output;
  goOutput.n = outputSize;
  GoString goFxn;
  goFxn.p = function;
  goFxn.n = sizeof(function);
  armaSend(goOutput, 1, goFxn);
  //strncpy(output,function,outputSize);
}

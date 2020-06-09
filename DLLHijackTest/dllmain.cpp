// dllmain.cpp : Defines the entry point for the DLL application.
#include "Windows.h"
#include "write.h"

HANDLE hThread;
DWORD dwThread;

DWORD WINAPI MyThread(LPVOID lpParam)
{
    WriteToFile();
    return 0;
}

BOOL APIENTRY DllMain(HMODULE hModule,
    DWORD  ul_reason_for_call,
    LPVOID lpReserved
)
{
    switch (ul_reason_for_call)
    {
    case DLL_PROCESS_ATTACH:
        hThread = CreateThread(NULL, 0, MyThread, NULL, 0, &dwThread);
        break;
    case DLL_THREAD_ATTACH:
    case DLL_THREAD_DETACH:
    case DLL_PROCESS_DETACH:
        break;
    }
    return TRUE;
}



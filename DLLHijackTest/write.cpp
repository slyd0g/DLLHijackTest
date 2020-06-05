#include <Windows.h>

void WriteToFile()
{
	LPCWSTR outputFile = L"C:\\Users\\John\\Desktop\\results.txt";
	wchar_t path[MAX_PATH];
	HMODULE hm = NULL;

	if (GetModuleHandleEx(GET_MODULE_HANDLE_EX_FLAG_FROM_ADDRESS |
		GET_MODULE_HANDLE_EX_FLAG_UNCHANGED_REFCOUNT,
		(LPCWSTR)&WriteToFile, &hm) == 0)
	{
		int ret = GetLastError();
		return;
	}
	if (GetModuleFileName(hm, path, sizeof(path) / sizeof(wchar_t)) == 0)
	{
		int ret = GetLastError();
		return;
	}

	HANDLE hEvent, hFile, hCreateFile;
	DWORD dwBytesWritten, dwBytesToWrite;
	
	//hCreateFile = CreateFileW(outputFile, GENERIC_WRITE, NULL, NULL, CREATE_NEW, FILE_ATTRIBUTE_NORMAL, NULL);
	//CloseHandle(hCreateFile);
	hFile = CreateFileW(outputFile, FILE_APPEND_DATA, FILE_SHARE_READ, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL);

	if (hFile == INVALID_HANDLE_VALUE)
	{
		return;
	}

	dwBytesToWrite = sizeof(path) / sizeof(wchar_t);
	WriteFile(hFile, (LPVOID)path, dwBytesToWrite, &dwBytesWritten, NULL);

	CloseHandle(hFile);
}
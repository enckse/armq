/**
 * Copyright 2016
 * MIT License
 * Common plugin wrapper
 */
import plugin_definition;
import core.sys.windows.dll;
import core.sys.windows.windows;

// Print to debugview output
version(Windows)
{
extern(Windows)
{
    void OutputDebugStringA(LPCSTR lpString);
}

// DLL definition
extern(Windows) __gshared HINSTANCE g_hInst;

/**
 * Define the DLL entry point for Windows
 */
extern(Windows) BOOL DllMain(HINSTANCE hInstance,
                              ULONG ulReason,
                              LPVOID pvReserved)
{
    final switch (ulReason)
    {
        case DLL_PROCESS_ATTACH:
            g_hInst = hInstance;
            dll_process_attach(hInstance, true);
            break;
        case DLL_PROCESS_DETACH:
            dll_process_detach(hInstance, true);
            break;
        case DLL_THREAD_ATTACH:
            dll_thread_attach(true, true);
            break;
            case DLL_THREAD_DETACH:
            dll_thread_detach(true, true);
            break;
    }

    return true;
}
}

/**
 * This is the actual extension endpoint
 * cinput -> function name, input values, etc. into the extension
 * output/output_size -> output data to send out of the extension
 * |-> (should be null terminated)
 */
export extern(Windows) void RVExtension(char* output,
                        int output_size,
                        const char* cinput)
{
    pluginOperation(output, output_size, cinput);
}

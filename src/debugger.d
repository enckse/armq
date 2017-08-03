/**
 * Copyright 2017
 * MIT License
 * Debug plugin
 */
module plugin_definition;
import core.sys.windows.dll;
import core.sys.windows.windows;
import std.conv: to;
import std.string: toStringz;

// Print to debugview output
version(Windows)
{
    extern(Windows) void OutputDebugStringA(LPCSTR lpString);
}

// Posix handling
version(Posix)
{
    import core.sys.posix.syslog;
}

// Minor version number
public enum Minor = '0';

/**
 * broadcast plugin
 */
static void pluginOperation(char* output, int output_size, const char* cinput)
{
    auto status = '0';
    try
    {
        auto trace = ("arma3_debug -> " ~ to!string(cinput)).toStringz();
        status = '1';
        version(Windows)
        {
            OutputDebugStringA(trace);
        }

        version(linux)
        {
            syslog(LOG_INFO, trace);
        }

        status = '2';
    }
    catch (Exception)
    {
        status = '3';
    }

    // write to output
    output[0] = status;
    output[1] = '\0';
}

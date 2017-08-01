/**
 * Copyright 2017
 * MIT License
 * Export plugin
 */
module plugin_definition;
import definitions;
import std.conv: to;
import tcp_common;

// Minor version number
public enum Minor = '0';

/**
 * broadcast plugin
 */
static void pluginOperation(char* output, int output_size, const char* cinput)
{
    auto input = to!string(cinput);
    switch (input)
    {
        case "connect":
            write(output, output_size, "true");
            break;
        case "separator":
            write(output, output_size, "\"`\"");
            break;
        default:
            sendReceive(input, Types.Broadcast);
            break;
    }
}

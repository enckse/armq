/**
 * Copyright 2017
 * MIT License
 * Export plugin
 */
module plugin_definition;
import definitions;
import std.conv: to;
import std.string: format;
import tcp_common;

// Minor version number
public enum Minor = '0';

/**
 * broadcast plugin
 */
static void pluginOperation(char* output, int output_size, const char* cinput)
{
    auto input = to!string(cinput);
    bool hasResponse = false;
    string respond;
    switch (input)
    {
        case "connect":
            hasResponse = true;
            respond = "true";
            break;
        case "separator":
            hasResponse = true;
            respond = "\"`\"";
            break;
        default:
            break;
    }

    sendReceive(input, Types.Broadcast);
    if (hasResponse)
    {
        write(output, output_size, format("[\"ok\", %s]", respond));
    }
}

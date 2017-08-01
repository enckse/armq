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
    string respond;
    switch (input)
    {
        case "connect":
            respond = "true";
            break;
        case "separator":
            respond = "\"`\"";
            break;
        case "replay":
            respond = "\"0\"";
            break;
        case "player":
        case "event":
            respond = "\"\"";
            break;
        default:
            respond = "unknown";
            break;
    }

    sendReceive(input, Types.Broadcast);

    // NOTE: It's always 'ok' here
    write(output, output_size, format("[\"ok\", %s]", respond));
}

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
    string respond = "";
    bool hasResponse = false;
    Categories cat = Categories.None;

// r3 integration/handof
version(R3)
{
    import integrations.r3;
    respond = handle(input);
    hasResponse = true;
    cat = Categories.Integration;
}
    sendReceive(input, Types.Broadcast, cat);
    if (hasResponse && respond.length > 0)
    {
        write(output, output_size, respond);
    }
}

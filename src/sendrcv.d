/**
 * Copyright 2017
 * MIT License
 * Send/receive data
 */
module plugin_definition;
import definitions;
import std.conv: to;
import tcp_common;

// Minor version number
public enum Minor = '0';

/**
 * plugin operation
 */
static void pluginOperation(char* output, int output_size, const char* cinput)
{
    auto res = sendReceive(to!string(cinput), Types.SendRcv, Categories.None);
    write(output, output_size, res);
}

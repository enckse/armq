/**
 * Copyright 2017
 * MIT License
 * Export plugin
 */
module plugin_definition;
import definitions;
import tcp_common;

/**
 * broadcast plugin
 */
static void pluginOperation(char* output, int output_size, const char* cinput)
{
    sendReceive(cinput, Types.Broadcast);
}

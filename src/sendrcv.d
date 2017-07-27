/**
 * Copyright 2017
 * MIT License
 * Send/receive data
 */
module plugin_definition;
import definitions;
import tcp_common;

public enum Minor = '0';

/**
 * plugin operation
 */
static void pluginOperation(char* output, int output_size, const char* cinput)
{
    auto res = sendReceive(cinput, Types.SendRcv);
    auto lastIndex = -1;
    auto useLength = res.length;
    if (res.length > output_size - 1)
    {
        useLength = output_size;
    }

    for (int i = 0; i < useLength; i++)
    {
        output[i] = res[i];
        lastIndex = i;
    }

    output[lastIndex + 1] = '\0';
}

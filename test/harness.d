/**
 * Copyright 2017
 * MIT License
 * Testing harness ONLY
 */
module plugin_definition;

// required by plugin
enum Minor = "0";

// no-op, fulfill build requirement
static void pluginOperation(char* output, int output_size, const char* cinput)
{
    // noop operation
}

/// empty main, is test harness
void main(string[] args)
{
}

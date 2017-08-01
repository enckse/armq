/**
 * Copyright 2017
 * MIT License
 * R3 integration
 */
module r3_integration;
import std.string: format, split;

// Message/command delimiter
private enum Delimiter = "`";

/**
 * Handle/override r3 integration points
 */
public static string handle(string input)
{
    string[] parts = split(input, Delimiter);
    if (parts.length == 0)
    {
        return "";
    }

    string respond;
    bool raw = false;
    switch (parts[0])
    {
        case "connect":
            raw = true;
            respond = "true";
            break;
        case "separator":
            respond = Delimiter;
            break;
        case "replay":
            respond = "0";
            break;
        case "player":
        case "event":
            respond = "";
            break;
        default:
            respond = "unknown";
            break;
    }

    if (!raw)
    {
        respond = format("\"%s\"", respond);
    }

    // NOTE: always 'ok' response
    return format("[\"ok\", %s]", respond);
}

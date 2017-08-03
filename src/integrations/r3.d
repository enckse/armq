/**
 * Copyright 2017
 * MIT License
 * R3 integration
 */
module integrations.r3;
import std.datetime: Clock;
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
            auto time = Clock.currTime();
            respond = format("%s%s%s%s",
                             time.dayOfYear,
                             time.hour,
                             time.minute,
                             time.second);
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

///
unittest
{
    auto resp = handle("connect");
    assert("[\"ok\", true]" == resp);
    resp = handle("separator`test");
    assert("[\"ok\", \"`\"]" == resp);
    resp = handle("");
    assert("" == resp);
    resp = handle("player");
    assert("[\"ok\", \"\"]" == resp);
    resp = handle("event");
    assert("[\"ok\", \"\"]" == resp);
    resp = handle("command`test");
    assert("[\"ok\", \"unknown\"]" == resp);
    resp = handle("replay`abc`xyz");
    assert("[\"ok\", \"", resp[0..8]);
    assert("\"]" == resp[resp.length - 2..resp.length]);
    import std.conv: to;
    to!int(resp[9..resp.length - 2]);
}

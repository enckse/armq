/**
 * Copyright 2017
 * MIT License
 * Shared definitions
 */
module definitions;
import std.string : indexOf, join, lastIndexOf, split;

/**
 * Default send/receive TCP buffer size to use
 */
enum DefaultBuffer = 32768;

/**
 * Data categories
 */
enum Categories
{
    // No special category
    None = "n",
    // Integration category
    Integration = "i"
}

/**
 * Types of commands that can be set to the orchestration server
 */
enum Types
{
    /**
     * broadcast (bcast) -> send data, expect no response
     */
    Broadcast = "b",
    /**
     * Send/receive (sdrcv) -> send data, expect response
     */
    SendRcv = "s",
}

/**
 * Delimiter when building data packets to split control fields
 */
enum Delimiter = ":";

/**
 * When doing function parsing this splits parameters within the context
 * e.g. fxn(test|test2) -> function = fxn, params = [test, test2]
 */
enum ParamDelimiter = "|";

/**
 * Communication packet for sending messages to/from various parts via Sockets
 */
struct DataPacket
{
    /**
     * Control type identifier
     */
    string control;

    /**
     * Unique identifier
     */
    string id;

    /**
     * Packet timestmp
     */
    string timestamp;

    /**
     * data to send
     */
    string data;

    /**
     * Category to apply
     */
    string category;

    /**
     * Create a string from the packet
     */
    string str()
    {
        return this.control ~ Delimiter ~
               this.id ~ Delimiter ~
               this.timestamp ~ Delimiter ~
               this.category ~ Delimiter ~
               this.data;
    }

    /**
     * Create a data packet
     */
    static DataPacket* create(Types type, Categories category, string data)
    {
        import std.conv: to;
        import std.datetime: Clock;
        import std.uuid;
        auto packet = new DataPacket();
        packet.control = type;
        packet.data = data;
        packet.timestamp = to!string(Clock.currStdTime());
        packet.id = to!string(randomUUID());
        packet.category = category;
        return packet;
    }

    /// create a packet
    unittest
    {
        auto pck = DataPacket.create(Types.Broadcast, Categories.None, "test");
        import std.conv: to;
        auto str = pck.str();
        for (int idx = 0; idx < str.length; idx++)
        {
            auto ch = str[idx];
            if ((idx > 1 && idx < 10) ||
                (idx > 10 && idx < 15) ||
                (idx > 15 && idx < 20) ||
                (idx > 25 && idx < 38) ||
                (idx > 20 && idx < 25))
            {
                if (!((ch <= '9' && ch >= '0') || (ch >= 'a' && ch <= 'f')))
                {
                    assert(false, "invalid uuid char: " ~ to!string(idx));
                }

                continue;
            }

            if (idx > 38 && idx < 57)
            {
                if (!(ch >= '0' && ch <= '9'))
                {
                    assert(false, "invalid time char: " ~ to!string(idx));
                }

                continue;
            }

            if (idx > 59)
            {
                assert("test" == str[idx..str.length]);
                break;
            }

            char[int] asserting;
            asserting[0] = 'b';
            asserting[1] = ':';
            asserting[38] = ':';
            asserting[57] = ':';
            asserting[59] = ':';
            asserting[10] = '-';
            asserting[15] = '-';
            asserting[20] = '-';
            asserting[25] = '-';
            asserting[58] = 'n';
            if (idx in asserting)
            {
                assert(asserting[idx] == ch);
            }
            else
            {
                assert(false, "idx, char " ~ to!string(idx) ~ "," ~ ch);
            }
        }
    }
}

/**
 * Write to output a response
 */
public static void write(char* output, int output_size, string res)
{
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

/// writing to out
unittest
{
    char[] buffer = "1234567890abc".dup;
    buffer ~= '\0';
    write(buffer.ptr, 10, "blahblahblah");
    string data = cast(string)buffer;
    import std.stdio;
    assert(data[0..11] == "blahblahbl\0");
}

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
        assert("", pck.str());
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
    import std.string: toStringz;
    char* output = toStringz("1234567890");
    write(output, 10, "blah");
}

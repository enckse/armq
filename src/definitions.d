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
 * Types of commands that can be set to the orchestration server
 */
enum Types
{
    /**
     * broadcast (bcast) -> send data, expect no response
     */
    Broadcast = 0,
    /**
     * Send/receive (sdrcv) -> send data, expect response
     */
    SendRcv = 1,
}

/**
 * Delimiter when building data packets to split control fields
 */
enum Delimiter = ":";

/**
 * Short names for each listed enum type
 */
// broadcast commands
enum BroadcastData = "bcast";

// send/receive commands
enum SendRcvData = "sdrcv";

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
     * Control type string
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
     * Create a string from the packet
     */
    string str()
    {
        return this.control ~ Delimiter ~
               this.id ~ Delimiter ~
               this.timestamp ~ Delimiter ~
               this.data;
    }

    /**
     * Create a data packet
     */
    static DataPacket* create(string control, string data)
    {
        import std.conv: to;
        import std.uuid;
        auto packet = new DataPacket();
        packet.control = control;
        packet.data = data;
        packet.id = to!string(randomUUID());
        return packet;
    }
}

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

/**
 * Copyright 2017
 * MIT License
 * Shared definitions
 */
module definitions;
import std.string : indexOf, join, lastIndexOf, split;

/**
 * Keyword when a module does a no-op
 */
enum Noop = "noop";

/**
 * Default send/receive TCP buffer size to use
 */
enum DefaultBuffer = 32768;

/**
 * Location where the listener/orchestration is sitting
 */
enum BindAddress = "localhost";

/**
 * Port on the bound address to communicate over
 */
enum Port = 5555;

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
    /**
     * admin (admin) -> send administrative commands, no response
     */
    Admin = 2
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

// admin commands
enum AdminData = "admin";

/**
 * Admin controls available
 */

// shutdown the serve
enum AdminShutdown = "shutdown";

// flush worker context
enum AdminFlush = "flush";

// reset worker context
enum AdminReset = "reset";

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
     * Indicates if the packet is valid
     */
    bool valid;

    /**
     * When parsed, the function name
     */
    string fxn;

    /**
     * When parsed, the function parameters
     */
    string[] params;

    /**
     * Indicates the packet (when parsed) is a function call
     */
    bool isFxn;

    /**
     * Admin request
     */
    bool isAdmin;

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
    static DataPacket* create(string control, const char* data)
    {
        import std.conv: to;
        import std.datetime;
        import std.uuid;
        auto packet = new DataPacket();
        packet.control = control;
        packet.data = to!string(data);
        packet.id = to!string(randomUUID());
        packet.timestamp = to!string(Clock.currStdTime());
        return packet;
    }

    /**
     * Build a packet from an input string
     */
    static DataPacket* packet(string input)
    {
        auto packet = new DataPacket();
        packet.valid = false;
        packet.isAdmin = false;
        auto parts = input.split(Delimiter);
        if (parts.length >= 4)
        {
            packet.valid = true;
            packet.control = parts[0];
            packet.id = parts[1];
            packet.timestamp = parts[2];
            packet.data = parts[3..parts.length].join(Delimiter);
        }

        return packet;
    }

    /**
     * Data parsing for the packet
     * e.g. pulling function call information from the packet
     */
    void parse()
    {
        if (!this.valid)
        {
            return;
        }

        auto idx = this.data.indexOf("(");
        auto end = this.data.lastIndexOf(")");
        this.isFxn = false;
        if (idx > 0 && end > 0 && end > idx)
        {
            this.fxn = this.data[0 .. idx ];
            auto params = this.data[idx + 1 .. end ];
            this.params = params.split(ParamDelimiter);
            this.isFxn = true;
        }
    }
}

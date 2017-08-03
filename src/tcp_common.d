/**
 * Copyright 2017
 * MIT License
 * TCP socket common
 */
module tcp_common;
import definitions;
import std.socket;
import vars;

// response indicator
enum Response = "resp:";

// error response
enum ErrorResponse = Response ~ "error";

// ack/ok response
enum OkResponse = Response ~ "ok";

/**
 * Socket wrappers
 */
private interface ISocket
{
    // Connecting to a socket
    void connect(InternetAddress);

    // sending data
    void send(string);

    // receiving data
    ptrdiff_t receive(char[]);
}

/**
 * Normal socket
 */
private class NormalSocket : ISocket
{
    // Backing real socket
    private Socket sock;

    // create a socket
    public this()
    {
        this.sock = new Socket(AddressFamily.INET,
                               SocketType.STREAM,
                               ProtocolType.TCP);
    }

    // connect to a socket
    public void connect(InternetAddress addr)
    {
        this.sock.connect(addr);
    }

    // send data
    public void send(string send)
    {
        this.sock.send(send);
    }

    // receive data
    public ptrdiff_t receive(char[] buffer)
    {
        return this.sock.receive(buffer);
    }
}

/**
 * Create the socket type we need
 */
static ISocket newSocket()
{
    return new NormalSocket();
}

/**
 * send/receive requests
 */
static string sendReceive(string send, Types type, Categories category)
{
    return sendReceiveSocket(send, type, category, &newSocket);
}

/**
 * Socket comms
 */
static string sendReceiveSocket(string send,
                                Types type,
                                Categories category,
                                ISocket function() factory)
{
    import std.conv: to;
    try
    {
        auto socket = newSocket();
        socket.connect(new InternetAddress(Host, Port));
        auto packet = DataPacket.create(type, category, send);
        socket.send(packet.str);
        string resp = OkResponse;
        switch (type)
        {
            case Types.SendRcv:
                char[DefaultBuffer] buffer;
                auto received = socket.receive(buffer);
                resp = to!string(buffer[0 .. received ]);
                break;
            default:
                break;
        }

        return resp;
    }
    catch (Exception)
    {
        return ErrorResponse;
    }
}

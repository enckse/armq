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
 * send/receive requests
 */
static string sendReceive(string send, Types type, Categories category)
{
    return sendReceiveData(send, type, category, new NormalSocket());
}

/**
 * Send and receive data on a socket
 */
private static string sendReceiveData(string send,
                                      Types type,
                                      Categories category,
                                      ISocket socket)
{
    import std.conv: to;
    try
    {
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

///
unittest
{
    import std.conv: to;

    // mock implementation
    class MockSocket : ISocket
    {
        // calls requested
        @property public string[] calls;

        // mock connect
        void connect(InternetAddress addr)
        {
            calls ~= "connect";
        }

        // mock send
        void send(string data)
        {
            calls ~= "send";
        }

        // mock receive
        ptrdiff_t receive(char[] buffer)
        {
            calls ~= "receive";
            buffer[0] = 'a';
            buffer[1] = 'c';
            buffer[2] = 'k';
            return 3;
        }
    }

    auto s = new MockSocket();
    auto resp = sendReceiveData("test", Types.Broadcast, Categories.None, s);
    assert("resp:ok" == resp);
    assert(2 == s.calls.length);
    assert("connect" == s.calls[0]);
    assert("send" == s.calls[1]);
    s = new MockSocket();
    resp = sendReceiveData("test", Types.SendRcv, Categories.Integration, s);
    assert("ack" == resp);
    assert(3 == s.calls.length);
    assert("connect" == s.calls[0]);
    assert("send" == s.calls[1]);
    assert("receive" == s.calls[2]);
}

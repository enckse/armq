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
 * Create the socket type we need
 */
static Socket newSocket()
{
    return new Socket(AddressFamily.INET, SocketType.STREAM, ProtocolType.TCP);
}

/**
 * send/receive requests
 */
static string sendReceive(string send, Types type, Categories category)
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

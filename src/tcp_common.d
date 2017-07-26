/**
 * Copyright 2017
 * MIT License
 * TCP socket common
 */
module tcp_common;
import definitions;
import std.socket;

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
static string sendReceive(const char* send, Types type)
{
    import std.conv: to;
    try
    {
        ushort port = cast(ushort)type;
        auto socket = newSocket();
        auto ctrl = "none";
        switch (type)
        {
            case Types.SendRcv:
                ctrl = SendRcvData;
                break;
            case Types.Broadcast:
                ctrl = BroadcastData;
                break;
            default:
                break;
        }

        if (ctrl.length != 5)
        {
            throw new Exception("unknown control type");
        }

        socket.connect(new InternetAddress(BindAddress, Port));
        auto packet = DataPacket.create(ctrl, send);
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

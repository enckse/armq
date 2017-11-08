armq
===

ARMA3 output extensions for message queuing and information passing

# build

[![Build Status](https://travis-ci.org/enckse/armq.svg?branch=master)](https://travis-ci.org/enckse/armq)

supported targets:
* linux 32-bit or 64-bit (depending on installed architecture)

```
make
```

to compile with a different port or specify version
```
make VERSION=1.0 PORT=1234
```

# Receiving

An example receiver in python (using zmq STREAM)
```
import zmq

if __name__ == '__main__':

    context = zmq.Context()
    socket = context.socket(zmq.STREAM)
    socket.bind("tcp://*:5555")

    while True:
        clientid, rcv = socket.recv_multipart()
        print("id: %r" %clientid)
        print(rcv.decode('utf-8'))
        socket.send_multipart([clientid, "ack".encode("utf-8")])
```

simple sockets
```
import socket

if __name__ == '__main__':
    serversocket = socket.socket(ocket.AF_INET, socket.SOCK_STREAM)
    serversocket.bind(("127.0.0.1", 5000))
    serversocket.listen(5)
    while 1:
        (clientsocket, address) = serversocket.accept()
        run = True
        while run:
            recvd = clientsocket.recv(1024)
            if recvd is None or len(recvd) == 0:
                run = False
            else:
                print(recvd)
```

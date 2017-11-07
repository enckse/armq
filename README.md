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


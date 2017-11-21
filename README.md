armq
===

ARMA3 output extensions for message queuing and information passing

# build

[![Build Status](https://travis-ci.org/enckse/armq.svg?branch=master)](https://travis-ci.org/enckse/armq)

supported targets:
* linux 32-bit (that's all arma3 dedicated server supports on linux today)

```
make
```

to compile with a different port
```
make DC_PORT=1234 SC_PORT
```

## adc

Is intended to pass event/game data out for visualization/post-hoc analysis

## sc

Simple sends all messages received out to a socket which is intended to integrate a pipeline of operations

## Arch

On archlinux, enable the multilib repository:

```
pacman -S gcc-multilib
```

# Receiving

An example using sockets
```
import socket

if __name__ == '__main__':
    serversocket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    serversocket.bind(("127.0.0.1", 5000)) # or port 5001 for simple commands
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

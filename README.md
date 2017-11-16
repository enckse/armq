armq
===

ARMA3 output extensions for message queuing and information passing

# build

[![Build Status](https://travis-ci.org/enckse/armq.svg?branch=master)](https://travis-ci.org/enckse/armq)

supported targets:
* linux 32-bit (that's all arma3 dedicated server supports on linux today)

```
make PREFIX=production
```

to compile with a different port
```
make PORT=1234
```

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

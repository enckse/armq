armq
===

ARMA3 output extensions for message queuing and information passing

# build

[![Build Status](https://travis-ci.org/enckse/armq.svg?branch=master)](https://travis-ci.org/enckse/armq)

supported targets:
* windows 32-bit (requires `wine` and `DMD` variable pointing to `dmd.exe`)
* windows 64-bit (requires a helper `dmd64` to use MSFT `link.exe` and friends)
* linux 64-bit

first
```
./configure
```

to hit all support targets
```
make
```

for just win32
```
make win32
```

for just win64

```
make win64
```

and just linux 64
```
make linux64
```

to switch out and use this instead of the default [r3](https://github.com/alexcroox/r3)
```
ARMQ_HOST="localhost" ./configure r3
```

## customize naming

custom naming can be achieved via rename (`sed` conventions)
```
RENAMES="s/broadcast/mybrdcst/g" ./configure
```

## disable

to disable certain objects (`sed` conventions)
```
DISABLE="s/broadcast//g" ./configure
```

## wine dmd builds

to enable 32-bit wine based builds
```
DMD=/path/to/dmd.exe ./configure
```

to enable 64-bit wine based builds one must setup the MSFT stack for wine to use `link.exe` and have some wrapper script `dmd64`, picked up by
```
./configure
```

# plugins

## broadcast

send data broadcasts out

## sendrcv

send and receive data/commands

## debugger

print to debugging trace

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

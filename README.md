armq
===

ARMA3 output extensions for message queuing and information passing

# build

[![Build Status](https://travis-ci.org/enckse/armq.svg?branch=master)](https://travis-ci.org/enckse/armq)

supported targets:
* linux 32-bit (that's all arma3 dedicated server supports on linux today)

to compile using `/dev/shm/armq/` for output
```
make
```

to compile with a different port using sockets
```
make SOCKETS=1 PORT=1234
```

## adc

Is intended to pass event/game data out for visualization/post-hoc analysis

## Arch

On archlinux

```
pacman -S lib32-gcc-libs
```

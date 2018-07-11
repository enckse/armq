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

## Arch

On archlinux

```
pacman -S lib32-gcc-libs
```

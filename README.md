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

# plugins

## broadcast

send data broadcasts out

## sendrcv

send and receive data/commands

## debug

print to debugging trace

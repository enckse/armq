arma-rust-plugin
===
provides a proof-of-concept arma plugin implemented in rust to send data over tcp

# building

assuming usage of rustup is known and that we're doing this from Arch Linux, make sure to add `--release` for release builds

[![Build Status](https://travis-ci.org/enckse/arma-rust-plugin.svg?branch=master)](https://travis-ci.org/enckse/arma-rust-plugin)


## tcp

to change the tcp connection locatoin
```
make TCP="192.168.1.100:5555"
```

## linux


### 64-bit

```
make ARCH=x86_64-unknown-linux-gnu
```

### 32-bit

**NOTE: this may not be applicable but for full coverage**

```
make ARCH=i686-unknown-linux-gnu
```

## windows

from linux (making sure mingw is installed)

### 32-bit (mingw)

```
vim ~/.cargo/config
---
[target.i686-pc-windows-gnu]
linker = "i686-w64-mingw32-gcc"
rustflags = "-C panic=abort"
```

```
make ARCH=i686-pc-windows-gnu
```

### 64-bit (mingw)

```
vim ~/.cargo/config
---
[target.x86_64-pc-windows-gnu]
linker = "x86_64-w64-mingw32-gcc"
```

```
mark ARCH=x86_64-pc-windows-gnu
```

arma-rust-plugin
===
provides a proof-of-concept arma plugin implemented in rust

# building

assuming usage of rustup is known and that we're doing this from Arch Linux, make sure to add `--release` for release builds

## linux


### 64-bit

cargo it
```
cargo build --target=x86_64-unknown-linux-gnu
```

### 32-bit

**NOTE: this may not be applicable but for full coverage**

cargo it
```
cargo build --target=i686-unknown-linux-gnu
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

cargo it
```
cargo build --target=i686-pc-windows-gnu
```

### 64-bit (mingw)

```
vim ~/.cargo/config
---
[target.x86_64-pc-windows-gnu]
linker = "x86_64-w64-mingw32-gcc"
```

cargo it
```
cargo build --target=x86_64-pc-windows-gnu
```

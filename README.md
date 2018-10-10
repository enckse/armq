armq
===

ARMA3 output extensions for message queuing and information passing

# build

supported targets:
* linux 32-bit (that's all arma3 dedicated server supports on linux today)

to compile using `/opt/armq/` for output
```
make
```

to a different folder
```
make WPATH="\\\"/var/cache/armq/\\\""
```

to compile with a different port using sockets (default port is 5000)
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

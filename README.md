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

requires the following packages on debian to build:

* libc6-dev-i386
* gcc-multilib
* g++-multilib 

to a different folder
```
make WPATH="\\\"/var/cache/armq/\\\""
```

to compile with a different port using sockets (default port is 5000)
```
make SOCKETS=1 PORT=1234
```

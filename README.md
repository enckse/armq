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

**RECOMMENDATION:** wherever armq is running the `/opt/armq` or alternative path should be a memory-backed store (e.g. tmpfs)

requires the following packages on debian to build:

* libc6-dev-i386
* gcc-multilib
* g++-multilib 

to a different folder
```
make WPATH="\\\"/var/cache/armq/\\\""
```

BIN=bin
.PHONY: all

build-lib = $1 CC=$2 GOOS=$3 go build -o $(BIN)/armq.a -buildmode=c-archive src/armq.go

all: clean

linux: 
#	g++ -shared -pthread -o bin/arma.so src/armq.c bin/armq.a

windows: 
	$(call build-lib,CGO_ENABLED=1,x86_64-w64-mingw32-gcc,windows)
	x86_64-w64-mingw32-g++ -shared -pthread -o bin/armq.dll src/armq.c bin/armq.a

clean:
	rm -rf $(BIN)
	mkdir -p $(BIN)

PORT=5000
IP="127.0.0.1"
VERSION="__VERSION__"
BIN=bin/
SRC=src/

all: clean build

clean:
	rm -rf $(BIN)

build:
	mkdir -p $(BIN)
	gcc -shared -DVERSION=$(VERSION) -DPORT=$(PORT) -o $(BIN)r3_extension.so -fPIC $(SRC)client.c

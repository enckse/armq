PORT=5000
IP="127.0.0.1"
VERSION="__VERSION__"
BIN=bin/
SRC=src/
ARCH=$(shell file /usr/bin/gcc | cut -d ":" -f 2 | cut -d " " -f 3 | cut -d "-" -f 1)
FLAGS=-DVERSION=$(VERSION) -DPORT=$(PORT) -m$(ARCH)

all: clean build

clean:
	rm -rf $(BIN)

build:
	mkdir -p $(BIN)
	gcc -shared $(FLAGS) -o $(BIN)r3_extension.so -fPIC $(SRC)client.c
	gcc -DDEBUG -DHARNESS $(FLAGS) $(SRC)client.c -o $(BIN)/harness

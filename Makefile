PORT=5000
IP="127.0.0.1"
VERSION="__VERSION__"
BIN=bin/
SRC=src/
FLAGS=-DVERSION=$(VERSION) -DPORT=$(PORT)

all: clean build

clean:
	rm -rf $(BIN)

build:
	mkdir -p $(BIN)
	gcc -shared $(FLAGS) -o $(BIN)r3_extension.so -fPIC $(SRC)client.c
	gcc -DHARNESS $(FLAGS) $(SRC)client.c -o $(BIN)/harness

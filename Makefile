PORT=5000
IP="127.0.0.1"
BIN=bin/
SRC=src/
ARCH=32
FLAGS=-DPORT=$(PORT) -m$(ARCH)

all: clean build

clean:
	rm -rf $(BIN)

build:
	mkdir -p $(BIN)
	gcc -shared $(FLAGS) -o $(BIN)adc_extension.so -fPIC $(SRC)client.c
	gcc -DDEBUG -DHARNESS $(FLAGS) $(SRC)client.c -o $(BIN)/harness

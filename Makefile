DC_PORT=5000
BIN=bin/
SRC=src/
ARCH=32
FLAGS=-DPORT=$(DC_PORT) -m$(ARCH)
GCC=gcc

build = $(GCC) -shared $1 -m$(ARCH) -DPORT=$2 -o $(BIN)$3_extension.so -fPIC $(SRC)client.c; \
		$(GCC) $1 -DDEBUG -DHARNESS -DPORT=$2 -o $(BIN)/$3_harness $(SRC)client.c

all: clean build

clean:
	rm -rf $(BIN)

build:
	mkdir -p $(BIN)
	$(call build,,$(DC_PORT),adc)

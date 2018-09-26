PORT    := 5000
BIN     := bin/
ARCH    := 32
FLAGS   := -DPORT=$(PORT) -m$(ARCH) src/client.cpp -o $(BIN)adc_
ifeq ($(SOCKETS),1)
	FLAGS := -DSOCKET=1 $(FLAGS)
endif
GCC     := g++
SHARED  := $(GCC) -shared -fPIC $(FLAGS)extension.so
HARNESS := $(GCC) -DDEBUG -DHARNESS $(FLAGS)harness

all: clean build

clean:
	rm -rf $(BIN)
	mkdir -p $(BIN)

build:
	$(SHARED)
	$(HARNESS)

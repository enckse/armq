PORT    := 5000
WPATH   := "\"/opt/armq/\""
BIN     := bin/
ARCH    := 32
FLAGS   := -DPORT=$(PORT) -DFILEPATH=$(WPATH) -m$(ARCH) src/client.cpp -o $(BIN)adc_
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

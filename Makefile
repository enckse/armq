PORT=5000
IP="127.0.0.1"
BIN=bin/
SRC=src/
VAR=$(SRC)vars.h
ARCH=32
FLAGS=-m$(ARCH)

all: clean build

clean:
	rm -rf $(BIN)
	rm -f $(VAR)

build:
ifndef PREFIX
	$(error PREFIX is not set)
endif
	mkdir -p $(BIN)
	$(shell echo '#define PORT '$(PORT) > $(VAR))
	$(shell echo '#define PREFIX "'$(PREFIX)'"' >> $(VAR))
	gcc -shared $(FLAGS) -o $(BIN)adc_extension.so -fPIC $(SRC)client.c
	gcc -DDEBUG -DHARNESS $(FLAGS) $(SRC)client.c -o $(BIN)/harness

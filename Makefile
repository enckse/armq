ARCH=x86_64-unknown-linux-gnu
BIN=target
.PHONY: all

all: clean
	cargo build --target=$(ARCH) --release

clean:
	rm -rf $(BIN)

ARCH=x86_64-unknown-linux-gnu
TCP="127.0.0.1:7777"
TCP_RS=src/tcpconn.rs
BIN=target
.PHONY: all

all: clean
	$(shell echo "pub const TCP_LOCATION: &'static str = \"$(TCP)\";" > $(TCP_RS))
	cargo build --target=$(ARCH) --release

clean:
	rm -rf $(BIN)/release
	rm -rf $(BIN)/debug

REP="s/\//\\\\\\\\/g"
SRC=$(shell find src/ -name "*.d" | grep -v -E "broadcast.d|sendrcv.d|debugger.d")
WINSRC=$(shell echo $(SRC) | sed -e $(REP))
BIN=bin/
WIN32=$(BIN)win32/
WIN64=$(BIN)win64/
LIN64=$(BIN)lin64/

.PHONY: all

dmdx64 = dmd -m64 -defaultlib=libphobos2.so -fPIC -shared -of$(LIN64)/$1.so $(SRC) src/$1.d
wine32 = wine $(DMD) -m32 -of$(WIN32)$1.dll $(WINSRC) src\\$1.d
wine64 = dmd64 -of$(WIN64)$1.dll src\\$1.d $(WINSRC) defs\\$1.def
building = $(call $1,broadcast); \
		   $(call $1,sendrcv); \
		   $(call $1,debugger);

all: clean linux64 win32 win64

target:
	$(call building,$(TYPE))

win32:
ifndef DMD
	$(error "please define a value for dmd.exe")
endif
	make target TYPE=wine32

win64:
	make target TYPE=wine64

linux64:
	make target TYPE=dmdx64

clean:
	rm -rf $(BIN)
	mkdir -p $(BIN)
	mkdir -p $(WIN32)
	mkdir -p $(WIN64)
	mkdir -p $(LIN64)

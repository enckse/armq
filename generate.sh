#!/bin/bash
BRD="broadcast"
SND="sendrcv"
DBG="debugger"
ALL="$BRD $SND $DBG"
SKIP=$(echo $ALL | sed "s/ /.d|/g")".d"
DEFS=defs/
mkdir -p $DEFS
VARSD=vars.d
SRCDIR="src/"
VARS=${DEFS}$VARSD
INTEGRATE="integrations"
SRC=$(find $SRCDIR -type f -name "*.d" | grep -v -E "$SKIP" | grep -v "$INTEGRATE" | tr '\n' ' ')
if [ ! -z "$ARMQ_INTEGRATE" ]; then
    _integrate_file=$SRCDIR$INTEGRATE/${ARMQ_INTEGRATE}.d
    if [ -e $_integrate_file ]; then
        SRC=$SRC" "$_integrate_file
    fi
fi
SRC=$SRC" "$VARS
WINSRC=$(echo $SRC | sed -e "s/\//\\\\\\\\/g")
BIN=bin
WIN32=$BIN/win32/
WIN64=$BIN/win64/
LIN64=$BIN/lin64/
CMDS="clean"
PREFIX="armq_"
MAKEFILE=Makefile
DMD_FLAGS=$DMD_FLAGS

echo "getting port settings"
PORT=$ARMQ_PORT
if [ -z "$PORT" ]; then
    PORT=5555
fi
echo "using port $PORT"
echo "getting host settings"
HOST=$ARMQ_HOST
if [ -z "$HOST" ]; then
    HOST="localhost"
fi

echo "checking for disabled objects..."
if [ ! -z "$DISABLE" ]; then
    ALL=$(echo $ALL | sed "$DISABLE")
fi
if [ -z "$ALL" ]; then
    echo "all modules disabled"
    exit 1
fi
echo "using host $HOST"
echo "// generated "$(date +%Y-%m-%d-%s)"
// ${ARMQ_INTEGRATE}
module vars;
public enum Port = $PORT;
public enum Host = \"$HOST\";" > $VARS
_mk() {
    CMDS=$CMDS" "$1
    echo "$1:"
    echo -e '\t'"mkdir -p $2"
}

_nm() {
    if [ -z "$RENAMES" ]; then
        echo $PREFIX$1
    else
        echo $1 | sed "$RENAMES"
    fi
}

echo "preparing make"
echo "# Generated "$(date +%s) > $MAKEFILE

echo "checking for dmd.exe"
if [ -z "$DMD" ]; then
    echo "no DMD detected..."
else
    echo "ok"
    _win32() {
        _mk "win32" $WIN32
        for d in $ALL; do
            echo -e '\t'"wine $DMD $DMD_FLAGS -m32 -of$WIN32$(_nm $d).dll $SRC src/$d.d"
        done
    }
    _win32 >> $MAKEFILE
fi

echo "checking for dmd"
if [ -x "$(command -v dmd)" ]; then
    echo "ok"
    _linux64() {
        _mk "linux64" $LIN64
        for d in $ALL; do
            echo -e '\t'"dmd $DMD_FLAGS -m64 -defaultlib=libphobos2.so -fPIC -shared -of$LIN64$(_nm $d).so src/$d.d $SRC" 
        done
    }
    _linux64 >> $MAKEFILE
else
    echo "no dmd for linux..."
fi

echo "checking for dmd64"
if [ -x "$(command -v dmd64)" ]; then
    echo "ok"
    _win64(){
        _mk "win64" $WIN64
        for d in $ALL; do
            nm=$(_nm $d)"_x64.dll"
            df=$DEFS$d.def
            echo "LIBRARY \"$nm\"" > $df
            echo "EXPORTS RVExtension" >> $df
            echo -e '\t'"dmd64 $DMD_FLAGS -L/DLL -of$WIN64$nm $SRC src/$d.d $df"
        done
    }
    _win64 >> $MAKEFILE
else
    echo "no dmd64 wrapper..."
fi

if [[ $CMDS != "clean" ]]; then
    sed -i "1s/^/all: $CMDS pack\n/" $MAKEFILE
    sed -i "1s/^/PHONY: all\n/" $MAKEFILE
    echo "clean:" >> $MAKEFILE
    echo -e '\t'"rm -rf $BIN" >> $MAKEFILE
    echo -e '\t'"mkdir -p $BIN" >> $MAKEFILE
    echo 'PACK=$(shell find '$BIN'/ -type f | grep -E ".so|.dll" | sed "s/'$BIN'\///g")' >> $MAKEFILE
    echo "pack:" >> $MAKEFILE
    echo -e '\tcp '$VARS' '$BIN/$VARSD >> $MAKEFILE
    echo -e '\tcd '$BIN' && tar -cvf build.tar.gz '$VARSD' $(PACK)' >> $MAKEFILE
    echo "tests:" >> $MAKEFILE
    _test_harn=$BIN/test_harness
    echo -e '\tdmd -m64 -defaultlib=libphobos2.so -unittest -of'$_test_harn' '$SRC' test/harness.d' >> $MAKEFILE
    echo -e '\t./'$_test_harn >> $MAKEFILE
else
    rm -f $MAKEFILE
    echo "no valid commands to make"
    exit 1
fi


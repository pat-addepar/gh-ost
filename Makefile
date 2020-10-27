export PATH := $(GOPATH)/bin:$(PATH)

default: all

PROGS = build test clean

ALL_SRC := $(shell find ./go/cmd -name "*.go")

BIN_DIR := "./bin"

all: $(PROGS)

clean:
	rm -rf bin/*

test:
	go test ./go/...

build:
	go build -i -o ${BIN_DIR}/gh-ost go/cmd/gh-ost/*.go

build-linux:
	GOOS=linux GOARCH=amd64 go build -i -o ${BIN_DIR}/gh-ost go/cmd/gh-ost/*.go

.PHONY: test clean all build

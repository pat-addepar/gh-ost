#!/bin/bash

cd ~
wget https://golang.org/dl/go1.14.10.linux-amd64.tar.gz -O go1.14.10.src.tar.gz
tar xvf go1.14.10.src.tar.gz

sudo chown -R root:root ./go
sudo mv go /usr/local

# Update paths
echo "export GOROOT=/usr/local/go" >> $HOME/.profile
echo "export GOPATH=\$HOME/work" >> $HOME/.profile
echo "export PATH=\$PATH:\$GOROOT/bin:\$GOPATH/bin" >> $HOME/.profile
. ~/.profile

mkdir $HOME/work

# Install go dep
go get -d -u github.com/golang/dep
cd $(go env GOPATH)/src/github.com/golang/dep
DEP_LATEST=$(git describe --abbrev=0 --tags)
git checkout $DEP_LATEST
./install.sh
cd ~/

mkdir -p work/src/github.com/pat-addepar/
cd work/src/github.com/pat-addepar/
git clone https://github.com/pat-addepar/gh-ost && cd gh-ost

# Install Deps
dep ensure

# Build
make build

# Clean
rm go1.14.10.src.tar.gz

#!/usr/bin/env bash
set -euo pipefail

sudo apt update
sudo apt install -y git

# First remove any existing old Go installation
sudo rm -rf /usr/local/go

# Install correct Go version
curl https://dl.google.com/go/go1.15.7.linux-amd64.tar.gz | sudo tar -C/usr/local -zxvf -

# Update environment variables to include go
cat <<'EOF' >>$HOME/.profile
export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export GO111MODULE=on
export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin
EOF
source $HOME/.profile

sudo apt install -y build-essential
sudo apt-get install -y manpages-dev

WASMD_VERSION=v0.17.0
BECH32_PREFIX=punk
git clone https://github.com/CosmWasm/wasmd.git
cd wasmd
git checkout ${WASMD_VERSION}
mkdir build
go build -o build/nymd -mod=readonly -tags "netgo,ledger" -ldflags "-X github.com/cosmos/cosmos-sdk/version.Name=nymd -X github.com/cosmos/cosmos-sdk/version.AppName=nymd -X github.com/CosmWasm/wasmd/app.NodeDir=.nymd -X github.com/cosmos/cosmos-sdk/version.Version=${WASMD_VERSION} -X github.com/cosmos/cosmos-sdk/version.Commit=1920f80d181adbeaedac1eeea1c1c6e1704d3e49 -X github.com/CosmWasm/wasmd/app.Bech32Prefix=${BECH32_PREFIX} -X 'github.com/cosmos/cosmos-sdk/version.BuildTags=netgo,ledger'" -trimpath ./cmd/wasmd # noqa line-length

sudo apt install -y ufw
sudo ufw enable
sudo ufw allow 1317,26656,26660,22,80,443,8000,1790/tcp

# ./build/nymd

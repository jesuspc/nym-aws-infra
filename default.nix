{ pkgs ? (import <nixpkgs> {}).pkgs }:
with pkgs;
pkgs.stdenv.mkDerivation {
  name = "nym";
  buildInputs = [
    git
    curl
    awscli
    awslogs

    docker
    docker-compose

    nodePackages.pnpm

    cacert
    binutils
    dbus
    gcc
    gnumake
    niv
    openssl
    pkgconfig
    rustfmt
    rustup
    rls
  ];

  RUST_BACKTRACE = 1;

  shellHook = ''
    export PATH="./node_modules/.bin:$PATH"
    export TS_NODE_FILES="true"
  '';
}

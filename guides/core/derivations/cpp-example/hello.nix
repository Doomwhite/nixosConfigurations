{ pkgs ? import <nixpkgs> {} }:
pkgs.stdenv.mkDerivation {
  name = "hello";
  src = ./src;

  phases = [
    "unpackPhase"
    "buildPhase"
    "installPhase"
  ];

  buildPhase = ''
    g++ hello.cpp -o hello
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp hello $out/bin
  '';
}

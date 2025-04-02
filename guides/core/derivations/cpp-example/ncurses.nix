{ pkgs ? import <nixpkgs> {} }:
pkgs.stdenv.mkDerivation {
  name = "ncurses";
  src = ./src;

  buildInputs = with pkgs; [
    ncurses
  ];

  phases = [
    "unpackPhase"
    "buildPhase"
    "installPhase"
  ];

  buildPhase = ''
    g++ ncurses.cpp -o ncurses -lncurses
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp ncurses $out/bin
  '';
}

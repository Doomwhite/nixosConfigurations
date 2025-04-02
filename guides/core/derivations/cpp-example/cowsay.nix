{ pkgs ? import <nixpkgs> {} }:
pkgs.stdenv.mkDerivation {
  name = "cowsay";
  src = ./src;

  buildInputs = with pkgs; [
    cowsay
  ];

  nativeBuildInputs = with pkgs; [
    makeWrapper
  ];

  phases = [
    "unpackPhase"
    "buildPhase"
    "installPhase"
    "postFixup"
  ];

  buildPhase = ''
    g++ cowsay.cpp -o cowsay
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp cowsay $out/bin
  '';

  postFixup = ''
    wrapProgram $out/bin/cowsay \
      --set PATH ${pkgs.lib.makeBinPath (with pkgs; [
        cowsay
      ])}
  '';
}

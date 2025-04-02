# This contains a good example of using the phases 

## Create a new flake
$ nix flake new flake-example
$ cd hello

## Build the flake in the current directory:
$ nix build
$ ./result/bin/hello

## Run the flake in the current directory:
$ nix run

## Start a development shell for hacking on this flake:
$ nix develop
$ unpackPhase
$ cd hello-*
$ configurePhase
$ buildPhase
$ ./hello
$ installPhase
$ ../outputs/out/bin/hello

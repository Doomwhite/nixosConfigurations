#!/usr/bin/env nix-shell
#! nix-shell -i bash --pure
#! nix-shell -p bash cacert curl jq python3Packages.xmljson
#! nix-shell -I nixpkgs=http://github.com/NixOs/nixpkgs/archive/2a601aafdc5605a5133a2ca506a34a3a73377247.tar.gz
curl https://github.com/NixOs/nixpkgs/releases.atom | xml2json | jq .

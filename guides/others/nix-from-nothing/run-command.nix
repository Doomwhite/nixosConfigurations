let 
  pkgs = import <nixpkgs> {};
in
  pkgs.runCommand "my-derivation" {} ''
    echo Hello > $out
  ''

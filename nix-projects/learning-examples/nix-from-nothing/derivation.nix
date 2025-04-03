let 
  pkgs = import <nixpkgs> {};
in 
builtins.derivation {
  name = "my-derivation";
  system = "x86_64-linux";
  builder = "/bin/sh";
  arqs = [ "-c" "echo Hello > $out" ];
}

{
  description = "hello-world flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
  let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in
  {
    packages.${system} = {
      hello = import ./hello.nix { inherit pkgs; };
      cowsay = import ./cowsay.nix { inherit pkgs; };
      ncurses = import ./ncurses.nix { inherit pkgs; };
    };
  };
}

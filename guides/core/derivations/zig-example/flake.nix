{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs }:
  let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      name = "backup_recycle_bin";
  in 
  {
      packages.${system}.default = pkgs.stdenv.mkDerivation {
          name = name;
          src = ./.;

          buildInputs = with pkgs; [
              zig
              python3
          ];

          phases = [
            "unpackPhase"
            "buildPhase"
            "installPhase"
          ];

          buildPhase = ''
            export ZIG_GLOBAL_CACHE_DIR=$PWD
            zig build
          '';
          
          installPhase = ''
            mkdir -p $out
            cp -r $PWD/zig-out/bin $out/bin
          '';
      };
  };
}

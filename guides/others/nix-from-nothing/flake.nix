{
  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-22.11";
    };
  };

  outputs = inputs: 
  let 
    system = "x86_64-linux";
    pkgs = inputs.nixpkgs.legacyPackages.${system};
  in
  {
    packages.${system} = {
      myderivation = pkgs.stdenv.mkDerivation {
        name = "my-derivation";

        src = ./.;

        installPhase = ''
          echo HELLOOOOOO > $out
        '';
      };
    };
  };
}
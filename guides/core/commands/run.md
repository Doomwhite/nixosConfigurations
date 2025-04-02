# Apps
## Runs the default app from the flake
$ nix run blender-bin

## Runs the specified app from the flake, using the name
$ nix run blender-bin#blender_2_83

# Package
## Runs the package with the same name from the flake
$ nix run nixpkgs#vim
Running vim with the arguments:
$ nix run nixpkgs#vim

# Description
Nix run builds and run an installable(App or a nix derivation).


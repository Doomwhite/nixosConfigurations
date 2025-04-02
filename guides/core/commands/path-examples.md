# Syntax

nix run github:<owner>/<repo>/<revision>#<executable>

# Examples

## Specific commit ID
nix run github:DeterminateSystems/riff/a71a8b5ddf680df5db8cc17fa7fddd393ee39ffe

## Tag
nix run github:DeterminateSystems/riff/v1.0.0

## Latest commit in a branch
nix run github:DeterminateSystems/riff/secret-branch-for-nix-run

## Target a flake in a subdirectory
nix run "github:hard-to-find/cool-app?dir=nested#specific-app""

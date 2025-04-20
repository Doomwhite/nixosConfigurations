# Structure
- angular/: Angular dev env (shell.nix).
- core: Nix core examples.
- flake.nix, flake.lock: Main Flake files.
- guides/: Practical how-tos.
- nix-projects/: Hands-on projects for experimentation.
- nix-tutorials/: Nix tutorials, step by step.
- nixos-guides/: Advanced NixOS tasks.
- old-config.nix: Old config for reference.
- secrets.json: Sensitive data (not tracked).


# How to use

- Get the [latest release](https://github.com/LGUG2Z/nixos-wsl-starter/releases)

```bash
wsl --import NixOS .\NixOS\ .\nixos-wsl.tar.gz --version 2
wsl -d NixOS

git clone https://github.com/Doomwhite/nixosConfigurations.git /tmp/configuration
cd /tmp/configuration
sudo nixos-rebuild switch --flake /tmp/configuration#nixos-wsl && sudo shutdown -h now

wsl -d NixOS
mv /tmp/configuration ~/configuration
sudo nixos-rebuild switch --flake ~/configuration#nixos-wsl
```

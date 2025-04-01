## How to use

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


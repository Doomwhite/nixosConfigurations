{
  description = "Basic NixOS configuration for WSL";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixos-wsl.url = "github:nix-community/NixOS-WSL";
    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    emacs.url = "github:Doomwhite/emacs/new";
    emacs.inputs.nixpkgs.follows = "nixpkgs";
    alejandra.url = "github:kamadorueda/alejandra/4.0.0";
  };

  outputs = {
    self,
    nixpkgs,
    nixos-wsl,
    home-manager,
    emacs,
    alejandra,
    ...
  }: let
    userName = "DooMWhite";
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    secrets = builtins.fromJSON (builtins.readFile "${self}/secrets.json");
  in {
    nixosConfigurations.nixos-wsl = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        # Base WSL configuration
        nixos-wsl.nixosModules.wsl

        # Your basic system configuration
        {
          assertions = [
            {
              assertion =
                builtins.isString secrets.github_token
                && builtins.match "(github_pat_|ghp_)[0-9a-zA-Z_]+" secrets.github_token != null;
              message = "secrets.json must contain a valid GitHub personal access token starting with 'github_pat_' or 'ghp_'";
            }
          ];
          # Set the system state version for backward compatibility
          system.stateVersion = "24.05";

          # Basic system settings
          networking.hostName = "nixos-wsl";
          time.timeZone = "America/Sao_Paulo";

          # Idk
          environment.enableAllTerminfo = true;

          # Users configuration
          users.users.${userName} = {
            isNormalUser = true;
            extraGroups = ["wheel" "docker"];
            home = "/home/${userName}";
            # Sets the starting shell
            shell = pkgs.fish;
            # Required to run with the hm fish, otherwise it's an error
            ignoreShellProgramCheck = true;
          };

          # Enable Home Manager for managing user-level configurations
          imports = [
            home-manager.nixosModules.home-manager
          ];

          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;

            users.${userName} = {
              _module.args.secrets = secrets; # Pass secrets to all imported modules

              imports = [
                ./fish.nix
                ./git.nix
              ];

              fonts.fontconfig.enable = true;

              home = {
                # Set the state version for Home Manager
                stateVersion = "22.11";

                username = "${userName}";
                homeDirectory = "/home/${userName}";

                sessionVariables = {
                  EDITOR = "emacsclient -c -n";
                  SHELL = "${pkgs.fish}/bin/fish";
                };
                packages = [
                  pkgs.ibm-plex
                  pkgs.tree
                  pkgs.nix-your-shell
                  alejandra.defaultPackage.${system}
                  pkgs.dolphin
                  pkgs.xorg.xeyes
                ];
              };

              programs = {
                neovim.enable = true;

                emacs = {
                  enable = true;
                  package = emacs.packages.${system}.default;
                };
              };

              services.emacs = {
                enable = true;
                package = emacs.packages.${system}.default;
              };
            };
          };

          # Enable system services
          services.openssh.enable = true;
          services.xserver.enable = true;
          services.libinput.enable = true;
          virtualisation.docker.enable = true;
          virtualisation.docker.autoPrune.enable = true;

          # WSL-specific settings
          wsl = {
            enable = true;
            wslConf.automount.root = "/mnt";
            wslConf.interop.appendWindowsPath = false;
            wslConf.network.generateHosts = false;
            defaultUser = "${userName}";
            startMenuLaunchers = true;
          };

          # Nix specific settings
          nix = {
            settings = {
              # Experimental features, enables flakes
              experimental-features = ["nix-command" "flakes" "repl-flake"];

              trusted-users = [userName];

              accept-flake-config = true;
              access-tokens = [
                "github.com=${secrets.github_token}"
              ];
              auto-optimise-store = true;
            };

            # Garbage collector
            gc = {
              automatic = true;
              options = "--delete-older-than 7d";
            };
          };
        }
      ];
    };
  };
}

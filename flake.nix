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
    # alejandra.inputs.nixpkgs.follows = "nixpkgs";
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
                ];
              };

              programs = {
                fish = {
                  enable = true;
                  package = pkgs.fish;
                  functions = {
                    refresh = "source $HOME/.config/fish/config.fish";
                  };
                  interactiveShellInit = ''
                    nix-your-shell fish | source

                    ${pkgs.lib.strings.fileContents (pkgs.fetchFromGitHub {
                        owner = "rebelot";
                        repo = "kanagawa.nvim";
                        rev = "de7fb5f5de25ab45ec6039e33c80aeecc891dd92";
                        sha256 = "sha256-f/CUR0vhMJ1sZgztmVTPvmsAgp0kjFov843Mabdzvqo=";
                      }
                      + "/extras/kanagawa.fish")}

                    set -U fish_greeting
                  '';
                  shellAliases = {
                    mxc = "emacsclient -c -n";
                    pbcopy = "/mnt/c/Windows/System32/clip.exe";
                    pbpaste = "/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe -command 'Get-Clipboard'";
                    explorer = "/mnt/c/Windows/explorer.exe";
                  };
                  shellAbbrs = {
                    "nixhome" = "cd $HOME/nixosConfigurations";
                    "nixbuild" = "sudo nixos-rebuild switch --flake $HOME/nixosConfigurations#nixos-wsl --verbose";
                    ".." = "cd ..";
                    "..." = "cd ../../";
                    "...." = "cd ../../../";
                    "....." = "cd ../../../../";
                  };
                  plugins = [
                    {
                      inherit (pkgs.fishPlugins.autopair) src;
                      name = "autopair";
                    }
                    {
                      inherit (pkgs.fishPlugins.done) src;
                      name = "done";
                    }
                    {
                      inherit (pkgs.fishPlugins.sponge) src;
                      name = "sponge";
                    }
                  ];
                };

                git = {
                  enable = true;
                  package = pkgs.git;
                  delta.enable = true;
                  delta.options = {
                    line-numbers = true;
                    side-by-side = true;
                    navigate = true;
                  };
                  userEmail = "doomwhitex@gmail.com";
                  userName = "Doomwhite";
                  extraConfig = {
                    url = {
                      "https://oauth2:${secrets.github_token}@github.com" = {
                        insteadOf = "https://github.com";
                      };
                    };
                    core = {
                      longspaths = true;
                      preloadindex = true;
                      fscache = true;
                      defaultbranch = "main";
                      editor = "emacsclient -c -n";
                    };
                    fetch = {
                      prune = true;
                    };
                    worktree = {
                      guessRemote = true;
                    };
                    push = {
                      default = "current";
                      autoSetupRemote = true;
                    };
                    merge = {
                      conflictstyle = "diff3";
                    };
                    diff = {
                      colorMoved = "default";
                    };
                    #safe = {
                    #  directory = [ "~/configuration" "~/${emacsDir}" ];
                    #};
                    alias = {
                      br = "branch";
                      bra = "branch -a";
                      brl = "branch -l";
                      brr = "branch -r";
                      cga = "config --get-regexp alias";
                      cg = "config";
                      cgg = "config --global -e";
                      cgl = "config --local -e";
                      cm = "commit";
                      cmad = "commit --amend";
                      cmadam = "commit --amend -a -m";
                      cmadan = "commit --amend -a --no-edit";
                      cmadm = "commit --amend -m";
                      cmadn = "commit --amend --no-edit";
                      cmadpm = "commit --amend -p -m";
                      cmadpn = "commit --amend -p --no-edit";
                      cmam = "commit -a -m";
                      cmm = "commit -m";
                      cmp = "commit -p";
                      cmpm = "commit -p -m";
                      co = "checkout";
                      ps = "push";
                      psf = "push --force";
                      psu = "push -u";
                      psup = "!f() { \
                        current_branch=$(git rev-parse --abbrev-ref HEAD); \
                            remote_branch=\"$current_branch\"; \
                            if ! git rev-parse --abbrev-ref --symbolic-full-name @{u} >/dev/null 2>&1; then \
                                remote_branch=\"--set-upstream origin $current_branch\"; \
                            fi; \
                            git push $remote_branch; \
                      }; f";
                      rao = "remote add origin";
                      rb = "rebase";
                      rba = "rebase --abort";
                      rbc = "rebase --continue";
                      st = "status";
                      sm = "submodule";
                      sma = "submodule add";
                      smf = "submodule foreach --recursive";
                      sw = "switch";
                      swd = "switch dev";
                      swm = "switch master";
                      up = "!git fetch && git status";
                      uppl = "!git up && git pull";
                      wt = "worktree";
                      wta = "worktree add";
                      wtl = "worktree list";
                      wtr = "worktree remove";
                      wtatb = "!f() { git worktree add --track -b $1 $1 origin/$2; }; f";
                      wtab = "!f() { git worktree add -b $1 $1 $2; }; f";
                      lsw = "switch -";
                    };
                  };
                };
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

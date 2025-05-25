{
  description = "DooMWhite's NixOS Flake Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11"; # Pin to NixOS 24.11
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs"; # Ensure home-manager uses the same nixpkgs
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }:
  let
    system = "x86_64-linux"; # Adjust if your system is different (e.g., aarch64-linux)
    allowUnfree = true;
    permittedInsecurePackages = [ "openssl-1.1.1w" ];
    pkgs = import nixpkgs {
      inherit system;
      config = {
        inherit allowUnfree;
        inherit permittedInsecurePackages;
      };
    };
    secrets = builtins.fromJSON (builtins.readFile "${self}/secrets.json");
  in {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        # Include hardware configuration
        ./hardware-configuration.nix
        # Main system configuration
        {
          assertions = [
            {
              assertion =
                builtins.isString secrets.github_token
                && builtins.match "(github_pat_|ghp_)[0-9a-zA-Z_]+" secrets.github_token != null;
              message = "secrets.json must contain a valid GitHub personal access token starting with 'github_pat_' or 'ghp_'";
            }
          ];

          nix.settings = {
            experimental-features = [ "nix-command" "flakes" ];
          };

          # Bootloader
          boot.loader.systemd-boot.enable = true;
          boot.loader.efi.canTouchEfiVariables = true;

          networking.hostName = "nixos";
          networking.networkmanager.enable = true;
          networking.nameservers = [ "1.1.1.1" "1.0.0.1" ];

          time.timeZone = "America/Sao_Paulo";
          i18n.defaultLocale = "en_US.UTF-8";
          i18n.extraLocaleSettings = {
            LC_ADDRESS = "en_US.UTF-8";
            LC_IDENTIFICATION = "en_US.UTF-8";
            LC_MEASUREMENT = "en_US.UTF-8";
            LC_MONETARY = "en_US.UTF-8";
            LC_NAME = "en_US.UTF-8";
            LC_NUMERIC = "en_US.UTF-8";
            LC_PAPER = "en_US.UTF-8";
            LC_TELEPHONE = "en_US.UTF-8";
            LC_TIME = "en_US.UTF-8";
          };

          # services.displayManager.sddm.enable = true;
          services.displayManager.defaultSession = "cinnamon";
          services.libinput.enable = true;
          services.xserver = {
            enable = true;
            displayManager.lightdm.enable = true;
            desktopManager = {
              cinnamon.enable = true;
            };
            # desktopManager.plasma5.enable = true;
            xkb = {
              layout = "us";
              variant = "";
            };
            autoRepeatDelay = 251;
            autoRepeatInterval = 20; # 50Hz (1000/20 = 50)
          };

          services.printing.enable = true;

          hardware.pulseaudio.enable = false;
          security.rtkit.enable = true;
          services.pipewire = {
            enable = true;
            alsa.enable = true;
            alsa.support32Bit = true;
            pulse.enable = true;
          };

          users.users.doomwhite = {
            isNormalUser = true;
            description = "DooMWhite";
            extraGroups = [ "networkmanager" "wheel" ];
            home = "/home/doomwhite";
            shell = pkgs.fish;
            ignoreShellProgramCheck = true;
          };

          nixpkgs.config = {
            inherit allowUnfree;
            inherit permittedInsecurePackages;
          };

          environment.systemPackages = with pkgs; [
            neovim
            wget
            cinnamon.mint-themes
          ];

          system.stateVersion = "24.11";
        }
        # Include home-manager for user-specific settings
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.doomwhite = {
            home = {
              stateVersion = "24.11";
              
              username = "doomwhite";
              homeDirectory = "/home/doomwhite";

              packages = with pkgs; [
                brave
                sublime4
              ];

              sessionVariables = {
                EDITOR = "emacsclient -c -n";
                SHELL = "${pkgs.fish}/bin/fish";
              };
            };

            programs.git = {
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
                  # editor = "emacsclient -c -n";
                  editor = "nvim";
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

            programs.fish = {
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
                mx = "emacs";
                mxc = "emacsclient -c -n";
              };
              shellAbbrs = {
                "nixhome" = "cd $HOME/nixosConfigurations";
                "nixbuild" = "sudo nixos-rebuild switch --flake $HOME/nixosConfigurations --verbose";
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
          };
        }
      ];
    };
  };
}
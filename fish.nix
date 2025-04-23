{pkgs, ...}: {
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

      echo "Checking for ip command..."
      if command -v ip >/dev/null 2>&1
          # Use ip route
          set ip (ip route show | grep default | awk '{print $3}')
          # Create DISPLAY and PULSE_SERVER variables
          set -x DISPLAY "$ip:0.0"
          set -x PULSE_SERVER "tcp:$ip"

          echo "Using ip route with ip $ip"
      else
          # Otherwise, we use windows ipconfig
          set ip (ipconfig.exe | grep -A 10 "vEthernet (WSL (Hyper-V firewall))" | grep "IPv4 Address" | sed -E 's/.*: ([0-9.]+)/\1/')

          # Create DISPLAY and PULSE_SERVER variables
          set -x DISPLAY "$ip:0.0"
          set -x PULSE_SERVER "tcp:$ip"

          echo "Using ipconfig with ip $ip"
      end
    '';
    shellAliases = {
      mx = "emacs";
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
}

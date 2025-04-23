{
  pkgs,
  secrets,
  ...
}: {
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
}

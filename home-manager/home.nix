{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "r2p2";
  home.homeDirectory = "/home/r2p2";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    #pkgs.tmux

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/r2p2/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      log = {
        enabled = false;
      };
      manager = {
        show_hidden = true;
        show_symlink = true;
        sort_by = "natural";
        sort_sensitive = false;
        sort_reverse = false;
        sort_dir_first = true;
      };
    };
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableAutosuggestions = true;
    enableVteIntegration = true;
    syntaxHighlighting.enable = true;
    autocd = true;
    shellAliases = {
      ll = "ls -l";
      update = "sudo nixos-rebuild switch";
    };
    history = {
      share = true;
      size = 1000000;
      path = "${config.xdg.dataHome}/zsh/history";
      ignorePatterns = [
        "rm *"
        "pkill *"
      ];
    };
    historySubstringSearch = {
      enable = true;
    };
    initExtra = ''
      export PATH="/home/r2p2/.nix-profile/bin/:$PATH"
      export CMAKE_EXPORT_COMPILE_COMMANDS=ON
      export DEBUGINFOD_URLS="https://debuginfod.archlinux.org"
      export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
      export GPG_TTY=$(tty)
      gpgconf --launch gpg-agent
      '';
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "ripgrep" "taskwarrior"];
      theme = "robbyrussell";
    };
  };

  programs.tmux = {
    enable = true;
    shortcut = "a";
    baseIndex = 1;
    escapeTime = 0;
    shell = "${pkgs.zsh}/bin/zsh";
    terminal = "screen-256color";
    historyLimit = 1000000;
    clock24 = true;
    mouse = true;
    plugins = with pkgs; [
      tmuxPlugins.better-mouse-mode
    ];
    extraConfig = ''
      # https://old.reddit.com/r/tmux/comments/mesrci/tmux_2_doesnt_seem_to_use_256_colors/
      set -g default-terminal "xterm-256color"
      set -ga terminal-overrides ",*256col*:Tc"
      set -ga terminal-overrides '*:Ss=\E[%p1%d q:Se=\E[ q'
      set-environment -g COLORTERM "truecolor"

      # Mouse works as expected
      set-option -g mouse on
      # easy-to-remember split pane commands
      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"
      bind c new-window -c "#{pane_current_path}"
    '';
  };

  # TODO: add neovim config
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    plugins = with pkgs.vimPlugins; [
      vim-fugitive
      vim-sleuth
      comment-nvim
      gitsigns-nvim
      nvim-lspconfig
      nvim-treesitter.withAllGrammars
      telescope-nvim
      telescope-fzf-native-nvim
      telescope-ui-select-nvim
      plenary-nvim
    ];
  };

  # TODO: gpg "ssh" allowedSignersFile
  programs.git = {
    enable = true;
    userName = "Robert Peters";
    userEmail = "robert.peters@fabmatics.com";
    lfs.enable = true;
    package = pkgs.gitAndTools.gitFull;
    aliases = {
      review = "diff --color --ignore-space-change --word-diff --minimal --patience -U20";
      s = "status -s -b";
      satus = "status";
      stats = "status";
      l = "log --graph --decorate";
      lg = "log --oneline --graph --decorate";
      continue-wip = "reset HEAD~1";
      rebase-patch = "rebase --show-current-patch";
    };
    signing = {
       key = "0778ACB13BB48D08";
       signByDefault = true;
    };
    ignores = [
      ".cache"
      ".ccls-cache"
      ".codechecker"
      ".fleet"
      ".gdb_history"
      ".idea"
      ".kdev4"
      ".vscode"
      "*.a1"
      "*.s1"
      "*.snalyzerinfo"
      "*.swp"
      "callgrind*"
      "compile_commands.json"
      "CMakeFiles"
      "CMakeCache.txt"
      "perf.data*"
      "perf.hist*"
      "suppression.sup"
    ];
    extraConfig = {
      commit = {
        verbose = true;
      };
      init = {
        defaultBranch = "master";
      };
      diff = {
        algorithm = "histogram";
        submodule = "log";
        submoduleSummary = true;
        colorMoved = "default";
        colorMovedws = "allow-indentation-change";
      };
      fetch = {
        prune = true;
      };
      gui = {
        warndetachedcommit = true;
        tabsize = 4;
        pruneduringfetch = true;
      };
      log = {
        date = "iso";
      };
      merge = {
        renamelimit = 2000;
        conflictstyle = "zdiff3";
        keepbackup = false;
      };
      pull = {
        rebase = true;
      };
      push = {
        default = "current";
        useForceIfIncludes = true;
        autoSetupRemote = true;
        followtags = true;
      };
      rebase = {
        updateRefs = true;
      };
      rerere = {
        enabled = true;
      };
      user = {
      };
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}

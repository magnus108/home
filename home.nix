{ pkgs, ... }: {
  home.stateVersion = "21.11";
  home.username = "magnus";
  home.homeDirectory = "/Users/magnus";

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    ranger
    rsync
    zip
    unzip
    htop
    wget
    curl
    mupdf
    tig
    llvm
    yabai
    font-awesome
    spacebar
    skhd
  ];

  xdg.configFile."tig/config".text = builtins.readFile ./tigrc;

  xdg.configFile."nvim/coc-settings.json".text = builtins.readFile ./coc-settings.json;

  programs.noti = {
    enable = true;
  };

  programs.navi = {
    enable = true;
  };

  programs.kitty = {
    enable = true;
    theme = "Gruvbox Dark";
  };

  programs.neovim = {
    enable = true;
    extraConfig = builtins.readFile ./vimrc.vim;
    viAlias = true;
    vimAlias = true;
    withNodeJs = true;
    withPython3 = true;
    plugins = with pkgs.vimPlugins; [ haskell-vim coc-nvim ];
  };

  programs.tmux = {
    enable = true;
  };

  programs.zsh = {
    enable = true;
    history = {
      size = 102400;
      save = 102400;
      ignoreDups = true;
      expireDuplicatesFirst = true;
      share = true;
    };
    enableSyntaxHighlighting = true;
    enableAutosuggestions = true;
    oh-my-zsh = {
      enable = true;
      theme = "ys";
      plugins = [ "git" "sudo" "tmux" "tig"];
    };
  };

  programs.git = {
    enable = true;
    userName = "Magnus Møller";
    userEmail = "magnus108@me.com";
    lfs = {
      enable = true;
    };
    extraConfig = {
      core = {
        autocrlf = "input";
      };
      color = {
        ui = "auto";
      };
      branch = {
        autoSetupRebase = "always";
      };
      push = {
        default = "simple";
      };
      pull = {
        rebase = "merges";
      };
      merge = {
        tool = "vimdiff";
        conflictStyle = "diff3";
      };
      rerere = {
        enabled = true;
      };
      diff = {
        tool = "vimdiff";
        mnemonicprefix = true;
      };
      rebase = {
        abbreviateCommands = true;
      };
      mergetool = {
        vimdiff = {
          cmd = "nvim -d $LOCAL $MERGED $BASE $REMOTE -c 'wincmd w' -c 'wincmd j'";
        };
      };
    };
  };
}

{ pkgs, ... }: {

    xdg.configFile."tig/config".text = builtins.readFile ./tigrc;

    home = {
        stateVersion = "21.11";
        username = "magnus";
        homeDirectory = "/Users/magnus";
        packages = with pkgs; [
            ripgrep
            rsync
            zip
            unzip
            wget
            curl
            tig
            virt-manager
            virt-viewer
        ];
    };

    programs = {
        home-manager.enable = true;
        noti.enable = true;
        navi.enable = true;

        kitty = {
            enable = true;
            theme = "Monokai Pro";
            darwinLaunchOptions = [
                "--single-instance"
                "--directory=~"
            ];
        };

        neovim = {
            enable = true;
            extraConfig = builtins.readFile ./vimrc.vim;
            viAlias = true;
            vimAlias = true;
            vimdiffAlias = true;
            withNodeJs = true;
            withPython3 = true;
            plugins = with pkgs.vimPlugins; [
                vim-nix
                haskell-vim
                coc-nvim
            ];
            coc = {
                enable = true;
                settings = builtins.fromJSON (builtins.readFile ./coc-settings.json);
            };

        };

        zsh = {
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
                plugins = [
                    "git"
                    "sudo"
                    "tig"
                ];
            };
        };

        git = {
            enable = true;
            userName = "Magnus Møller";
            userEmail = "magnus108@me.com";
            lfs.enable = true;
            extraConfig = {
                core.autocrlf = "input";
                color.ut = "auto";
                branch.autoSetupRebase = "always";
                push.default = "simple";
                pull.rebase = "merges";
                rerere.enabled = true;
                rebase.abbreviateCommands = true;
                mergetool.vimdiff.cmd = "nvim -d $LOCAL $MERGED $BASE $REMOTE -c 'wincmd w' -c 'wincmd j'";
                merge = {
                    tool = "vimdiff";
                    conflictStyle = "diff3";
                };
                diff = {
                    tool = "vimdiff";
                    mnemonicprefix = true;
                };
            };
        };
    };
}

{
  description = "Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    spacebar = {
      url = "github:shaunsingh/spacebar";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    yabai-src = {
      url = "github:koekeishiya/yabai";
      flake = false;
    };
  };

  outputs = { self, darwin, nixpkgs, home-manager, ...}@inputs:
  let
    configuration = { pkgs, ... }: {
      system.stateVersion = 4;
      services.nix-daemon.enable = true;
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      programs = { 
	    zsh.enable = true;
      };
      nix.package = pkgs.nixFlakes;
      users.users.magnus = { 
	    home = "/Users/magnus";
	    shell = pkgs.zsh;
      };
      system.defaults = {
        screencapture = { location = "/tmp"; };
        dock = {
            autohide = true;
            showhidden = true;
            mru-spaces = false;
        };
        NSGlobalDomain = {
            AppleKeyboardUIMode = 3;
            AppleFontSmoothing = 1;
            _HIHideMenuBar = true;
        };
    };
        fonts = {
            fontDir.enable = false;
            fonts = with pkgs; [
                fira
                fira-code
                ibm-plex
                emacs-all-the-icons-fonts
                #sf-mono-liga-bin
            ];
        };
        services.spacebar = {
            enable = true;
            package = pkgs.spacebar;
            config = {
                position = "bottom";
                height = 28;
                title = "on";
                spaces = "on";
                power = "on";
                clock = "off";
                right_shell = "off";
                padding_left = 20;
                padding_right = 20;
                spacing_left = 25;
                spacing_right = 25;
                power_icon_strip = " ";
                space_icon_strip = "一 二 三 四 五 六 七 八 九 十";
                spaces_for_all_displays = "on";
                display_separator = "on";
                display_separator_icon = "|";
                right_shell_icon = " ";
                right_shell_command = "whoami";
            };
        };
      services.yabai = { 
        enable = true;
        config = {
            # layout
            layout = "bsp";
            auto_balance = "on";
            split_ratio = "0.50";
            window_placement = "second_child";
            # Gaps
            window_gap = 18;
            top_padding = 18;
            bottom_padding = 46;
            left_padding = 18;
            right_padding = 18;
            # shadows and borders
            window_shadow = "on";
            window_border = "off";
            window_border_width = 3;
            window_opacity = "on";
            window_opacity_duration = "0.1";
            active_window_opacity = "1.0";
            normal_window_opacity = "1.0";
            # mouse
            mouse_modifier = "cmd";
            mouse_action1 = "move";
            mouse_action2 = "resize";
            mouse_drop_action = "swap";
        };
        };
        services.skhd = {
            enable = true;
            skhdConfig = ''
            # open terminal
            cmd - return : kitty --single-instance
            # focus window
            lalt - h : yabai -m window --focus west
            lalt - j : yabai -m window --focus south
            lalt - k : yabai -m window --focus north
            lalt - l : yabai -m window --focus east
            # swap managed window
            shift + lalt - h : yabai -m window --swap west
            shift + lalt - l : yabai -m window --swap east
            shift + lalt - j : yabai -m window --swap south
            shift + lalt - k : yabai -m window --swap north
            # focus spaces
            alt - x : yabai -m space --focus recent
            alt - 1 : yabai -m space --focus 1
            alt - 2 : yabai -m space --focus 2
            alt - 3 : yabai -m space --focus 3
            alt - 4 : yabai -m space --focus 4
            alt - 5 : yabai -m space --focus 5
            alt - 6 : yabai -m space --focus 6
            alt - 7 : yabai -m space --focus 7
            alt - 8 : yabai -m space --focus 8
            # focus on next/prev space
            alt + ctrl - q : yabai -m space --focus prev
            alt + ctrl - e : yabai -m space --focus next
            # send window to desktop
            shift + alt - x : yabai -m window --space recent
            shift + alt - 1 : yabai -m window --space 1
            shift + alt - 2 : yabai -m window --space 2
            shift + alt - 3 : yabai -m window --space 3
            shift + alt - 4 : yabai -m window --space 4
            shift + alt - 5 : yabai -m window --space 5
            shift + alt - 6 : yabai -m window --space 6
            shift + alt - 7 : yabai -m window --space 7
            shift + alt - 8 : yabai -m window --space 8
            # float / unfloat window and center on screen
            lalt - t : yabai -m window --toggle float;\
                        yabai -m window --grid 4:4:1:1:2:2
            # toggle window zoom
            lalt - d : yabai -m window --toggle zoom-parent
            '';
        };


      environment.systemPackages = [];
    };
  in
  {
    darwinConfigurations.magnus = darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          ({ config, pkgs, lib, ... }: {
          nixpkgs = {
            overlays = with inputs; [
                spacebar.overlay
                (final: prev: {
                  yabai =
                    let
                      version = "4.0.0-dev";
                      buildSymlinks = prev.runCommand "build-symlinks" { } ''
                        mkdir -p $out/bin
                        ln -s /usr/bin/xcrun /usr/bin/xcodebuild /usr/bin/tiffutil /usr/bin/qlmanage $out/bin
                      '';
                    in
                    prev.yabai.overrideAttrs (old: {
                      inherit version;
                      src = inputs.yabai-src;

                      buildInputs = with prev.darwin.apple_sdk.frameworks; [
                        Carbon
                        Cocoa
                        ScriptingBridge
                        prev.xxd
                        SkyLight
                      ];

                      nativeBuildInputs = [ buildSymlinks ];
                    });
                })];
            };
            })
          configuration home-manager.darwinModules.home-manager {
				home-manager.users.magnus = import ./home.nix;
      	  }
       ];
    };
  };
}

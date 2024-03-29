{ pkgs, ... }: {

    nix.settings = {
        substituters = ["https://cache.iog.io"];
        trusted-public-keys = ["hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="];
    };

    programs.zsh.enable = true;

    environment.variables = {
        EDITOR = "nvim";
    };

    system = {
        stateVersion = 4;
        defaults = {
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
    };

    users.users.magnus = {
        home = "/Users/magnus";
        shell = pkgs.zsh;
    };

    fonts = {
        fontDir.enable = true;
    };

    services = {
        nix-daemon.enable = true;

        spacebar = {
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

        yabai = {
            enable = true;
            package = pkgs.yabai;
            enableScriptingAddition = true;
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
            extraConfig = ''
                # rules
                yabai -m rule --add app='System Preferences' manage=off
                yabai -m rule --add app='Activity Monitor' manage=off
            '';
        };

        skhd = {
            enable = true;
            skhdConfig = ''
                # open programs
                cmd - return : open -na kitty
                cmd + shift - return : open -na Safari
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
                cmd - x : yabai -m space --focus recent
                cmd - 1 : yabai -m space --focus 1
                cmd - 2 : yabai -m space --focus 2
                cmd - 3 : yabai -m space --focus 3
                cmd - 4 : yabai -m space --focus 4
                cmd - 5 : yabai -m space --focus 5
                cmd - 6 : yabai -m space --focus 6
                cmd - 7 : yabai -m space --focus 7
                # focus on next/prev space
                cmd + ctrl - q : yabai -m space --focus prev
                cmd + ctrl - e : yabai -m space --focus next
                # send window to desktop
                shift + cmd - x : yabai -m window --space recent
                shift + cmd - 1 : yabai -m window --space 1
                shift + cmd - 2 : yabai -m window --space 2
                shift + cmd - 3 : yabai -m window --space 3
                shift + cmd - 4 : yabai -m window --space 4
                shift + cmd - 5 : yabai -m window --space 5
                shift + cmd - 6 : yabai -m window --space 6
                shift + cmd - 7 : yabai -m window --space 7
                # float / unfloat window and center on screen
                lalt - t : yabai -m window --toggle float;\
                            yabai -m window --grid 4:4:1:1:2:2
                # toggle window zoom
                cmd - d : yabai -m window --toggle zoom-parent
                shift + cmd - f : yabai -m window --toggle native-fullscreen
            '';
        };
    };
}

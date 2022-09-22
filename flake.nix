{
    description = "Nix stuff";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

        darwin = {
            url = "github:lnl7/nix-darwin";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        spacebar = {
            url = "github:cmacrae/spacebar/v1.4.0";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        yabai-src = {
            url = "github:koekeishiya/yabai";
            flake = false;
        };
    };

    outputs = { self, nixpkgs, darwin, home-manager, ...}@inputs :{
            darwinConfigurations.magnus = darwin.lib.darwinSystem {
                system = "aarch64-darwin";
                modules = [
                    ./darwin.nix
                    home-manager.darwinModule {
                        home-manager = {
                            useGlobalPkgs = true;
                            useUserPackages = true;
                            users.magnus = import ./home.nix;
                        };
                    }
                    ({ pkgs, ... }: {
                        nixpkgs = {
                            overlays = with inputs; [
                                spacebar.overlay.aarch64-darwin
                                (final: prev: {
                                    yabai = prev.yabai.overrideAttrs (old: {
                                        version = "4.0.0-dev";
                                        src = yabai-src;

                                        buildInputs = with prev.darwin.apple_sdk.frameworks; [
                                            Carbon
                                            Cocoa
                                            ScriptingBridge
                                            prev.xxd
                                            SkyLight
                                        ];

                                        nativeBuildInputs = [ 
                                            (prev.runCommand "build-symlinks" { } ''
                                                mkdir -p $out/bin
                                                ln -s /usr/bin/xcrun /usr/bin/xcodebuild /usr/bin/tiffutil /usr/bin/qlmanage $out/bin
                                            '')
                                        ];
                                    });
                                })
                            ];
                        };
                    })
                ];
            };
        };
}

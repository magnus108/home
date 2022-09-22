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

    outputs = { self, darwin, spacebar, nixpkgs, yabai-src, home-manager, ...}:
        let
            system = "aarch64-darwin";
        in {
            darwinConfigurations.magnus = darwin.lib.darwinSystem {
                inherit system;
                specialArgs = { inherit system spacebar yabai-src; };

                modules = [
                    ./overlays.nix
                    ./darwin.nix
                    home-manager.darwinModule {
                        home-manager = {
                            useGlobalPkgs = true;
                            useUserPackages = true;
                            users.magnus = import ./home.nix;
                        };
                    }
                ];
            };
        };
}

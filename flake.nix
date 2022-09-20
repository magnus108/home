{
  description = "Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
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
      services.yabai.enable = true;
      services.skhd.enable = true;

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

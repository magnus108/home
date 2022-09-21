{ pkgs, yabai, spacebar, ... }: {
    nixpkgs = {
        overlays = [
            spacebar.overlay
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
                        prev.runCommand "build-symlinks" { } ''
                            mkdir -p $out/bin
                            ln -s /usr/bin/xcrun /usr/bin/xcodebuild /usr/bin/tiffutil /usr/bin/qlmanage $out/bin
                        ''
                    ];
                });
            })
        ];
    };
}

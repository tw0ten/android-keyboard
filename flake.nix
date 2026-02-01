{
  description = "Android SDK";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config = {
            allowUnfree = true;
            android_sdk.accept_license = true;
          };
        };

        androidSdk = pkgs.androidenv.composeAndroidPackages {
          cmdLineToolsVersion = "10.0";
          buildToolsVersions = ["35.0.0"];
          platformVersions = ["35"];
          includeEmulator = false;
          includeSystemImages = false;
          includeSources = false;
          includeExtras = [];
        };

      in {
        devShells.default = pkgs.mkShell {
          name = "flutter-dev-shell";
          packages = with pkgs; [
            androidSdk.androidsdk
          ];

          ANDROID_SDK_ROOT = "${androidSdk.androidsdk}/libexec/android-sdk";

          shellHook = ''
          '';
        };
      });
}
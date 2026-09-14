{
  outputs =
    { self, nixpkgs }:
    let
      lib = nixpkgs.lib;
    in
    {
      devShells = lib.genAttrs lib.systems.flakeExposed (
        system:
        let
          pkgs = import nixpkgs {
            inherit system;
            config = {
              android_sdk.accept_license = true;
              allowUnfree = true;
            };
          };

          android = pkgs.androidenv.composeAndroidPackages {
            buildToolsVersions = [ "35.0.0" ];
            platformVersions = [ "36" ];
            abiVersions = [ "armeabi-v7a" ];
            includeNDK = true;
            ndkVersion = "27.0.12077973";
          };

          jdk = pkgs.openjdk17;
        in
        {
          default = pkgs.mkShell {
            packages = [
              pkgs.findutils
              pkgs.fontforge
              jdk
              android.androidsdk
              (pkgs.gradle.override { java = jdk; })
            ];

            ANDROID_SDK_ROOT = "${android.androidsdk}/libexec/android-sdk";
            JAVA_HOME = jdk.home;
          };
        }
      );
    };
}

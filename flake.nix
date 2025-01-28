{
  description = "Flutter development environment";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      pkgs = import nixpkgs {
        system = "x86_64-linux";
        config = {
          allowUnfree = true;
          android_sdk.accept_license = true;
        };
      };
      androidComposition = pkgs.androidenv.composeAndroidPackages {
        cmdLineToolsVersion = "8.0";
        toolsVersion = "26.1.1";
        platformToolsVersion = "35.0.2";
        buildToolsVersions = [ "33.0.0" ];
        includeEmulator = false;
        emulatorVersion = "30.3.4";
        platformVersions = [ "33" ];
        includeSources = false;
        includeSystemImages = false;
        systemImageTypes = [ "google_apis_playstore" ];
        abiVersions = [ "arm64-v8a" ];
        cmakeVersions = [ "3.22.1" ];
        includeNDK = true;
        ndkVersions = [ "25.1.8937393" ];
        useGoogleAPIs = false;
        useGoogleTVAddOns = false;
        includeExtras = [ "extras;google;gcm" ];
      };
    in
    {
      devShell.x86_64-linux = pkgs.mkShell {
        packages = with pkgs; [
          flutter
          openjdk
        ] ++ [ androidComposition.androidsdk ];

        shellHook = ''
          echo "Welcome to the Flutter dev environment!"
          flutter --version
          export ANDROID_HOME=${androidComposition.androidsdk}/libexec/android-sdk
          export ANDROID_NDK_HOME=$ANDROID_HOME/ndk/25.1.8937393
          export PATH=$ANDROID_HOME/platform-tools:$PATH
          yes | sdkmanager --licenses
        '';
      };
    };
}

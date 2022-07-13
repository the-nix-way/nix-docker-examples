{
  description = "A Docker image packaging a script";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        # Nixpkgs for the build system
        pkgs = import nixpkgs { inherit system; };

        # Nixpkgs for the target system
        targetSystem = "x86_64-linux";
        pkgsLinux = import nixpkgs { system = targetSystem; };

        # The default shell for x86_64-linux
        shell = pkgsLinux.runtimeShellPackage;

        # A base image with just a shell and coreutils
        baseImage = pkgs.dockerTools.buildImage {
          name = "base";
          tag = "latest";
          copyToRoot = pkgs.buildEnv {
            name = "base-env";
            paths = [
              shell
              pkgsLinux.coreutils
            ];
          };
        };

        # The script that our Docker image will wrap. The string substitutions via the
        # `substituteAll` function enable us to pass attributes into the script itself.
        script = builtins.readFile (pkgs.substituteAll {
          src = ./entrypoint.sh;
          inherit baseImage system targetSystem;
          shell = shell.shellPath;
        });

        # Our script converted to a package
        entrypoint = pkgs.writeScriptBin "entrypoint.sh" script;
      in {
        defaultPackage = pkgs.dockerTools.buildImage {
          name = "nix-docker-script";
          tag =  "v0.1.0";
          fromImage = baseImage;

          copyToRoot = pkgs.buildEnv {
            name = "script-env";
            paths = [
              entrypoint
            ];
          };

          config = {
            Entrypoint = [ "entrypoint.sh" ];
          };
        };
      }
    );
}

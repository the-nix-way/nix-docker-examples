{
  description = "A Docker image wrapping a shell script";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        # Nixpkgs for the build system
        pkgs = import nixpkgs { inherit system; };
        inherit (pkgs) substituteAll;
        inherit (pkgs.dockerTools) buildImage;

        # Nixpkgs for the target system
        targetSystem = "x86_64-linux";
        pkgsLinux = import nixpkgs { system = targetSystem; };

        # The default shell for x86_64-linux
        shell = pkgsLinux.runtimeShellPackage;

        # A base image with just a shell and coreutils. Doesn't require a tag.
        baseImage = buildImage {
          name = "shell-plus-coreutils";
          copyToRoot = [
            shell
            pkgsLinux.coreutils
          ];
        };

        # The script that our Docker image will wrap. The string substitutions via the
        # `substituteAll` function pass attributes into the script.
        script = builtins.readFile (substituteAll {
          src = ./entrypoint.sh;
          inherit system targetSystem;
          baseImageName = baseImage.imageName;
          shell = shell.shellPath;
        });

        # Our script converted to a package
        entrypoint = pkgs.writeScriptBin "entrypoint.sh" script;
      in {
        packages.default = buildImage {
          name = "nix-docker-script";
          tag =  "v0.1.0";
          fromImage = baseImage;

          copyToRoot = pkgs.buildEnv {
            name = "script-env";
            paths = [
              entrypoint
            ];
          };

          # Final image configuration
          config = {
            # This enables us to pass args to the image
            Entrypoint = [ "entrypoint.sh" ];
          };
        };
      }
    );
}

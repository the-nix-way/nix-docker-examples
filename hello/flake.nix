{
  description = "A single-package Docker image built by Nix";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        # Nixpkgs for the current system (used to build the image)
        pkgs = import nixpkgs { inherit system; };

        # Linux-specific Nixpkgs (used for the actual contents of the image)
        pkgsLinux = import nixpkgs { system = "x86_64-linux"; };

        # The package for which the image is essentially a wrapper
        hello = pkgsLinux.hello;
      in {
        defaultPackage = pkgs.dockerTools.buildImage {
          # This metadata names the image nix-docker-hello:v0.1.0
          name = "nix-docker-hello";
          tag = "v0.1.0";

          # Build an environment for the image
          # For more info: https://nixos.org/manual/nixpkgs/stable/#sec-building-environment
          contents = pkgs.buildEnv {
            name = "hello-image-env";
            paths = [
              hello
            ];
          };

          # Image configuration
          config = {
            # This enables us to pass args to the image
            Entrypoint = [ "hello" ];
          };
        };
      }
    );
}

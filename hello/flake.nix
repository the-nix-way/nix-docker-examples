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
      in {
        defaultPackage = pkgs.dockerTools.buildImage {
          name = "hello-docker";
          config = {
            Cmd = [ "${pkgsLinux.hello}/bin/hello" ];
          };
        };
      }
    );
}
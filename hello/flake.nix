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
        inherit (pkgs.dockerTools) buildImage;

        # Linux-specific Nixpkgs (used for the actual contents of the image)
        pkgsLinux = import nixpkgs { system = "x86_64-linux"; };

        # Get the image version from an external file
        version = builtins.readFile ./VERSION;
      in
      {
        packages.default = buildImage {
          # This metadata names the image nix-docker-hello:v0.1.0
          name = "nix-docker-hello";
          tag = "v${version}";

          # Final image configuration
          config.Entrypoint = [ "${pkgsLinux.hello}/bin/hello" ];
        };
      });
}

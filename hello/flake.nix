{
  description = "A single-package Docker image built by Nix";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      nixpkgsLinux = nixpkgs { inherit system; };
    in nixpkgs.dockerTools.buildImage {
      name = "hello-docker";
      config = {
        Cmd = [ "${nixpkgsLinux.hello}/bin/hello" ];
      };
    }
}
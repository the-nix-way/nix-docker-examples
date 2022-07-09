{
  description = "A Docker image packaging a script";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };

        linux = "x86_64-linux";
        pkgsLinux = import nixpkgs { system = linux; };

        shell = pkgsLinux.runtimeShellPackage;

        script = builtins.readFile (pkgs.substituteAll {
          src = ./hello.sh;
          shell = shell.shellPath;
          inherit system linux;
        });

        hello = pkgs.writeScriptBin "hello" script;
      in {
        defaultPackage = pkgs.dockerTools.buildImage {
          name = "nix-docker-script";
          tag =  "v0.1.0";

          contents = pkgs.buildEnv {
            name = "env";
            paths = [
              hello
              shell
              pkgsLinux.coreutils
            ];
          };

          config = {
            Cmd = [ "hello" ];
          };
        };
      }
    );
}

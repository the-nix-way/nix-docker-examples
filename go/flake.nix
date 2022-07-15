{
  description = "Go web service";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
    gitignore = {
      url = "github:hercules-ci/gitignore.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, flake-utils, gitignore }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        # Use system-specific Nixpkgs to build everything
        pkgs = import nixpkgs { inherit system; };
        inherit (pkgs) buildEnv;
        inherit (pkgs.dockerTools) buildImage;

        inherit (gitignore.lib) gitignoreSource;

        # The Go web service package
        goService = pkgs.buildGoModule {
          name = "go-svc";
          src = gitignoreSource ./.;
          vendorSha256 = "sha256-fwJTg/HqDAI12mF1u/BlnG52yaAlaIMzsILDDZuETrI=";
          subPackages = [ "cmd/web" ];

          # Build a Linux executable
          preBuild = ''
            export GOOS="linux"
            export CGO_ENABLED=0
          '';

          # When you build a Linux binary, the Go compiler outputs it to
          # ./linux_arm64/web instead of just ./web. This post-install step
          # removes the linux_arm64 directory.
          postInstall = ''
            mv $out/bin/linux_arm64/web $out/bin/web
            rm -rf $out/bin/linux_arm64
          '';
        };
      in {
        packages.default = buildImage {
          name = "nix-docker-go-svc";
          tag = "v0.1.0";

          copyToRoot = buildEnv {
            name = "go-svc-env";
            paths = [
              goService
            ];
          };

          config = {
            Cmd = [ "web" ];
            ExposedPorts."1111/tcp" = {};
          };
        };
      }
    );
}

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
    let
      target = {
        os = "linux";
        arch = "arm64";
      };

      buildLinuxOverlay = self: super: {
        buildGoModule = super.buildGoModule.override {
          go = super.go // {
            GOOS = target.os;
            GOARCH = target.arch;
          };
        };
      };

      inherit (gitignore.lib) gitignoreSource;
    in flake-utils.lib.eachDefaultSystem (system:
      let
        # Use system-specific Nixpkgs to build everything
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ buildLinuxOverlay ];
        };

        inherit (pkgs) buildEnv buildGoModule;
        inherit (pkgs.dockerTools) buildImage;

        # The Go web service package
        goService = buildGoModule {
          name = "go-svc";
          src = gitignoreSource ./.;
          vendorSha256 = "sha256-fwJTg/HqDAI12mF1u/BlnG52yaAlaIMzsILDDZuETrI=";
          subPackages = [ "cmd/web" ];
        };

        run = "${goService}/bin/${target.os}_${target.arch}/web";
      in {
        packages.default = buildImage {
          name = "nix-docker-go-svc";
          tag = "v0.1.0";

          config = {
            Entrypoint = [ run ];
            ExposedPorts."1111/tcp" = { };
          };
        };
      });
}

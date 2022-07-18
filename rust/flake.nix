{
  description = "Go web service";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
    rust-overlay.url = "github:oxalica/rust-overlay";
    gitignore = {
      url = "github:hercules-ci/gitignore.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    import-cargo.url = "github:edolstra/import-cargo";
  };

  outputs = { self, nixpkgs, flake-utils, rust-overlay, gitignore, import-cargo }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        readToml = file: builtins.fromTOML (builtins.readFile file);

        rustToolchain = ./rust-toolchain.toml;
        meta = (readToml ./Cargo.toml).package;
        target = builtins.head (readToml rustToolchain).toolchain.targets; # "x86_64-unknown-linux-musl"

        overlays = [
          (import rust-overlay)
        ];

        pkgs = import nixpkgs {
          inherit overlays system;
        };

        inherit (import-cargo.builders) importCargo;
        inherit (pkgs) buildEnv;
        inherit (pkgs.dockerTools) buildImage pullImage;
        inherit (pkgs.lib) fakeHash;
        inherit (pkgs.rustPlatform) buildRustPackage;
        inherit (gitignore.lib) gitignoreSource;

        rust = pkgs.rust-bin.fromRustupToolchainFile rustToolchain;

        pullAlpineImage = { version, digest, sha256 }:
          pullImage {
            imageName = "alpine";
            finalImageTag = version;
            imageDigest = digest;
            inherit sha256;
            finalImageName = "alpine";
          };

        # The Rust web service package
        rustService = buildRustPackage {
          name = meta.name;
          src = gitignoreSource ./.;
          cargoLock.lockFile = ./Cargo.lock;
          nativeBuildInputs = with pkgs; [ pkg-config ];
          release = true;
          inherit target;
        };

        alpineImage = pullAlpineImage
          { version = "3.16.0";
            digest = "sha256:4ff3ca91275773af45cb4b0834e12b7eb47d1c18f770a0b151381cd227f4c253";
            sha256 = "sha256-Cu5TDJS2tYQ3gilZWWjjpS12ZJ652UzR6Lza3SdSptI=";
          };
      in {
        packages.default = buildImage {
          name = meta.name;
          tag = meta.version;
          fromImage = alpineImage;

          copyToRoot = buildEnv {
            name = "${meta.name}-env";

            paths = [
              rustService
            ];
          };

          config = {
            Cmd = [ meta.name ];
          };
        };
      }
    );
}

{
  description = "Nix Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    rust-overlay.url = "github:oxalica/rust-overlay";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      nixpkgs,
      flake-utils,
      rust-overlay,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        overlays = [
          (import rust-overlay)
        ];
        pkgs = import nixpkgs { inherit system overlays; };
        rust-bin = pkgs.rust-bin.stable.latest.default.override {
          extensions = [
            "rust-src"
            "rust-std"
            "clippy"
            "rust-analyzer"
          ];
        };
      in
      {
        devShell = pkgs.mkShell {
          packages = [ rust-bin ];
        };
      }
    );
}

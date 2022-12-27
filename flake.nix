{
  description = "A very basic flake";
  inputs.findex-git.url = "github:mdgaziur/findex/release";
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  inputs.flake-utils = {
    inputs.nixpkgs.follows = "nixpkgs";
    url = "github:numtide/flake-utils";
  };
  inputs.naersk.url = "github:nix-community/naersk";
  outputs = {
    self,
    nixpkgs,
    findex-git,
    flake-utils,
    naersk,
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = (import nixpkgs) {
          inherit system;
        };
        naersk' = pkgs.callPackage naersk {};
      in rec {
        defaultApp = packages.findex;
        defaultPackage = packages.findex;

        packages.findex = naersk'.buildPackage {
          src = "${findex-git}/crates/findex";
          nativeBuildInputs = [];
          buildInputs = [];
        };
      }
    );
}

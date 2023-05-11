{
  description = "A very basic flake";
  inputs.findex-git = {
    url = "github:Maix0/findex/development";
    flake = false;
  };
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

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
        built = naersk'.buildPackage {
          name = "findex";
          version = "";
          src = "${findex-git}";
          nativeBuildInputs = with pkgs; [pkg-config];
          buildInputs = with pkgs; [glib gdk-pixbuf cairo pango atk gtk3 keybinder3];
        };
      in {
        apps = flake-utils.lib.mkApp {drv = built;};
        packages.default = built;
      }
    );
}

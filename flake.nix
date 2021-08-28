{
  description = "nix-odroid-n2 flake";

  inputs = {
    nixpkgs = {
      type = "github";
      owner = "NixOS";
      repo = "nixpkgs";
      ref = "04ac9dcd311956d1756d77f4baf9258392ee7bdd";
    };

    flake-utils = {
      type = "github";
      owner = "numtide";
      repo = "flake-utils";
      ref = "master";
    };
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let overlay = ( import ./packages );
          pkgs = import nixpkgs {
            inherit system;
            overlays = [ overlay ];
          };
      in rec {
        inherit overlay;
        packages = flake-utils.lib.flattenTree {
          odroid-n2-kernel-5-4 = pkgs.linuxPackages_odroid_n2_5_4.kernel;
          odroid-n2-kernel-5-10 = pkgs.linuxPackages_odroid_n2_5_10.kernel;
          uboot_odroid_n2 = pkgs.uboot_odroid_n2;
        };

        devShell = import ./shell.nix { inherit pkgs; };

        defaultPackage = packages.odroid-n2-kernel-5-4;
      }
    );

  # nix build
  # nix build .#packages.aarch64-linux.odroid-n2-kernel-5-4
  # ...
}

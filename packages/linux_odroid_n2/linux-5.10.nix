{ stdenv, callPackage, ubootTools, lib, ... } @ args:

with (import ./patch/default.nix lib);

callPackage ./configure.nix {

  inherit stdenv ubootTools;

  configfile = ./linux-5.10.config;

  kernel = callPackage <nixpkgs/pkgs/os-specific/linux/kernel/linux-5.10.nix> {
    kernelPatches = (patchsets [
      "armbian/5.10"
    ]);

    NIX_CFLAGS_COMPILE = toString [
      "-mcpu=native"
    ];
  };
}

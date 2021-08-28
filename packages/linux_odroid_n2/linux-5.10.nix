{ stdenv, callPackage, ubootTools, pkgs, lib, ... } @ args:

with (import ./patch/default.nix lib);

let kernel-path = "${toString pkgs.path}/pkgs/os-specific/linux/kernel/linux-5.10.nix";
    kernel-pkgs = import kernel-path;
in callPackage ./configure.nix {

  inherit stdenv ubootTools lib;

  configfile = ./linux-5.4.config;

  kernel = callPackage kernel-pkgs {
    NIX_CFLAGS_COMPILE = toString [
      "-mcpu=native"
    ];
  };
}

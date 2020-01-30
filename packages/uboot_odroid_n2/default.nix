{ buildUBoot, ethaddr ? null, stdenv, fetchFromGitLab, ... } @ args:

let
  extra = ./extra;
  ethaddr_ = if (ethaddr == null) then "" else ethaddr;
in
buildUBoot {
  version = "v2019.10";
  src = fetchFromGitLab {
    domain = "gitlab.denx.de";
    owner = "u-boot";
    repo = "u-boot";
    rev = "61ba1244b548463dbfb3c5285b6b22e7c772c5bd";
    sha256 = "0fj1dgg6nlxkxhjl1ir0ksq6mbkjj962biv50p6zh71mhbi304in";
  };
  defconfig = "odroid-n2_defconfig";
  extraMeta.platforms = [ "aarch64-linux" ];
  filesToInstall = [ "u-boot.bin.sd.bin" ];
  extraPatches = [ 
        ./extra/meson_g12a_gic.patch
	./extra/meson_pwrseq.patch
  ];
  # TODO workout what the /tmp error is
  preBuild = ''
  cp -Rf ${extra} extra
  sedw() {
        echo patching $2 ...
	cp $2 /tmp/.sedw
        sed -ibk "$1" /tmp/.sedw
        chmod +w $2
        cat /tmp/.sedw > $2
        rm /tmp/.sedw || true
  }
  if [[ "${ethaddr_}" != "" ]]; then
    sedw 's|"distro_bootcmd="\(.*\)\\|"setenv ethaddr ${ethaddr_};"\\\n        "distro_bootcmd=" \1 \\|' include/config_distro_bootcmd.h
  fi
  for path in ./extra/pack.sh ./extra/fip/blx_fix.sh; do
    sedw 's|#!/usr/bin/env bash|#!${args.bash}/bin/bash|' $path
  done
  '';
  postBuild = ''
    chmod -Rf ug+w extra
    ./extra/pack.sh
  '';
  installPhase = ''
    mkdir -p $out
    cp extra/fip/u-boot.bin.sd.bin $out
  '';
}

{ pkgs, ... }:

let gcc-linaro = (pkgs.stdenv.mkDerivation rec {
      name = "gcc-linaro";
      version = "7.4-2019.02";
      version-detail = "7.4.1-2019.02";
      aarch64 = "aarch64-linux-gnu";
      archi = "x86_64_${aarch64}";
      filename = "${name}-${version-detail}-${archi}";

      src = pkgs.fetchurl {
        url = "https://releases.linaro.org/components/toolchain/binaries/${version}/${aarch64}/${filename}.tar.xz";
        sha256 = "1azr3fngq1ih2pkiwxllkkfzgllwwlfw3c6ly3l1mmhy94ndrw97";
      };

      unpackPhase = "echo 'UNPACK -> noop!'";
      configurePhase = "echo 'CONFIGURE -> noop!'";
      buildPhase = "echo 'BUILD -> noop!'";

      installPhase = ''
echo "INSTALL -> Install binaries from the archive"
# https://wiki.odroid.com/odroid-n2/software/building_kernel
tar Jxvf $src ${filename}/bin
mkdir -p $out/bin/
mv -v ${filename}/bin/* $out/bin/

      '';
    });

in pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
    gcc-linaro
  ];

  ARCH="arm64";
  CROSS_COMPILE="aarch64-linux-gnu-";

}

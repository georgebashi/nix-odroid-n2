self: super:
{

  # linuxPackages_odroid_n2_5_4 = self.linuxPackagesFor (super.callPackage ./linux_odroid_n2/linux-5.4.nix {});

  # linuxPackages_odroid_n2_5_6 = self.linuxPackagesFor (super.callPackage ./linux_odroid_n2/linux-5.6.nix {});

  linuxPackages_odroid_n2_5_10 = self.linuxPackagesFor (super.callPackage ./linux_odroid_n2/linux-5.10.nix {});

  uboot_odroid_n2 = super.callPackage ./uboot_odroid_n2 {};
}

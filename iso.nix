{ pkgs, lib, config, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/cd-dvd/installation-cd-base.nix")
  ];

  disabledModules = [
    "profiles/base.nix"
  ];

  nixpkgs.overlays = [ (import ./packages) ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  networking.hostName = "nixos-stura";

  boot.supportedFilesystems =
    [ "btrfs" "cifs" "f2fs" "jfs" "ntfs" "reiserfs" "vfat" "xfs" ] ++
    lib.optional (lib.meta.availableOn pkgs.stdenv.hostPlatform config.boot.zfs.package) "zfs";

  # Configure host id for ZFS to work
  networking.hostId = lib.mkDefault "8425e349";

  environment.systemPackages = with pkgs; [
    w3m-nographics # needed for the manual anyway
    testdisk # useful for repairing boot problems
    ms-sys # for writing Microsoft boot sectors / MBRs
    efibootmgr
    efivar
    htop
    parted
    gptfdisk
    ddrescue
    ccrypt
    cryptsetup # needed for dm-crypt volumes

    # Some text editors.
    (vim.customize {
      name = "vim";
      vimrcConfig.customRC = ''
        filetype plugin indent on
        set tabstop=4
        set shiftwidth=4
        set expandtab
        set modeline
        set modelines=1
        set encoding=utf-8
        syntax on
        au BufRead,BufNewFile *.nix set ts=2 sw=2
      '';
    })

    # Some networking tools.
    fuse
    fuse3
    sshfs-fuse
    socat
    screen
    tcpdump

    # Hardware-related tools.
    sdparm
    hdparm
    smartmontools # for diagnosing hard disks
    pciutils
    usbutils
    nvme-cli

    # Some compression/archiver tools.
    unzip
    zip

    # own tools
    stura-configure-net
    stura-default-config
  ];

  time.timeZone = "Europe/Berlin";

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "de-latin1";
  };

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOV4f3/OcNQIHqomvH0nGLDmXDlrO/u7JKE9Fgq2Vuqs me@netali.de"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDQD1kCdE0IWOt9Xg3J7PgkaDFQ1NWNRPM7dRy2R4sGm marc@schlagenhauf.net"
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDoO+UrsXqPkkRX7C/qNsfw7Hmly1JuZe+gdh+2RYNfjPotLMkTvyYs7YeUmm55tP+jD8PCElMiix9e2jPGbBMX6b90iAh58E6f+AEtRQmTXAJouyj+NzHqSdlLd8ULYBnDftgOC9EpixN+Gjr7v9gkqskt0tT2feff9K49LRtFCqSOMilhlOGJ4ph6yaQ3P1oMv+EFTkUf3zBzXN7QsRE4epm6pfoAUe3ZJ4LMvAb8ki/jB0ywZpXVTeHN5w5cSYSYojdbo4xqHakzFGsw+uikiVCKwW6YBFblbQD73mRnvZoW3c3+F4NtY0tWakUjSrI1gTeVhjyQ4qlXM6bibPUNu9ZukTa9BzKFc2vwiSk7FKqlAXRF4WBWE8h/s+Fj4NCzVP9ebXRffQ7TAUg80ObuCwQcRSPsofzaHrb+/K7rAiLh4GymJHLb9pN7fJ3si0oezBpuXT9O1utoFMTi4wrIwVaTZhpHDMm6oDv3ZK7tRDrUtqLnWDlDWJMPhxN/nTRCWsmBPUa62kaEr9HFGntq7uosuLGmyn87pyLcb1/1Q9Cr4n+3k7m2f2XEXRmWNLFXmk7An0qu5dwQTUUO74jJK/tqViF5Cx6+laVPLXEDc1ru8rCZ3Ze0JsJ8g667qFfFRdRvKrHw8IkYzlAmDjZAoRU03JkDDoMqfpN7bCMyGw== lukas@yoga"
  ];

  networking.dhcpcd.enable = false;
  networking.useDHCP = false;
}

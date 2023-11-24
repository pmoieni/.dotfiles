{ inputs
, lib
, config
, pkgs
, ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  nixpkgs = {
    overlays = [ ];
    config = {
      allowUnfree = true;
    };
  };

  nix = {
    settings = {
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
    };
    registry = (lib.mapAttrs (_: flake: { inherit flake; })) ((lib.filterAttrs (_: lib.isType "flake")) inputs);
    nixPath = [ "/etc/nix/path" ];
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  boot = {
    kernelParams = [
      "mem_sleep_default=deep"
    ];
    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
      grub = {
        enable = true;
        devices = [ "nodev" ];
        efiSupport = true;
        useOSProber = true;
      };
    };
    supportedFilesystems = [ "ntfs" ];
  };

  users.users = {
    pmoieni = {
      isNormalUser = true;
      initialPassword = "password";
      description = "Parham Moieni";
      extraGroups = [ "networkmanager" "wheel" "video" "audio" "lp" "scanner" ];
    };
  };

  time.timeZone = "Asia/Tehran";

  i18n.defaultLocale = "en_US.UTF-8";

  services = {
    thermald.enable = true;
    power-profiles-daemon.enable = false; # conflicts with tlp
    tlp = {
      enable = true;
      settings = {
        START_CHARGE_THRESH_BAT0 = 0; # dummy value
        STOP_CHARGE_THRESH_BAT0 = 80;
        START_CHARGE_THRESH_BAT1 = 0; # dummy value
        STOP_CHARGE_THRESH_BAT1 = 80;
      };
    };
    xserver = {
      enable = true;
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
      layout = "us,ir";
      xkbVariant = "";
      xkbOptions = "grp:win_space_toggle";
      libinput.enable = true;
      videoDrivers = [ "nvidia" ];
    };
    printing.enable = true;
    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
      jack.enable = true;
    };
    flatpak.enable = true;
  };

  hardware = {
    pulseaudio.enable = false;
    bluetooth = {
      enable = true;
      settings = {
        General = {
          Enable = "Source,Sink,Media,Socket";
        };
      };
      powerOnBoot = false;
    };
    cpu.intel.updateMicrocode = true;
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [
        intel-media-driver # LIBVA_DRIVER_NAME=iHD
        vaapiIntel # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
        vaapiVdpau
        libvdpau-va-gl
      ];
    };
    nvidia = {
      # Modesetting is required.
      modesetting.enable = true;
      # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
      powerManagement.enable = false;
      # Fine-grained power management. Turns off GPU when not in use.
      # Experimental and only works on modern Nvidia GPUs (Turing or newer).
      powerManagement.finegrained = false;
      # Use the NVidia open source kernel module (not to be confused with the
      # independent third-party "nouveau" open source driver).
      # Support is limited to the Turing and later architectures. Full list of 
      # supported GPUs is at: 
      # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
      # Only available from driver 515.43.04+
      # Currently alpha-quality/buggy, so false is currently the recommended setting.
      open = false;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
      prime = {
        offload = {
          enable = true;
          enableOffloadCmd = true;
        };
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };
  };

  environment = {
    etc =
      lib.mapAttrs'
        (name: value: {
          name = "nix/path/${name}";
          value.source = value.flake;
        })
        config.nix.registry;
    systemPackages = with pkgs; [
      vim
      wget
      curl
      zip
      unzip
      gzip
      gnupg
      coreutils
      pciutils
      nettools
      firefox-bin
      dconf
      gnome.adwaita-icon-theme
      wayland
      xdg-utils
      wl-clipboard
      grim
      slurp
      swaylock
      swayidle
      glib
      river
      waybar
      wofi
      swaylock
      swaynotificationcenter
      kanshi
    ];
    gnome.excludePackages = (with pkgs; [
      gnome-tour
    ]) ++ (with pkgs.gnome; [
      epiphany # web browser
      geary # email reader
      totem # video player
      tali # poker game
      iagno # go game
      hitori # sudoku game
      atomix # puzzle game
    ]);
    sessionVariables.NIXOS_OZONE_WL = "1";
  };

  # change to fonts.packages for unstable
  fonts.fonts = with pkgs; [
    (nerdfonts.override { fonts = [ "FiraCode" "JetBrainsMono" ]; })
  ];

  # programs = {
  #     hyprland = {
  #         enable = true;
  #         nvidiaPatches = true;
  #         xwayland = {
  #             enable = true;
  #             hidpi = true;
  #         };
  #     };   
  # };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.05";
}

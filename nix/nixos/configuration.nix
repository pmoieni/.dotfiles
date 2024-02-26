{ inputs
, lib
, config
, pkgs
, ...
}:
let
  killhypr = pkgs.writeTextFile {
    name = "killhypr";
    destination = "/bin/killhypr";
    executable = true;
    text = ''
      hyprctl dispatch exit 0
      sleep 2
      if pgrep -x Hyprland >/dev/null; then
          killall -9 Hyprland
      fi
    '';
  };
in
{
  imports = [
    ./hardware-configuration.nix
  ];

  nixpkgs = {
    overlays = [ ];
    config = {
      allowAliases = false;
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
    asusd = {
      enable = true;
      enableUserService = true;
    };
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
      displayManager.gdm = {
        enable = true;
        wayland = true;
      };
      # displayManager.sddm.enable = true;
      # displayManager.defaultSession = "plasmawayland";
      # desktopManager.plasma5.enable = true;
      desktopManager.gnome.enable = true;
      xkb.layout = "us,ir";
      xkb.variant = "";
      xkb.options = "grp:win_space_toggle";
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
    dbus.enable = true;
    flatpak.enable = true;
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    # gtk portal needed to make gtk apps happy
    # extraPortals = [ pkgs.xdg-desktop-portal-gtk ]; # not required when using Gnome
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
        # vaapiIntel # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium) # not working anymore
        vaapiVdpau
        libvdpau-va-gl
      ];
    };
    nvidia = {
      # Modesetting is required.
      modesetting.enable = true;
      # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
      powerManagement.enable = true;
      # Fine-grained power management. Turns off GPU when not in use.
      # Experimental and only works on modern Nvidia GPUs (Turing or newer).
      powerManagement.finegrained = true;
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

  security = {
    rtkit.enable = true;
    polkit.enable = true;
    pam.loginLimits = [
      { domain = "@users"; item = "rtprio"; type = "-"; value = 1; }
    ];
  };

  environment = {
    etc =
      lib.mapAttrs'
        (name: value: {
          name = "nix/path/${name}";
          value.source = value.flake;
        })
        config.nix.registry;
    gnome.excludePackages = (with pkgs; [
      # gnome-photos
      gnome-tour
    ]) ++ (with pkgs.gnome; [
      # cheese # webcam tool
      # gnome-music
      # gnome-terminal
      # gedit # text editor
      # epiphany # web browser
      # geary # email reader
      # evince # document viewer
      # gnome-characters
      # totem # video player
      tali # poker game
      iagno # go game
      hitori # sudoku game
      atomix # puzzle game
    ]);
    systemPackages = ([
      killhypr
    ]) ++ (with pkgs; [
      # base
      vim
      htop
      wget
      curl
      zip
      unzip
      gzip
      gnupg
      git
      killall
      coreutils-full
      procps
      pciutils
      nettools
      firefox-bin
      dconf
      gnome.gnome-tweaks
      gnome.adwaita-icon-theme
      xdg-utils
      glib
      wl-clipboard
      libnotify
      gcc
      gnumake
      meson
      cmake
      ninja
      fd
      jq
      fzf

      # utilities
      pavucontrol
      brightnessctl
      playerctl
      cliphist
      tokei
      yt-dlp
      ripgrep
      hyperfine
      neovim
      ncdu
      alsa-utils
      pamixer
      dart-sass
      imagemagick
      ffmpeg-full

      # desktop
      swaylock
      swayidle
      grim
      slurp
      libsForQt5.qt5ct
      rose-pine-gtk-theme
      gtk3.dev
      inputs.matugen.packages.${system}.default
      wl-screenrec
      swappy
      swaybg # variety doesn't work without it
    ]);
    sessionVariables.NIXOS_OZONE_WL = "1";
  };

  systemd = {
    user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };

  programs = {
    hyprland.enable = true;
  };

  # change to fonts.fonts for 23.05 or older, else font.packages
  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "FiraCode" "JetBrainsMono" ]; })
  ];

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.05";
}

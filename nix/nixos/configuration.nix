{ inputs
, lib
, config
, pkgs
, pkgs-unstable
, ...
}:
let
  # bash script to let dbus know about important env variables and
  # propagate them to relevent services run at the end of sway config
  # see
  # https://github.com/emersion/xdg-desktop-portal-wlr/wiki/"It-doesn't-work"-Troubleshooting-Checklist
  # note: this is pretty much the same as  /etc/sway/config.d/nixos.conf but also restarts  
  # some user services to make sure they have the correct environment variables
  dbus-sway-environment = pkgs.writeTextFile {
    name = "dbus-sway-environment";
    destination = "/bin/dbus-sway-environment";
    executable = true;
    text = ''
      val=$(udevadm info -a -n /dev/dri/card1 | grep boot_vga | rev | cut -c 2)
      export WLR_DRM_DEVICES="/dev/dri/card$val"
      export QT_QPA_PLATFORM=wayland
      export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
      dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=sway
      systemctl --user stop pipewire xdg-desktop-portal xdg-desktop-portal-wlr
      systemctl --user start pipewire xdg-desktop-portal xdg-desktop-portal-wlr
    '';
  };

  # currently, there is some friction between sway and gtk:
  # https://github.com/swaywm/sway/wiki/GTK-3-settings-on-Wayland
  # the suggested way to set gtk settings is with gsettings
  # for gsettings to work, we need to tell it where the schemas are
  # using the XDG_DATA_DIR environment variable
  # run at the end of sway config
  configure-theme = pkgs.writeTextFile {
    name = "configure-theme";
    destination = "/bin/configure-theme";
    executable = true;
    text =
      let
        schema = pkgs.gsettings-desktop-schemas;
        datadir = "${schema}/share/gsettings-schemas/${schema.name}";
      in
      ''
        export XDG_DATA_DIRS=${datadir}:$XDG_DATA_DIRS
        gnome_schema=org.gnome.desktop.interface
        gsettings set $gnome_schema gtk-theme 'rose-pine'
        gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
      '';
  };
in
{
  imports = [
    ./hardware-configuration.nix
  ];

  nix = {
    settings = {
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
      substituters = [ "https://hyprland.cachix.org" ];
      trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
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
    power-profiles-daemon.enable = true; # conflicts with tlp
    tlp = {
      enable = false;
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
      inputs.hypridle.packages.${pkgs.stdenv.hostPlatform.system}.hypridle
      inputs.hyprlock.packages.${pkgs.stdenv.hostPlatform.system}.hyprlock
    ]) ++ (with pkgs-unstable; [
      grim
      slurp
      wl-screenrec
      swappy
      swaybg # variety doesn't work without it
      dart-sass
    ]) ++ (with pkgs; [
      # base
      vim
      htop
      wget
      curl
      dig
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
      dconf
      gnome.gnome-tweaks
      gnome.adwaita-icon-theme
      rose-pine-gtk-theme
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
      firefox-bin

      # utilities
      pavucontrol
      brightnessctl
      playerctl
      cliphist
      tokei
      yt-dlp
      ripgrep
      hyperfine
      ncdu
      alsa-utils
      pamixer
      imagemagick
      ffmpeg-full

      # desktop 
      libsForQt5.qt5ct
      gtk3.dev
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
    hyprland =
      let
        hypr-pkgs = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system};
      in
      {
        enable = true;
        package = hypr-pkgs.hyprland;
        portalPackage = hypr-pkgs.xdg-desktop-portal-hyprland;
      };
    sway = {
      enable = false;
      wrapperFeatures.gtk = true;
      extraOptions = [ "--unsupported-gpu" ];
      extraPackages = [
        dbus-sway-environment
        configure-theme
      ];
    };
  };

  virtualisation = {
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  # change to fonts.fonts for 23.05 or older, else font.packages
  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "FiraCode" "JetBrainsMono" "Ubuntu" "IBMPlexMono" ]; })
  ];

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  # answer: only when reinstalling Nix with the latest ISO
  system.stateVersion = "23.05";
}

{ inputs
, lib
, config
, pkgs
, ...
}: {
  imports = [ ];

  nixpkgs = {
    overlays = [ ];
    config = {
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

  home = {
    username = "pmoieni";
    homeDirectory = "/home/pmoieni";
    packages = with pkgs; [
      # shell / terminal
      fish
      tmux
      zellij

      # CLI tools
      fd
      fzf
      tokei
      yt-dlp
      ripgrep
      hyperfine
      neovim
      ncdu
      jq
      alsa-utils
      pamixer
      imagemagick

      # dev tools
      gh
      nodePackages.eslint
      nodePackages.eslint_d
      nodePackages.prettier
      go
      golangci-lint
      jdk21
      rustup
      nodejs
      yarn
      bun
      clang_17
      clang-tools_17

      # LSP
      lua-language-server
      gopls
      jdt-language-server
      rnix-lsp
      nodePackages.svelte-language-server
      nodePackages.typescript-language-server

      # desktop
      swaylock
      swayidle
      swaybg
      swaynotificationcenter
      waybar
      eww-wayland
      wofi
      grim
      slurp
      kanshi
      peek
      libsForQt5.qt5ct
      rose-pine-gtk-theme

      # apps
      xfce.thunar
      gparted
      mpv
      vlc
      gimp
      obs-studio
      variety
      wezterm
      alacritty
      telegram-desktop
      microsoft-edge
      tor-browser
      vscode
      slack
      element-desktop

      # other
      # hplipWithPlugin
    ];
    pointerCursor = {
      package = pkgs.gnome.adwaita-icon-theme;
      name = "Adwaita";
      size = 24;
    };
  };

  programs = {
    home-manager.enable = true;
    git = {
      enable = true;
      userName = "Parham Moieni";
      userEmail = "62774242+pmoieni@users.noreply.github.com";
    };
  };

  dconf.settings = {
    "org/gnome/mutter" = {
      experimental-features = [ "scale-monitor-framebuffer" ];
    };
    "org/gnome/desktop/interface".color-scheme = "prefer-dark";
  };

  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}

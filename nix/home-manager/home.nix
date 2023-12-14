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
      neofetch
      fish
      tmux

      # CLI tools
      fd
      fzf
      tokei
      yt-dlp
      ripgrep
      hyperfine
      neovim

      # build tools
      cmake
      # gcc
      gnumake
      meson

      # dev tools
      gh
      nodePackages.eslint
      nodePackages.eslint_d
      nodePackages.prettier
      go
      jdk21
      # libllvm
      # lldb
      # libcxx
      # libcxxStdenv
      # libclang
      clang
      clang-tools
      rustup
      nodejs
      yarn
      bun

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
      rose-pine-gtk-theme

      # apps
      gparted
      mpv
      vlc
      gimp
      audacity
      libreoffice
      obs-studio
      variety
      wezterm
      alacritty
      contour
      telegram-desktop
      microsoft-edge
      tor-browser
      vscode
      jetbrains.idea-community
      slack
      discord
      spotify
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
  };

  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}

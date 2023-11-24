{ inputs
, lib
, config
, pkgs
, unstable
, ...
}: {
  imports = [ ];

  nixpkgs = {
    overlays = [
      inputs.neovim-nightly-overlay.overlay
    ];
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
      unstable.fish
      unstable.tmux

      # CLI tools
      fd
      fzf
      tokei
      yt-dlp
      ripgrep
      unstable.neovim

      # build tools
      cmake
      gcc
      gnumake
      meson

      # dev tools
      unstable.gh
      unstable.nodePackages.eslint
      unstable.nodePackages.eslint_d
      unstable.nodePackages.prettier
      unstable.go
      jdk17
      unstable.rustup
      unstable.nodejs
      unstable.yarn

      # LSP
      unstable.lua-language-server
      unstable.gopls
      unstable.jdt-language-server
      unstable.rnix-lsp
      unstable.nodePackages.svelte-language-server
      unstable.nodePackages.typescript-language-server

      # apps
      gparted
      mpv
      obs-studio
      unstable.wezterm
      unstable.alacritty
      unstable.telegram-desktop
      unstable.microsoft-edge
      unstable.tor-browser
      unstable.vscode
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

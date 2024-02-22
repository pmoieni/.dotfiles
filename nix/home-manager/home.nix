{ inputs
, lib
, config
, pkgs
, ...
}: {
  imports = [
    inputs.ags.homeManagerModules.default
  ];

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

      # dev tools
      gh
      nodePackages.eslint_d
      nodePackages.prettier
      go
      golangci-lint
      elixir
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
      elixir-ls
      jdt-language-server
      rnix-lsp
      nodePackages.svelte-language-server
      nodePackages.typescript-language-server
      nodePackages.bash-language-server
      vscode-langservers-extracted
      tailwindcss-language-server

      # apps
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
    ags = {
      enable = true;
      extraPackages = with pkgs; [
        gtksourceview
        webkitgtk
        accountsservice
      ];
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

{ inputs
, lib
, config
, pkgs
, pkgs-unstable
, ...
}: {
  imports = [
    inputs.ags.homeManagerModules.default
  ];

  home = {
    username = "pmoieni";
    homeDirectory = "/home/pmoieni";
    packages = (with pkgs; [
      # shell / terminal
      fish
      tmux

      # apps
      gparted
      mpv
      vlc
      gimp
      obs-studio
      variety
    ]) ++ (with pkgs-unstable; [
      # shell / terminal
      neovim

      # dev tools
      gh
      nodePackages.eslint_d
      nodePackages.prettier
      prettierd
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

      #apps
      wezterm
      alacritty
      telegram-desktop
      microsoft-edge
      tor-browser
      slack
      element-desktop
      spotify
    ]);
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

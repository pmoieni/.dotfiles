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
    overlays = [
      (final: prev: {
        unstable = import inputs.unstable {
          system = final.system;
          config = {
            allowUnfree = true;
            allowUnfreePredicate = _: true;
          };
        };
      })
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
      fish
      tmux
      unstable.neovim

      # dev tools
      unstable.gh
      unstable.nodePackages.eslint_d
      unstable.nodePackages.prettier
      unstable.prettierd
      unstable.go
      unstable.golangci-lint
      unstable.elixir
      unstable.jdk21
      unstable.rustup
      unstable.nodejs
      unstable.yarn
      unstable.bun
      unstable.clang_17
      unstable.clang-tools_17

      # LSP
      unstable.lua-language-server
      unstable.gopls
      unstable.elixir-ls
      unstable.jdt-language-server
      unstable.rnix-lsp
      unstable.nodePackages.svelte-language-server
      unstable.nodePackages.typescript-language-server
      unstable.nodePackages.bash-language-server
      unstable.vscode-langservers-extracted
      unstable.tailwindcss-language-server

      # apps
      gparted
      mpv
      vlc
      gimp
      obs-studio
      variety
      unstable.wezterm
      unstable.alacritty
      unstable.telegram-desktop
      unstable.microsoft-edge
      unstable.tor-browser
      unstable.vscode
      unstable.slack
      unstable.element-desktop
      unstable.spotify

      # other
      unstable.swaylock
      unstable.swayidle
      unstable.grim
      unstable.slurp
      unstable.wl-screenrec
      unstable.swappy
      unstable.swaybg # variety doesn't work without it
      unstable.dart-sass
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

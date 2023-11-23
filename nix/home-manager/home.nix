{
    inputs,
    lib,
    config,
    pkgs,
    unstable,
    ...
}: {
    imports = [];

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
            neovim

            # build tools
            cmake
            gcc
            gnumake
            meson

            # dev tools
            unstable.gh
            nodePackages.eslint
            nodePackages.eslint_d
            nodePackages.prettier
            unstable.go
	        unstable.rustup
	        unstable.nodejs
            unstable.yarn

            # LSP
            lua-language-server
            gopls
            rnix-lsp
			nodePackages.svelte-language-server
			nodePackages.typescript-language-server
        
            # apps
            gparted
            mpv
            obs-studio
            unstable.wezterm
            unstable.alacritty
            unstable.telegram-desktop
        ];
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

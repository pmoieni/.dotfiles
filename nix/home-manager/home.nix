{
    inputs,
    lib,
    config,
    pkgs,
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
            fish
            tmux

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
            gh
            nodePackages.eslint
            nodePackages.eslint_d
            nodePackages.prettier
            go
	        rustup
	        nodejs
            yarn

            # LSP
            lua-language-server
            gopls
            rnix-lsp
			nodePackages.svelte-language-server
			nodePackages.typescript-language-server
        
            # desktop
            river
            waybar
            wofi
            swaylock
            swaynotificationcenter
            kanshi

            # apps
            gparted
            mpv
            obs-studio
            wezterm
            telegram-desktop

            # extra
            fira-code
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

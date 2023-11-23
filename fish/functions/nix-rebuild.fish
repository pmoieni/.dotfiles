function nix-rebuild -d "rebuild nix config"
    pushd $HOME/.dotfiles/nix
    time sudo nixos-rebuild switch --flake .#nixos
    popd
end

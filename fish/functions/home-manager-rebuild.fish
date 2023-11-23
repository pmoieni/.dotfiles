function home-manager-rebuild -d "rebuild home manager config"
    pushd $HOME/.dotfiles/nix
    time home-manager switch --flake .#pmoieni@nixos
    popd
end

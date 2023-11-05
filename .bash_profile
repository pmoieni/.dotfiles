#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

if [ $DESKTOP_SESSION == "river" ]; then
    export XDG_CURRENT_DESKTOP="river"
    export GTK_THEME="rose-pine-gtk"
    export QT_QPA_PLATFORMTHEME="qt5ct"
    export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
    export QT_QPA_PLATFORM="wayland;xcb"
    export GDK_BACKEND="wayland,x11"
    export TERM="wezterm"
fi
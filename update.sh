rm -r -f ~/.local/share/plasma/plasmoids/com.github.MauroPello.onedrive-applet
mkdir -p ~/.local/share/plasma/plasmoids/com.github.MauroPello.onedrive-applet
cp -r package/* ~/.local/share/plasma/plasmoids/com.github.MauroPello.onedrive-applet
plasmashell --replace &

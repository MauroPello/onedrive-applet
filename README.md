# onedrive-applet
Simple KDE applet to upload and download files from onedrive on linux

source ./update.sh
source ./remove.sh

to install the icons run this in the terminal:
```
xdg-icon-resource install --size 128 onedrive.png
xdg-icon-resource install --size 128 onedrive-upload.png
xdg-icon-resource install --size 128 onedrive-download.png
```

to install the plasmoid run ./install.sh in the terminal
to uninstall the plasmoid run ./uninstall.sh in the terminal

you maybe need to execute:
```
chmod +x install.sh
chmod +x uninstall.sh
```
in order to use the scripts
# onedrive-applet
Simple KDE applet to upload and download files from onedrive on linux using the onedrive-abraunegg cli tool

To install the icons run this in the terminal:
```
xdg-icon-resource install --size 32 --novendor Icons/32x32/onedrive.png
xdg-icon-resource install --size 32 --novendor Icons/32x32/onedrive-upload.png
xdg-icon-resource install --size 32 --novendor Icons/32x32/onedrive-download.png
xdg-icon-resource install --size 48 --novendor Icons/48x48/onedrive.png
xdg-icon-resource install --size 48 --novendor Icons/48x48/onedrive-upload.png
xdg-icon-resource install --size 48 --novendor Icons/48x48/onedrive-download.png
xdg-icon-resource install --size 64 --novendor Icons/64x64/onedrive.png
xdg-icon-resource install --size 64 --novendor Icons/64x64/onedrive-upload.png
xdg-icon-resource install --size 64 --novendor Icons/64x64/onedrive-download.png
xdg-icon-resource install --size 128 --novendor Icons/128x128/onedrive.png
xdg-icon-resource install --size 128 --novendor Icons/128x128/onedrive-upload.png
xdg-icon-resource install --size 128 --novendor Icons/128x128/onedrive-download.png
xdg-icon-resource install --size 96 --novendor Icons/96x96/onedrive.png
xdg-icon-resource install --size 96 --novendor Icons/96x96/onedrive-upload.png
xdg-icon-resource install --size 96 --novendor Icons/96x96/onedrive-download.png
```

To install the plasmoid run ./install.sh in the terminal.
To uninstall the plasmoid run ./uninstall.sh in the terminal.
After installing or uninstalling the plasmoid run
```
plasmashell --replace &
```
in order to reload the plasma session
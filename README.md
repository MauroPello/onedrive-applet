# onedrive-applet
Simple KDE applet to upload and download files from onedrive on linux using the onedrive-abraunegg cli tool

To install the icons run this in the terminal:
```
xdg-icon-resource install --size 16 --novendor onedrive.png
xdg-icon-resource install --size 16 --novendor onedrive-upload.png
xdg-icon-resource install --size 16 --novendor onedrive-download.png
xdg-icon-resource install --size 24 --novendor onedrive.png
xdg-icon-resource install --size 24 --novendor onedrive-upload.png
xdg-icon-resource install --size 24 --novendor onedrive-download.png
xdg-icon-resource install --size 32 --novendor onedrive.png
xdg-icon-resource install --size 32 --novendor onedrive-upload.png
xdg-icon-resource install --size 32 --novendor onedrive-download.png
xdg-icon-resource install --size 48 --novendor onedrive.png
xdg-icon-resource install --size 48 --novendor onedrive-upload.png
xdg-icon-resource install --size 48 --novendor onedrive-download.png
xdg-icon-resource install --size 64 --novendor onedrive.png
xdg-icon-resource install --size 64 --novendor onedrive-upload.png
xdg-icon-resource install --size 64 --novendor onedrive-download.png
xdg-icon-resource install --size 128 --novendor onedrive.png
xdg-icon-resource install --size 128 --novendor onedrive-upload.png
xdg-icon-resource install --size 128 --novendor onedrive-download.png
xdg-icon-resource install --size 192 --novendor onedrive.png
xdg-icon-resource install --size 192 --novendor onedrive-upload.png
xdg-icon-resource install --size 192 --novendor onedrive-download.png
```

To install the plasmoid run ./install.sh in the terminal.
To uninstall the plasmoid run ./uninstall.sh in the terminal.
After installing or uninstalling the plasmoid run
```
plasmashell --replace &
```
in order to reload the plasma session
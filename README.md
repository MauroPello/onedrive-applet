# onedrive-applet
Simple KDE applet to upload and download files from onedrive on linux using the onedrive-abraunegg cli tool

To install the icons run this in the terminal:
```
xdg-icon-resource install --size 128 onedrive.png
xdg-icon-resource install --size 128 onedrive-upload.png
xdg-icon-resource install --size 128 onedrive-download.png
```

To install the plasmoid run ./install.sh in the terminal.
To uninstall the plasmoid run ./uninstall.sh in the terminal.
After installing or uninstalling the plasmoid run
```
plasmashell --replace &
```
in order to reload the plasma session
# onedrive-applet
Simple KDE applet to upload and download files from onedrive on linux using the onedrive-abraunegg cli tool

To install the plasmoid run ./install.sh in the terminal.
To uninstall the plasmoid run ./uninstall.sh in the terminal.
After installing or uninstalling the plasmoid run
```
plasmashell --replace &
```
in order to reload the plasma session

## Requirements
In order to sync your files with onedrive you need the onedrive-abraunegg linux client up to date. If you want to use the "Stop syncing" button you need the killall command to be available in your linux system

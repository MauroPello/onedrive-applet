import QtQuick 2.0
import QtQuick.Controls 2.3 as QControls
import QtQuick.Layouts 1.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 3.0 as PlasmaComponents3
import org.kde.plasma.plasmoid 2.0

import "handler.js" as Handler

GridLayout {
    // arranging two columns for the buttons to be side by side
    columns: 2
    // filling the fullRepresentation
    anchors.fill: parent

    // checkbox for dry-run mode
    PlasmaComponents3.CheckBox {
        id: dryrunCb
        text: " Dry-run mode"
        font.pointSize: 12
        checked: false
        indicator.width: PlasmaCore.Units.iconSizes.smallMedium
        indicator.height: PlasmaCore.Units.iconSizes.smallMedium
        Layout.columnSpan: 2
        Layout.alignment: Qt.AlignHCenter
        Layout.topMargin: PlasmaCore.Units.largeSpacing * 2
    }

    // upload button
    PlasmaComponents3.Button {
        id: uploadBtn
        icon.name: "onedrive-upload"
        text: "Upload"
        font.pointSize: 12
        icon.width: PlasmaCore.Units.iconSizes.huge
        icon.height: PlasmaCore.Units.iconSizes.huge
        leftPadding: PlasmaCore.Units.largeSpacing
        rightPadding: PlasmaCore.Units.largeSpacing
        topPadding: PlasmaCore.Units.largeSpacing
        bottomPadding: PlasmaCore.Units.largeSpacing
        Layout.alignment: Qt.AlignHCenter
        display: QControls.AbstractButton.TextUnderIcon
        onClicked: {
            // setting the current action as the last action
            Handler.setLastAction("upload")
            
            // executing command
            onedriveExec.exec("onedrive --synchronize --upload-only")
        }
    }   

    // download button
    PlasmaComponents3.Button {
        id: downloadBtn
        icon.name: "onedrive-download"
        text: "Download"
        font.pointSize: 12
        icon.width: PlasmaCore.Units.iconSizes.huge
        icon.height: PlasmaCore.Units.iconSizes.huge
        leftPadding: PlasmaCore.Units.largeSpacing
        rightPadding: PlasmaCore.Units.largeSpacing
        topPadding: PlasmaCore.Units.largeSpacing
        bottomPadding: PlasmaCore.Units.largeSpacing
        Layout.alignment: Qt.AlignHCenter
        display: QControls.AbstractButton.TextUnderIcon
        onClicked: {
            // setting the current action as the last action
            Handler.setLastAction("download")
            
            // executing command
            onedriveExec.exec("onedrive --synchronize --download-only")
        }
    }

    // stop syncing button
    PlasmaComponents3.Button {
        id: stopBtn
        text: "Stop syncing"
        enabled: false
        font.pointSize: 12
        Layout.columnSpan: 2
        Layout.alignment: Qt.AlignHCenter
        onClicked: {
            // closing popup after clicking button
            plasmoid.expanded = false 
            
            // closing onedrive
            terminatedByUser.text = "true"
            executable.exec("killall onedrive")
        }
        leftPadding: PlasmaCore.Units.largeSpacing
        rightPadding: PlasmaCore.Units.largeSpacing
        topPadding: PlasmaCore.Units.largeSpacing / 3
        bottomPadding: PlasmaCore.Units.largeSpacing / 3
        Layout.bottomMargin: PlasmaCore.Units.largeSpacing * 2
        background: Rectangle {
            radius: PlasmaCore.Units.devicePixelRatio * 5
            color: parent.hovered ? "#ad0a0a" : "#880808"
        }
    }

    // DataSource that executes onedrive commands in the terminal
    // disables FullRepresentation while uploading/working
    PlasmaCore.DataSource {
        id: onedriveExec
        engine: "executable"
        connectedSources: []
        function exec(cmd) {
            // disabling FullRepresentation after clicking button
            Handler.toggleBusy()    
            
            // optional argument
            if(dryrunCb.checked){
                cmd += " --dry-run"
            }
            
            // closing popup after clicking button
            plasmoid.expanded = false
            // send notification about synchronization start
            executable.exec("kdialog --passivepopup \"File synchronization was successfully started\" --title \"Onedrive synchronization started!\" 5")

            // by default onedrive will not be terminated by the user
            terminatedByUser.text = "false"

            // execute command
            connectSource(cmd)
        }
        onNewData: {
            var exitCode = data["exit code"]
            var exitStatus = data["exit status"]
            var stdout = data["stdout"]
            var stderr = data["stderr"]
            exited(exitCode, exitStatus, stdout, stderr)
            disconnectSource(sourceName)
            Handler.toggleBusy()    // enabling FullRepresentation after onedrive finished uploading
        }
        signal exited(int exitCode, int exitStatus, string stdout, string stderr)
    }

    // simple DataSource to execute to terminal a command
    PlasmaCore.DataSource {
        id: executable
        engine: "executable"
        connectedSources: []
        onNewData: {
            var exitCode = data["exit code"]
            var exitStatus = data["exit status"]
            var stdout = data["stdout"]
            var stderr = data["stderr"]
            exited(exitCode, exitStatus, stdout, stderr)
            disconnectSource(sourceName)
        }
        function exec(cmd) {
            connectSource(cmd)
        }
        signal exited(int exitCode, int exitStatus, string stdout, string stderr)
    }

    // invisible label used to determine whether onedrive was terminated by the User or not
    PlasmaComponents3.Label {
        id: terminatedByUser
        text: "false"
        visible: false
    }

    // when onedrive command is finished
    Connections {
        target: onedriveExec
        onExited: {
            // terminal stdout from onedrive command
            var msg = stdout

            // the command was terminated by the user
            if(terminatedByUser.text == "true"){
                // displaying notification
                executable.exec("kdialog --passivepopup \"File synchronization was successfully stopped\" --title \"Onedrive synchronization stopped!\" 5")
                return
            }

            // removing lines that cointain 
            var notWantedSentences = ["Configuration file successfully loaded", "Configuring Global Azure AD Endpoints", 
            "Initializing the Synchronization Engine", "Syncing changes", "Uploading differences of", "Uploading new items of", 
            "Trying to delete", "DONE IN", "ETA", "Internet connectivity", "Creating local directory", "DRY-RUN", "Skipping", "config file has been updated", "Sync with" ]
            notWantedSentences.forEach(function(sentence) {
                msg = msg.split('\n').filter(function(line){ 
                    return line.indexOf(sentence) == -1;
                }).join('\n')
            })

            // removing all occurencies of not needed words
            var notWantedWords = ["new file", "file", "from OneDrive:", "...", "done.", "item", "modified"]
            notWantedWords.forEach(function(word) {
                msg = msg.replace(new RegExp(word.replace(/[.*+?^${}()|[\]\\]/g, '\\$&'), 'g'), "")
            })

            // verb-ing -> verb-ed
            msg = msg.replace(new RegExp("Uploading".replace(/[.*+?^${}()|[\]\\]/g, '\\$&'), 'g'), "> Uploaded")
            msg = msg.replace(new RegExp("Downloading".replace(/[.*+?^${}()|[\]\\]/g, '\\$&'), 'g'), "> Downloaded")
            msg = msg.replace(new RegExp("Deleting".replace(/[.*+?^${}()|[\]\\]/g, '\\$&'), 'g'), "> Deleted")
            
            // final trim just to make sure
            msg = msg.trim()

            // in the case of changes
            if(msg == "")
                msg = "Nothing changed!"

            // title of the popup
            var title = "Onedrive " + Handler.lastAction + " finished!"
            if(dryrunCb.checked)
                title += " (dry-run mode)"

            // displaying notification
            executable.exec("kdialog --passivepopup \"" + msg + "\" --title \""+ title + "\" 5")
        }
    }
}
import QtQuick 2.0
import QtQuick.Controls 2.3 as QControls
import QtQuick.Layouts 1.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 3.0 as PlasmaComponents3
import org.kde.plasma.plasmoid 2.0

import "handler.js" as Handler

GridLayout {
    // used to disable the FullRepresentation while syncing
    id: main
    // arranging two columns for the buttons to be side by side
    columns: 2
    // filling the fullRepresentation
    anchors.fill: parent

    // top spacer
    Rectangle {
        color: "transparent"
        Layout.columnSpan: 2
        Layout.alignment: Qt.AlignHCenter
        Layout.fillWidth: true
        Layout.preferredHeight: PlasmaCore.Units.gridUnit * 2
        Layout.bottomMargin: 0
    }

    // checkbox for dry-run mode
    PlasmaComponents3.CheckBox {
        id: dryrunCb
        text: " Dry-run mode"
        font.pointSize: 12
        checked: false
        indicator.width: 32
        indicator.height: 32
        Layout.columnSpan: 2
        Layout.alignment: Qt.AlignHCenter
    }

    // upload button
    PlasmaComponents3.Button {
        id: uploadBtn
        icon.name: "onedrive-upload"
        icon.width: PlasmaCore.Units.gridUnit * 6
        icon.height: PlasmaCore.Units.gridUnit * 6
        text: "Upload"
        font.pointSize: 12
        Layout.alignment: Qt.AlignHCenter
        display: QControls.AbstractButton.TextUnderIcon
        onClicked: {
            // setting the current action as the last action
            Handler.setLastAction("upload")
            
            // command and optional arguments
            var cmd = "onedrive --synchronize --upload-only"
            if(dryrunCb.checked){
                cmd += " --dry-run"
            }
            
            // executing command
            onedriveExec.exec(cmd)
        }
    }   

    // download button
    PlasmaComponents3.Button {
        id: downloadBtn
        icon.name: "onedrive-download"
        icon.width: PlasmaCore.Units.gridUnit * 6
        icon.height: PlasmaCore.Units.gridUnit * 6
        text: "Download"
        font.pointSize: 12
        Layout.alignment: Qt.AlignHCenter
        display: QControls.AbstractButton.TextUnderIcon
        onClicked: {
            // setting the current action as the last action
            Handler.setLastAction("download")
            
            // command and optional arguments
            var cmd = "onedrive --synchronize --download-only"
            if(dryrunCb.checked){
                cmd += " --dry-run"
            }
            
            // executing command
            onedriveExec.exec(cmd)
        }
    }

    // checkbox for dry-run mode
    PlasmaComponents3.Button {
        id: stopBtn
        text: "Stop syncing"
        enabled: false
        font.pointSize: 12
        Layout.columnSpan: 2
        Layout.alignment: Qt.AlignHCenter
        onClicked: onedriveExec.close(true)
        leftPadding: PlasmaCore.Units.gridUnit
        rightPadding: PlasmaCore.Units.gridUnit
        topPadding: PlasmaCore.Units.gridUnit / 3
        bottomPadding: PlasmaCore.Units.gridUnit / 3
    }

    // bottom spacer
    Rectangle {
        color: "transparent"
        Layout.columnSpan: 2
        Layout.alignment: Qt.AlignHCenter
        Layout.fillWidth: true
        Layout.preferredHeight: PlasmaCore.Units.gridUnit * 2
        Layout.bottomMargin: 0
    }

    // DataSource that executes onedrive commands in the terminal
    // disables FullRepresentation while uploading/working
    PlasmaCore.DataSource {
        id: onedriveExec
        engine: "executable"
        connectedSources: []
        onNewData: {
            // closing command
            close(false)
        }
        function exec(cmd) {
            Handler.toggleBusy()    // disabling FullRepresentation after clicking button
            plasmoid.expanded = false  // closing popup after clicking button
            connectSource(cmd)
            connectedSources = [cmd]
        }
        function close(isUserTriggered){
            var exitCode = data["exit code"]
            var exitStatus = data["exit status"]
            var stdout = data["stdout"]
            var stderr = data["stderr"]
            exited(exitCode, exitStatus, stdout, stderr, isUserTriggered)
            disconnectSource(connectedSources[0])
            Handler.toggleBusy()    // enabling FullRepresentation after onedrive finished uploading
        }
        signal exited(int exitCode, int exitStatus, string stdout, string stderr, bool isUserTriggered)
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

    // when onedrive command is finished
    Connections {
        target: onedriveExec
        onExited: {
            if(isUserTriggered){
                // displaying notification
                executable.exec("kdialog --passivepopup \"File synchronization was successfully stopped\" --title \"Onedrive synchronization stopped!\" 5")
                return
            }

            // terminal stdout from onedrive command
            var msg = stdout

            // removing lines that cointain 
            var notWantedSentences = ["Configuration file successfully loaded", "Configuring Global Azure AD Endpoints", "Initializing the Synchronization Engine",
            "Syncing changes", "Uploading differences of", "Uploading new items of", "Trying to delete", "DONE IN", "ETA", "Internet connectivity", "Creating local directory", "DRY-RUN"]
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
            msg = msg.replace(new RegExp("Uploading".replace(/[.*+?^${}()|[\]\\]/g, '\\$&'), 'g'), "Uploaded")
            msg = msg.replace(new RegExp("Downloading".replace(/[.*+?^${}()|[\]\\]/g, '\\$&'), 'g'), "Downloaded")
            msg = msg.replace(new RegExp("Deleting".replace(/[.*+?^${}()|[\]\\]/g, '\\$&'), 'g'), "Deleted")
            
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
import QtQuick 2.0
import QtQuick.Controls 2.3 as QControls
import QtQuick.Layouts 1.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 3.0 as PlasmaComponents3
import org.kde.plasma.plasmoid 2.0

import "handler.js" as Handler

// RowLayout that allows to put buttons side by side easily
RowLayout {
    // size for popup in system tray is fixed so it's not configured

    // the RowLayout fills the fullRepresentation
    anchors.fill: parent

    // upload button
    PlasmaComponents3.Button {
        id: uploadButton
        icon.name: "cloud-upload"
        icon.width: 100
        icon.height: 100
        text: "Upload"
        Layout.alignment: Qt.AlignHCenter
        display: QControls.AbstractButton.TextUnderIcon
        onClicked: {
            Handler.setLastAction("upload")
            onedriveExec.exec("onedrive --synchronize --upload-only")
        }
    }   

    // download button
    PlasmaComponents3.Button {
        id: downloadButton
        icon.name: "cloud-download"
        icon.width: 100
        icon.height: 100
        text: "Download"
        Layout.alignment: Qt.AlignHCenter
        display: QControls.AbstractButton.TextUnderIcon
        onClicked: {
            Handler.setLastAction("download")
            onedriveExec.exec("onedrive --synchronize --download-only")
        }
    }

    // DataSource that executes onedrive commands in the terminal
    // disables button while uploading/working
    PlasmaCore.DataSource {
		id: onedriveExec
		engine: "executable"
		connectedSources: []
		onNewData: {
			var exitCode = data["exit code"]
			var exitStatus = data["exit status"]
			var stdout = data["stdout"]
			var stderr = data["stderr"]
			exited(exitCode, exitStatus, stdout, stderr)
			disconnectSource(sourceName)
            Handler.toggleBusy()    // enabling buttons after onedrive finished uploading
		}
		function exec(cmd) {
            Handler.toggleBusy()    // disabling buttons after clicking button
            plasmoid.expanded = false  // closing popup after clicking button
			connectSource(cmd)
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

    Connections {
		target: onedriveExec
		onExited: {
            // terminal stdout from onedrive command
            var msg = stdout

            // removing lines that cointain "Configuration file successfully loaded"
            msg = msg.replace(/^.*Configuration file successfully loaded.*$/mg, "");
            // removing lines that cointain "Configuring Global Azure AD Endpoints"
            msg = msg.replace(/^.*Configuring Global Azure AD Endpoints.*$/mg, "");
            // removing lines that cointain "Initializing the Synchronization Engine"
            msg = msg.replace(/^.*Initializing the Synchronization Engine.*$/mg, "");
            // removing lines that cointain "Syncing changes"
            msg = msg.replace(/^.*Syncing changes.*$/mg, "");
            // removing lines that cointain "Uploading differences of"
            msg = msg.replace(/^.*Uploading differences of.*$/mg, "");
            // removing lines that cointain "Uploading new items of"
            msg = msg.replace(/^.*Uploading new items of.*$/mg, "");
            // removing lines that cointain "Trying to delete"
            msg = msg.replace(/^.*Trying to delete.*$/mg, "");
            // removing lines that cointain "DONE IN"
            msg = msg.replace(/^.*DONE IN.*$/mg, "");
            // removing lines that cointain "ETA"
            msg = msg.replace(/^.*ETA.*$/mg, "");
            // removing lines that cointain "Internet connectivity"
            msg = msg.replace(/^.*Internet connectivity.*$/mg, "");

            // removing not needed words
            msg = msg.replace("new file", "").replace("file", "").replace("from Onedrive:", "")
            msg = msg.replace("...", "").replace("done.", "").replace("item", "").replace("modified", "").trim()

            // title of the popup
            var title = "Onedrive " + Handler.lastAction + " finished!"
            executable.exec("kdialog --passivepopup \"" + msg + "\" --title \""+ title + "\" 5")
		}
	}
}
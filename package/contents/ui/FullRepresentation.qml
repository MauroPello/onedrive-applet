import QtQuick 2.0
import QtQuick.Controls 2.3 as AB
import QtQuick.Layouts 1.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 3.0 as PlasmaComponents3
import org.kde.plasma.plasmoid 2.0

import "handler.js" as Handler

// size for popup in system tray is fixed 
RowLayout {
    anchors.fill: parent

    PlasmaComponents3.Button {
        id: uploadButton
        icon.name: "cloud-upload"
        icon.width: 100
        icon.height: 100
        text: "Upload"
        onClicked: Handler.upload()
        Layout.alignment: Qt.AlignHCenter
        display: AB.AbstractButton.TextUnderIcon
    }   

    PlasmaComponents3.Button {
        id: downloadButton
        icon.name: "cloud-download"
        icon.width: 100
        icon.height: 100
        text: "Download"
        onClicked: Handler.download()
        Layout.alignment: Qt.AlignHCenter
        display: AB.AbstractButton.TextUnderIcon
    }
}
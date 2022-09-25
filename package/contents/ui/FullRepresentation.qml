import QtQuick 2.0
import QtQuick.Layouts 1.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.extras 2.0 as PlasmaExtras
import org.kde.plasma.plasmoid 2.0

// PlasmaExtras.Representation {
//     header: PlasmaExtras.BasicPlasmoidHeading {}
//     contentItem: PlasmaComponent.ListView {
//         // two button with images and text below that execute upload and download
//     }
// }
Item {
    Layout.minimumWidth: label.implicitWidth
    Layout.minimumHeight: label.implicitHeight
    Layout.preferredWidth: 640 * PlasmaCore.Units.devicePixelRatio
    Layout.preferredHeight: 480 * PlasmaCore.Units.devicePixelRatio
    
    PlasmaComponents.Label {
        id: label
        anchors.fill: parent
        text: "Hello World!"
        horizontalAlignment: Text.AlignHCenter
    }
}
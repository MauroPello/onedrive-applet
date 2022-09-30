import QtQuick 2.0
import QtQuick.Layouts 1.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.plasmoid 2.0

import "handler.js" as Handler

Item {
    Plasmoid.backgroundHints: PlasmaCore.Types.DefaultBackground

    Plasmoid.toolTipMainText: "Onedrive"
    Plasmoid.toolTipSubText: subLabel.text

    // invisible label used just as placeholder for the js script to modify the toolTipSubText dynamically
    PlasmaComponents.Label {
        id: subLabel
        text: Handler.notBusyText
        visible: false
    }

    // Always display the compact view.
    // Never show the full popup view even if there is space for it.
    Plasmoid.preferredRepresentation: Plasmoid.compactRepresentation

    // fullRepresentation written in the FullRepresentation file
    Plasmoid.fullRepresentation: FullRepresentation { }
}
import QtCore
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Controls.impl
import Esri.CompanionApp
import Qt5Compat.GraphicalEffects

ApplicationWindow {
    id: windowId
    visible: true
    width: 320
    height: 640

    LocationPermission{
         id: locationPermission

    }

    Rectangle {
        id: permissionRequestItem
        anchors.fill: parent
        visible: false

        Text {
            anchors.centerIn: parent
            text: qsTr("We need your permission to access the Location."
                + "Please tap this screen to request permission.")

        }

        MouseArea {
            anchors.fill: parent
            onClicked: locationPermission.request()
        }
    }



    header: Rectangle {
        color:  "#1d1d20"
        height: 56
        RowLayout {
            anchors.fill: parent
            anchors.margins: 10
            Text {
                text: "Mapify"
                color: "white"
                font.bold: true
                font.pointSize: 20
            }
            Item { Layout.fillWidth: true }
            Rectangle {
                width: 20
                height: 20
                color: "transparent"
                Image {
                    sourceSize.height: parent.height
                    sourceSize.width: parent.width
                    anchors.centerIn: parent
                    source: "qrc:/Resources/drawer.png"
                }
                MouseArea{
                    anchors.fill: parent
                    onClicked: function(){
                        drawer.open()
                        blurOverlay.visible = true
                        effectSource.visible = true
                    }
                }
            }
        }
    }

    // This overlay sits on top of everything
    DownloadMapPrompt {
        id: downloadPrompt
        anchors.fill: parent
        model: appBackend
        z: 1000
        isVisible: false
    }


    Item {
        id: contentRoot
        anchors.fill: parent
        // Rename ID to appBackend to avoid shadowing the "model" property name
        CompanionApp {
            id: appBackend
        }


        Rectangle{
            id: containerId
            anchors.fill: parent
            z: 1000
            color: "transparent"
        }

        Drawer {
            id: drawer
            width: windowId.width * 0.75
            height: windowId.height
            onClosed: {
                blurOverlay.visible = false
                effectSource.visible = false
            }

            Rectangle{
                anchors.fill: parent
                color: "#1d1d20"
            }
            ColumnLayout {
                anchors.fill: parent
                //Profile
                Rectangle {
                    id: profileSection
                    width: parent.width
                    height: 48
                    radius: 12
                    color: "transparent"
                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 16
                        anchors.rightMargin: 16
                        spacing: 12
                        Item {
                            width: 24
                            height: 24
                            IconImage {
                                anchors.centerIn: parent
                                source: "qrc:/Resources/profile.svg"
                                sourceSize.width: 20
                                sourceSize.height: 20
                                fillMode: Image.PreserveAspectFit
                                color: "#9CA3AF"
                            }
                        }
                        Text {
                            text: qsTr("Profile")
                            font.pixelSize: 14
                            color: "#E5E7EB"
                            verticalAlignment: Text.AlignVCenter
                        }
                        Item {
                            Layout.fillWidth: true
                        }
                    }
                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true

                        onEntered: profileSection.color = "#1F2937"   // subtle hover
                        onExited: profileSection.color = "transparent"

                        onPressed: profileSection.color = "#111827"
                        onReleased: profileSection.color = containsMouse ? "#1F2937" : "transparent"

                        cursorShape: Qt.PointingHandCursor
                    }
                }

                //Saved
                Rectangle {
                    id: savedSection
                    width: parent.width
                    height: 48
                    radius: 12
                    color: "transparent"
                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 16
                        anchors.rightMargin: 16
                        spacing: 12
                        Item {
                            width: 24
                            height: 24
                            IconImage {
                                anchors.centerIn: parent
                                source: "qrc:/Resources/saved.svg"
                                sourceSize.width: 20
                                sourceSize.height: 20
                                fillMode: Image.PreserveAspectFit
                                color: "#9CA3AF"
                            }
                        }
                        Text {
                            text: qsTr("Saved Places")
                            font.pixelSize: 14
                            color: "#E5E7EB"
                            verticalAlignment: Text.AlignVCenter
                        }
                        Item {
                            Layout.fillWidth: true
                        }
                    }
                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true

                        onEntered:savedSection.color = "#1F2937"   // subtle hover
                        onExited: savedSection.color = "transparent"

                        onPressed: savedSection.color = "#111827"
                        onReleased:savedSection.color = containsMouse ? "#1F2937" : "transparent"

                        cursorShape: Qt.PointingHandCursor
                    }
                }

                //Track Location
                Rectangle {
                    id: trackModeSection
                    width: parent.width
                    height: 48
                    radius: 12
                    color: "transparent"
                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 16
                        anchors.rightMargin: 16
                        spacing: 12
                        Item {
                            width: 24
                            height: 24
                            IconImage {
                                anchors.centerIn: parent
                                source: "qrc:/Resources/Marker.svg"
                                sourceSize.width: 20
                                sourceSize.height: 20
                                fillMode: Image.PreserveAspectFit
                                color: "#0aedb2"
                            }
                        }
                        Text {
                            text: qsTr("Track Phone")
                            font.pixelSize: 14
                            color: "#0aedb2"
                            verticalAlignment: Text.AlignVCenter
                        }
                        Item {
                            Layout.fillWidth: true
                        }
                    }
                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: {
                            if(appBackend.isTracking)
                            {
                                appBackend.isTracking = false
                            }else{
                                appBackend.isTracking = true
                            }

                        }

                        onEntered:  trackModeSection.color = "#1F2937"   // subtle hover
                        onExited:  trackModeSection.color = "transparent"

                        onPressed:  trackModeSection.color = "#111827"
                        onReleased: trackModeSection.color = containsMouse ? "#1F2937" : "transparent"

                        cursorShape: Qt.PointingHandCursor
                    }
                }

                //Download Map
                Rectangle {
                    id: downloadSection
                    width: parent.width
                    height: 48
                    radius: 12
                    color: "transparent"
                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 16
                        anchors.rightMargin: 16
                        spacing: 12
                        Item {
                            width: 24
                            height: 24
                            IconImage {
                                anchors.centerIn: parent
                                source: "qrc:/Resources/donwload.svg"
                                sourceSize.width: 20
                                sourceSize.height: 20
                                fillMode: Image.PreserveAspectFit
                                color: "#0aedb2"
                            }
                        }
                        Text {
                            text: qsTr("Download Maps")
                            font.pixelSize: 14
                            color: "#0aedb2"
                            verticalAlignment: Text.AlignVCenter
                        }
                        Item {
                            Layout.fillWidth: true
                        }
                    }
                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true

                        onClicked: {
                            downloadPrompt.isVisible = true
                            drawer.close()
                        }

                        onEntered:  downloadSection.color = "#1F2937"   // subtle hover
                        onExited:  downloadSection.color = "transparent"

                        onPressed:  downloadSection.color = "#111827"
                        onReleased: downloadSection.color = containsMouse ? "#1F2937" : "transparent"

                        cursorShape: Qt.PointingHandCursor
                    }
                }


                //offline maps
                Rectangle {
                    id: offlineSection
                    width: drawer.width
                    height: 48
                    radius: 12
                    color: "transparent"
                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 16
                        anchors.rightMargin: 16
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 12
                        Item {
                            width: 24
                            height: 24
                            IconImage {
                                anchors.centerIn: parent
                                source: "qrc:/Resources/offline.svg"
                                sourceSize.width: 20
                                sourceSize.height: 20
                                fillMode: Image.PreserveAspectFit
                                color: "#9CA3AF"
                            }
                        }
                        Text {
                            text: qsTr( "Offline Mode")
                            font.pixelSize: 14
                            color: "#E5E7EB"
                            verticalAlignment: Text.AlignVCenter
                        }
                        Item {
                            Layout.fillWidth: true
                        }
                        Item {
                            Layout.fillWidth: true
                        }
                        Item {
                            Layout.fillWidth: true
                        }
                        Switch {
                            id: offlineSwitch
                            anchors.verticalCenter: parent.verticalCenter
                            checked: appBackend.offlineModeEnabled
                            onToggled: appBackend.offlineModeEnabled = checked
                            indicator: Rectangle {
                                implicitWidth: 44
                                implicitHeight: 24
                                radius: height / 2

                                color: offlineSwitch.checked ? "#00E0C6" : "#2A2F3A"   // ON / OFF
                                border.width: 0

                                // ✨ Smooth animation
                                Behavior on color {
                                    ColorAnimation { duration: 150 }
                                }

                                Rectangle {
                                    width: 20
                                    height: 20
                                    radius: 10
                                    y: 2

                                    x: offlineSwitch.checked ? parent.width - width - 2 : 2

                                    color: "white"

                                    // ✨ Smooth toggle movement
                                    Behavior on x {
                                        NumberAnimation {
                                            duration: 180
                                            easing.type: Easing.InOutQuad
                                        }
                                    }
                                }
                            }
                        }
                        Item {
                        }
                    }

                }

                //darkMode
                Rectangle {
                    id: darkModeSection
                    width: drawer.width
                    height: 48
                    radius: 12
                    color: "transparent"
                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 16
                        anchors.rightMargin: 16
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 12
                        Item {
                            width: 24
                            height: 24
                            IconImage {
                                anchors.centerIn: parent
                                source: "qrc:/Resources/darkMode.svg"
                                sourceSize.width: 20
                                sourceSize.height: 20
                                fillMode: Image.PreserveAspectFit
                                color: "#9CA3AF"
                            }
                        }
                        Text {
                            text: qsTr( "Dark Mode")
                            font.pixelSize: 14
                            color: "#E5E7EB"
                            verticalAlignment: Text.AlignVCenter
                        }
                        Item {
                            Layout.fillWidth: true
                        }
                        Item {
                            Layout.fillWidth: true
                        }
                        Item {
                            Layout.fillWidth: true
                        }
                        Item {
                            Layout.fillWidth: true
                        }
                        Switch {
                            id: darkSwitch
                            anchors.verticalCenter: parent.verticalCenter
                            checked: appBackend.nightModeEnabled
                            onClicked: appBackend.nightModeEnabled = checked
                            indicator: Rectangle {
                                implicitWidth: 44
                                implicitHeight: 24
                                radius: height / 2

                                color: darkSwitch.checked ? "#00E0C6" : "#2A2F3A"   // ON / OFF
                                border.width: 0

                                // ✨ Smooth animation
                                Behavior on color {
                                    ColorAnimation { duration: 150 }
                                }

                                Rectangle {
                                    width: 20
                                    height: 20
                                    radius: 10
                                    y: 2

                                    x: darkSwitch.checked ? parent.width - width - 2 : 2

                                    color: "white"

                                    // ✨ Smooth toggle movement
                                    Behavior on x {
                                        NumberAnimation {
                                            duration: 180
                                            easing.type: Easing.InOutQuad
                                        }
                                    }
                                }
                            }
                        }
                        Item {
                        }
                    }

                }

                //Settings
                Rectangle {
                    id: settingSection
                    width: parent.width
                    height: 48
                    radius: 12
                    color: "transparent"
                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 16
                        anchors.rightMargin: 16
                        spacing: 12
                        Item {
                            width: 24
                            height: 24
                            IconImage {
                                anchors.centerIn: parent
                                source: "qrc:/Resources/Settings.svg"
                                sourceSize.width: 20
                                sourceSize.height: 20
                                fillMode: Image.PreserveAspectFit
                                color: "#9CA3AF"
                            }
                        }
                        Text {
                            text: qsTr("Settings")
                            font.pixelSize: 14
                            color: "#E5E7EB"
                            verticalAlignment: Text.AlignVCenter
                        }
                        Item {
                            Layout.fillWidth: true
                        }
                    }
                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true

                        onEntered: settingSection.color = "#1F2937"   // subtle hover
                        onExited: settingSection.color = "transparent"

                        onPressed: settingSection.color = "#111827"
                        onReleased: settingSection.color = containsMouse ? "#1F2937" : "transparent"

                        cursorShape: Qt.PointingHandCursor
                    }
                }

                //Help and Support
                Rectangle {
                    id: helpAndSupportSection
                    width: parent.width
                    height: 48
                    radius: 12
                    color: "transparent"
                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 16
                        anchors.rightMargin: 16
                        spacing: 12
                        Item {
                            width: 24
                            height: 24
                            IconImage {
                                anchors.centerIn: parent
                                source: "qrc:/Resources/Help.svg"
                                sourceSize.width: 20
                                sourceSize.height: 20
                                fillMode: Image.PreserveAspectFit
                                color: "#9CA3AF"
                            }
                        }
                        Text {
                            text: qsTr("Help and Support")
                            font.pixelSize: 14
                            color: "#E5E7EB"
                            verticalAlignment: Text.AlignVCenter
                        }
                        Item {
                            Layout.fillWidth: true
                        }
                    }
                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true

                        onEntered: helpAndSupportSection.color = "#1F2937"   // subtle hover
                        onExited: helpAndSupportSection.color = "transparent"

                        onPressed: helpAndSupportSection.color = "#111827"
                        onReleased: helpAndSupportSection.color = containsMouse ? "#1F2937" : "transparent"

                        cursorShape: Qt.PointingHandCursor
                    }
                }

                Item { Layout.fillHeight: true }
            }

        }

        // Main Map View
        CompanionAppForm {
            anchors.fill: parent
            model: appBackend
        }
    }
    ShaderEffectSource {
        id: effectSource
        anchors.fill: parent
        sourceItem: contentRoot
        live: true
        visible:  drawer.opened || downloadPrompt.isVisible
    }

    FastBlur {
        id: blurOverlay
        anchors.fill: parent
        source: effectSource
        radius: 40
        visible: drawer.opened || downloadPrompt.isVisible
        z: 500   // below drawer
    }
}
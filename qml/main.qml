import QtCore
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Controls.impl
import Esri.CompanionApp
import Qt5Compat.GraphicalEffects
import "Components"
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
                anchors.left: parent.Left
                anchors.right: parent.Right
                anchors.leftMargin: 2
                anchors.rightMargin: 2

                IconButton{
                    id: profileBtn
                    btnWidth: parent.width
                    btnHeight: 40
                    iconSource: "qrc:/Resources/profile.svg"
                    buttonName: qsTr("Profile")
                    onBtnClicked: function(){
                        console.log("Profile Button is clicked")
                    }
                }

                IconButton{
                    id: savedBtn
                    btnWidth: parent.width
                    btnHeight: 40
                    iconSource: "qrc:/Resources/saved.svg"
                    buttonName: qsTr("Saved Places")
                    onBtnClicked: function(){
                        console.log("Saved Place Btn is clicked")
                    }
                }

                IconButton{
                    id: trackModeBtn
                    btnWidth: parent.width
                    btnHeight: 40
                    iconSource: "qrc:/Resources/Marker.svg"
                    buttonName:  qsTr("Track Phone")
                    onBtnClicked: function()
                    {
                        if(appBackend.isTracking)
                        {
                            appBackend.isTracking = false
                            drawer.close()
                        }else{
                            appBackend.isTracking = true
                            drawer.close()
                        }
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

                //divider
                Rectangle{
                    width: parent.width
                    height: 1
                    color: "#303035"
                }

                //Settings
                IconButton{
                    id: settingsId
                    btnHeight: 40
                    btnWidth: parent.width
                    iconSource: "qrc:/Resources/Settings.svg"
                    buttonName: qsTr("Settings")
                }
                //Help and Support
                IconButton{
                    id: helpAndSupportId
                    btnHeight: 40
                    btnWidth: parent.width
                    iconSource: "qrc:/Resources/Help.svg"
                    buttonName: qsTr("Help & Support ")
                }

                Item { Layout.fillHeight: true }

                Rectangle {
                    id: downloadMapButton
                    width: parent.width
                    height: 45
                    radius: 13

                    anchors.bottom: parent.bottom
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.leftMargin: 5
                    anchors.rightMargin: 5
                    anchors.bottomMargin: 5

                    property bool hovered: false
                    property bool pressed: false

                    color: pressed ? "#00cbb5" : hovered ? "#00e0cc" : "#00ffe6"
                    scale: pressed ? 0.97 : 1.0

                    Behavior on color { ColorAnimation { duration: 120 } }
                    Behavior on scale { NumberAnimation { duration: 100 } }

                    RowLayout {
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        anchors.centerIn: parent

                        Rectangle {
                            width: 15
                            height: 15
                            anchors.verticalCenter: parent.verticalCenter
                            color: "transparent"

                            IconImage {
                                color: "#09090b"
                                sourceSize.width: parent.width
                                sourceSize.height: parent.height
                                source: "qrc:/Resources/donwload.svg"
                                fillMode: Image.PreserveAspectFit
                            }
                        }

                        Text {
                            id: name
                            anchors.verticalCenter: parent.verticalCenter
                            text: qsTr("Download New Maps")
                            font.bold: true
                            font.pointSize: 18
                            color: "#09090b"
                        }

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true

                            onEntered: downloadMapButton.hovered = true
                            onExited: downloadMapButton.hovered = false

                            onPressed: downloadMapButton.pressed = true
                            onReleased: downloadMapButton.pressed = false

                            onClicked: function() {
                                downloadPrompt.isVisible = true
                                drawer.close()
                            }
                        }
                    }
                }
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
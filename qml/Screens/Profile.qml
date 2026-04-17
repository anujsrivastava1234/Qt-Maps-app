import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Effects
import Esri.CompanionApp 1.0
import QtQuick.Controls.impl
import "../Components"

Page {
    id: root
    anchors.fill: parent

    // These properties ensure the code doesn't error out if
    // it's loaded before the parent context is fully ready.
    //property var stackView: null
    property var drawer: null

    background: Rectangle {
        color: "#09090b"
    }

    PortalUserInfo {
        id: userInfo
    }

    // ================= HEADER =================
    header: ToolBar {
        contentHeight: 50
        background: Rectangle { color: "#1d1d20" }

        RowLayout {
            anchors.fill: parent

            ToolButton {
                text: "←"
                onClicked: stackView.pop()
            }

            Label {
                text: "Profile"
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignHCenter
                color: "white"
                font.bold: true
            }
        }
    }

    // ================= CONTENT =================
    Flickable {
        anchors.fill: parent
        contentWidth: parent.width
        contentHeight: contentColumn.implicitHeight
        clip: true
        ScrollBar.vertical: ScrollBar {}

        ColumnLayout {
            id: contentColumn
            width: parent.width
            spacing: 24
            Layout.margins: 50

            // ================= PROFILE ICON =================
            Item {
                Layout.alignment: Qt.AlignHCenter
                width: parent.width * 0.25
                height: width

                Rectangle {
                    id: profileContainer
                    anchors.fill: parent
                    radius: width / 2
                    color: "#26262b"

                    IconImage {
                        id: profileIcon
                        sourceSize: Qt.size(parent.width * 0.4, parent.height * 0.4)
                        fillMode: Image.PreserveAspectFit
                        anchors.centerIn: parent
                        color: "#0affe6"
                        source: "qrc:/Resources/profile.svg"
                    }
                }

                MultiEffect {
                    anchors.fill: profileContainer
                    source: profileContainer
                    shadowEnabled: true
                    shadowBlur: 0.6
                    shadowColor: "#0affe6"
                }
            }

            // ================= USER INFO =================
            ColumnLayout {
                Layout.alignment: Qt.AlignHCenter
                Layout.fillWidth: true
                spacing: 4

                Text {
                    Layout.alignment: Qt.AlignHCenter
                    text: userInfo.fullName || "User Name"
                    font.bold: true
                    font.pointSize: 14
                    color: "#e6e9ee"
                }

                Text {
                    Layout.alignment: Qt.AlignHCenter
                    text: userInfo.email || "user@example.com"
                    color: "#727885"
                    font.pointSize: 11
                }
            }

            // ================= STATS =================
            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: 16

                StatsSection { statsNumber: 24; statsName: "Saved"; statsHeight: 50; statsWidth: 80 }
                StatsSection { statsNumber: 8; statsName: "Routes"; statsHeight: 50; statsWidth: 80 }
                StatsSection { statsNumber: 3; statsName: "Offline"; statsHeight: 50; statsWidth: 80 }
            }

            // ================= BUTTON LISTS =================
            // Helper component structure for repetitive blocks
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 16

                // Activity Section
                Text {
                    text: "ACTIVITY"
                    font.pixelSize: 12
                    font.bold: true
                    color: "#808898"
                }

                Rectangle {
                    Layout.fillWidth: true
                    implicitHeight: 140
                    radius: 8
                    color: "#111114"

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 8
                        spacing: 0

                        IconButton {
                            btnHeight: 42
                            btnWidth: parent.width
                            iconSource: "qrc:/Resources/saved.svg"
                            buttonName: qsTr("Saved Places")
                            actionIcon: "qrc:/Resources/right.svg"
                        }
                        Divider {}

                        IconButton {
                            btnWidth: parent.width
                            btnHeight: 42
                            iconSource: "qrc:/Resources/profile.svg"
                            buttonName: qsTr("Recent trips")
                            actionIcon: "qrc:/Resources/right.svg"

                        }

                        Divider {}
                        IconButton {
                            btnHeight: 42
                            btnWidth: parent.width
                            iconSource: "qrc:/Resources/donwload.svg"
                            buttonName: qsTr("Downloaded Maps")
                            actionIcon: "qrc:/Resources/right.svg"
                        }
                    }
                }

                // Preferences Section
                Text {
                    anchors.left: parent
                    anchors.leftMargin: 10
                    text: "PREFERENCES"
                    font.pixelSize: 12
                    font.bold: true
                    color: "#808898"
                }

                Rectangle {
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    anchors.right: parent.right
                    anchors.rightMargin: 10
                    Layout.fillWidth: true
                    implicitHeight: 110
                    radius: 8
                    color: "#111114"

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 8

                        // Offline Mode Row
                        RowLayout {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 48
                            spacing: 12

                            IconImage {
                                source: "qrc:/Resources/offline.svg"
                                color: "#9CA3AF"
                                sourceSize: Qt.size(20, 20)
                            }
                            Text {
                                text: qsTr("Offline Mode")
                                font.pixelSize: 14
                                color: "#E5E7EB"
                                Layout.fillWidth: true // Pushes Switch to the right
                            }
                            Switch {
                                id: offlineSwitch
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
                        }

                        Divider {}

                        // Dark Mode Row
                        RowLayout {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 48
                            spacing: 12

                            IconImage {
                                source: "qrc:/Resources/darkMode.svg"
                                color: "#9CA3AF"
                                sourceSize: Qt.size(20, 20)
                            }
                            Text {
                                text: qsTr("Dark Mode")
                                font.pixelSize: 14
                                color: "#E5E7EB"
                                Layout.fillWidth: true // Pushes Switch to the right
                            }
                            Switch {
                                id: darkSwitch
                                checked: appBackend.nightModeEnabled
                                onToggled: appBackend.nightModeEnabled = checked
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
                        }
                    }
                }

                Text {
                    text: "Account"
                    font.pixelSize: 12
                    font.bold: true
                    color: "#808898"
                }

                Rectangle {
                    Layout.fillWidth: true
                    implicitHeight: 140
                    radius: 8
                    color: "#111114"

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 8
                        spacing: 0

                        IconButton {
                            btnHeight: 42
                            btnWidth: parent.width
                            iconSource: "qrc:/Resources/saved.svg"
                            buttonName: qsTr("Change Password")
                            actionIcon: "qrc:/Resources/right.svg"
                        }
                        Divider {}

                        IconButton {
                            btnWidth: parent.width
                            btnHeight: 42
                            iconSource: "qrc:/Resources/profile.svg"
                            buttonName: qsTr("Privacy Settings")
                            actionIcon: "qrc:/Resources/right.svg"

                        }

                        Divider {}
                        IconButton {
                            btnHeight: 42
                            btnWidth: parent.width
                            iconSource: "qrc:/Resources/donwload.svg"
                            buttonName: qsTr("Logout")
                        }
                    }
                }

            }
        }

    }
}
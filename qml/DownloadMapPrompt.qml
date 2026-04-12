import QtQuick
import QtQuick.Controls
import Esri.CompanionApp
import QtQuick.Controls.Material
import Qt5Compat.GraphicalEffects

Item {

    id: root
    property CompanionApp model
    property bool isVisible: false

    visible: isVisible   // 👈 move visibility here

    Rectangle {
            id: blurBackground
            anchors.fill: parent
            color: "transparent"

            // This captures whatever is underneath this component
            ShaderEffectSource {
                id: effectSource
                anchors.fill: parent
                sourceItem: parent.parent // Captures the screen behind the dialog
                live: true
                hideSource: false
            }

            FastBlur {
                anchors.fill: parent
                source: effectSource
                radius: 40
                cached: true
            }

            // Dark overlay to make text pop
            Rectangle {
                anchors.fill: parent
                color: "black"
                opacity: 0.4
            }
        }
    Rectangle {
        id: dialogId
        height: parent.height * 0.30
        width: parent ? parent.width * 0.85 : 300
        radius: 5
        color: "#1d1d20"
        anchors.centerIn: parent

        Column {
            anchors.centerIn: parent
            spacing: 10
            Text {
                id: mainHeading
                text: qsTr("Download Map")
                anchors.horizontalCenter: parent.horizontalCenter
                color: "#e3e5ea"
                font{
                    bold: true
                    pointSize: 15
                }
            }
            Text {
                text: qsTr("Do you want to download this map for offline use ?")
                color: "#575b66"
                font.pointSize: 13
                horizontalAlignment: Text.AlignHCenter
            }

            Row {
                spacing: 10
                anchors.horizontalCenter: parent.horizontalCenter
                Button {
                    id: noBtn
                    text: "No"
                    contentItem: Text {
                        text:noBtn.text
                        font: noBtn.font
                        opacity: enabled ? 1.0 : 0.3
                        color: noBtn.down ? "#081818" : "#808797"

                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        elide: Text.ElideRight
                    }
                    background: Rectangle {
                        implicitWidth: 100
                        implicitHeight: 40
                        color: noBtn.down ? "#00ffe6" : "#212124"
                        border.width: noBtn.down ? 0 : 0.3
                        border.color: "#79808e"
                        radius: 30
                    }
                    onClicked: root.isVisible = false
                }

                Button {
                    id: yesBtn
                    text: "Yes"
                    contentItem: Text {
                        text: yesBtn.text
                        font: yesBtn.font
                        opacity: enabled ? 1.0 : 0.3
                        color: yesBtn.down ? "#081818" : "#808797"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        elide: Text.ElideRight
                    }
                    background: Rectangle {
                        implicitWidth: 100
                        implicitHeight: 40
                        color: yesBtn.down ? "#00ffe6" : "#212124"
                        border.width: yesBtn.down ? 0 : 0.3
                        border.color: "#79808e"
                        radius: 30
                    }
                    onClicked: {
                        // Double check if your C++ is actually Extent (with a T)
                        if (typeof root.model.createOfflineAreaFromExtent === "function") {
                            root.model.createOfflineAreaFromExtend()
                        } else {
                            root.model.createOfflineAreaFromExtend(); // current version
                        }
                        //root.isVisible = false
                        dialogId.visible = false
                        progressRect.visible = true
                    }
                }
            }
        }

        //...
    }

    // Show download progress bar and text percent
    Rectangle {
        id: progressRect
        anchors.centerIn: parent
        visible: false
        height: parent.height * 0.30
        width: parent ? parent.width * 0.85 : 300
        color: "#1d1d20"
        radius: 5

        Column {
            anchors.centerIn: parent
            spacing: 10

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                horizontalAlignment: Text.AlignHCenter
                text: "Downloading Map"
                color: "#e3e5ea"
                font{
                    bold: true
                    pointSize: 15
                }
            }

            Text {
                text: qsTr("Preparing offline access...")
                color: "#575b66"
                font.pointSize: 12
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Rectangle {
                height: 5
                width: progressRect.width - 20
                radius: 2
                color: "#808797"

                Rectangle {
                    anchors {
                        top: parent.top
                        bottom: parent.bottom
                        left: parent.left
                    }
                    width: (model.downloadProgress / 100) * parent.width
                    color: "#00ffe6"

                    onWidthChanged: {
                        if (model.downloadProgress === 100) {
                            progressRect.visible = false;
                            completedNoticeRect.visible = true;

                        }
                    }
                }
            }

            Text {
                anchors.right: parent.right
                horizontalAlignment: Text.AlignHCenter
                text: model.downloadProgress + "%"
                color: "white"
                font.bold: true
                font.pointSize: 10
            }
        }
    }
    // Notify user when download is complete
    Rectangle {
        id: completedNoticeRect
        anchors.centerIn: parent
        visible: false
        height: parent.height * 0.30
        width: parent ? parent.width * 0.85 : 300
        color: "#1d1d20"
        radius: 5

        Column {
            anchors.centerIn: parent
            spacing: 10

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                horizontalAlignment: Text.AlignHCenter
                text: "Download complete"
                color: "#e3e5ea"
                font{
                    bold: true
                    pointSize: 15
                }
            }
            Text {
                text: qsTr("Map is ready for the offline use.")
                color: "#575b66"
                font.pointSize: 12
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Button {
                id: doneBtn
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width
                height: 40

                text: "Okay"

                contentItem: Text {
                    text: doneBtn.text
                    font: doneBtn.font
                    opacity: 1.0
                    color:  "#081818"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                }
                background: Rectangle {
                    implicitWidth: 100
                    implicitHeight: 40
                    color:  "#00ffe6"
                    radius: 30
                }
                onClicked: {
                    root.isVisible = false
                    completedNoticeRect.visible = false;
                }
            }
        }
    }


}


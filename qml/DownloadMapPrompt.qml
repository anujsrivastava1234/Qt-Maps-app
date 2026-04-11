import QtQuick
import QtQuick.Controls
import Esri.CompanionApp

Item {

    id: root
    property CompanionApp model
    property bool isVisible: false

    visible: isVisible   // 👈 move visibility here

    Rectangle {
        anchors.fill: parent
        color: "#80000000"   // dark overlay
    }

    Rectangle {
        id: dialogId
        height: parent.height * 0.25
        width: parent ? parent.width * 0.85 : 300
        radius: 5
        color: "white"
        anchors.centerIn: parent

        Column {
            anchors.centerIn: parent
            spacing: 10

            Text {
                text: qsTr("Take Maps offline!")
                font.bold: true
                font.pointSize: 20
                horizontalAlignment: Text.AlignHCenter
            }

            Row {
                spacing: 10
                anchors.horizontalCenter: parent.horizontalCenter

                Button {
                    text: "Yes"
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

                Button {
                    text: "No"
                    onClicked: root.isVisible = false
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
        height: 100
        width: 150
        color: "white"
        radius: 5

        Column {
            anchors.centerIn: parent
            spacing: 10

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                horizontalAlignment: Text.AlignHCenter
                text: "Download Progress"
            }

            Rectangle {
                height: 5
                width: parent.width
                border.color: "black"
                border.width: 1

                Rectangle {
                    anchors {
                        top: parent.top
                        bottom: parent.bottom
                        left: parent.left
                    }
                    width: (model.downloadProgress / 100) * parent.width
                    color: "purple"

                    onWidthChanged: {
                        if (model.downloadProgress === 100) {
                            progressRect.visible = false;
                            completedNoticeRect.visible = true;

                        }
                    }
                }
            }

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                horizontalAlignment: Text.AlignHCenter
                text: model.downloadProgress + "%"
            }
        }
    }
    // Notify user when download is complete
    Rectangle {
        id: completedNoticeRect
        anchors.centerIn: parent
        visible: false
        height: 100
        width: 150
        color: "white"
        radius: 5

        Column {
            anchors.centerIn: parent
            spacing: 10

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                horizontalAlignment: Text.AlignHCenter
                text: "Download complete!"
            }
            Button {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Okay"
                onClicked: {
                    root.isVisible = false
                    completedNoticeRect.visible = false;
                }
            }
        }
    }


}


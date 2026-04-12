import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Controls.impl

Item {
    id: root
    property string iconSource: ""
    property string buttonName: ""
    property int btnWidth: 0
    property int btnHeight: 0
    anchors.leftMargin: 2
    anchors.rightMargin: 2
    signal btnClicked
    width: root.btnWidth
    height: root.btnHeight

    Rectangle {
        id: drawerBtn
        width: root.btnWidth
        height: root.btnHeight
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
                    id: iconId
                    anchors.centerIn: parent
                    source: root.iconSource
                    sourceSize.width: 20
                    sourceSize.height: 20
                    fillMode: Image.PreserveAspectFit
                    color: "#9CA3AF"
                }
            }
            Text {
                id: textId
                text: root.buttonName
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

            onClicked: {
                btnClicked() //emit the signal
            }

            onEntered:{
                drawerBtn.color = "#2f2f33"   // subtle hover
                iconId.color = "#eeeeee"
                textId.color = "#eeeeee"
                textId.font.pixelSize = 16
                drawerBtn.border.width = 0.3
                drawerBtn.border.color = "#2f2f33"
            }
            onExited: {
                drawerBtn.color = "transparent"
                iconId.color = "#9CA3AF"
                textId.color = "#E5E7EB"
                textId.font.pixelSize = 14
            }
            onPressed: drawerBtn.color = "#111827"
            onReleased: drawerBtn.color = containsMouse ? "#1F2937" : "transparent"

            cursorShape: Qt.PointingHandCursor
        }
    }

}

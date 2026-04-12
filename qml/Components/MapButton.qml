import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Controls.impl

Item {
    id: root
    property string btnName: ""
    property string iconName: ""
    property int btnHeight: 0
    property int btnWidth: 0
    property bool isSelected: false
    width: root.btnWidth
    height: root.btnHeight

    signal btnClicked

    Rectangle{
        id: statlliteMapId
        width: parent.width
        height: parent.height
        radius: 10
        border{
            width: root.isSelected ? 1 : 0.7
            color: root.isSelected ? "#00e0cc" : "#9CA3AF"
        }
        color: root.isSelected ? "#223334" : "transparent"
        opacity: root.isSelected ? 1.0 : 0.5

        ColumnLayout{
            anchors.centerIn: parent
            Rectangle{
                width: 12
                height: 12
                anchors.horizontalCenter: parent.horizontalCenter
                color: "transparent"
                IconImage{
                    sourceSize.width: parent.width
                    sourceSize.height: parent.height
                    source: root.iconName
                    color: root.isSelected ? "#00e0cc" : "#9CA3AF"
                }
            }
            Text {
                text: root.btnName
                font.pointSize: 10
                color: root.isSelected ? "#00e0cc" : "#9CA3AF"
            }
        }

        MouseArea{
            anchors.fill: parent
            onClicked: function(){
                btnClicked() //emit the signal
            }
        }
    }
}

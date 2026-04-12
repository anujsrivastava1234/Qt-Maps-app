import QtQuick

Item {
    id: root
    property int statsNumber: 0
    property string statsName: ""
    property int statsWidth: 0
    property int statsHeight: 0
    width: root.statsWidth
    height: root.statsHeight

    Rectangle{
        id: statsSectionId
        width: root.statsWidth
        height: root.statsHeight
        radius: 10
        color: "#26262b"

        Column{
            anchors.centerIn: parent
            spacing: 3
            Text {
                id: statsNumberId
                text: statsNumber
                font.bold: true
                font.pointSize: 15
                color: "white"
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Text {
                id: statsNameId
                text: root.statsName
                color: "#777d8b"
                font.pointSize: 10
            }
        }
    }
}

import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Controls.impl
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import QtQuick.Effects
import Esri.CompanionApp
import "../Components"
Page {
    anchors.fill: parent
    background: Rectangle{
        anchors.fill: parent
        color: "#09090b"
    }

    PortalUserInfo{
        id: userInfo
    }

    header: ToolBar {
        contentHeight: 50
        background: Rectangle{
            anchors.fill: parent
            color: "#1d1d20"
        }

        RowLayout {
            anchors.fill: parent

            ToolButton {
                text: "←"
                onClicked: stackView.pop()
            }

            Label {
                text: "Profile"
                Layout.fillWidth: true
                color: "white"
                horizontalAlignment: Text.AlignHCenter
            }
        }
    }

    Flickable{
        anchors.fill: parent
        flickableDirection: Flickable.VerticalFlick
        ColumnLayout{
            //Main Layout


            anchors.fill: parent
            anchors.horizontalCenter: parent.horizontalCenter
            Rectangle{
                id: profileIconRectId
                Layout.alignment: Qt.AlignCenter
                width: 40
                height: 40
                radius: 20
                color: "#26262b"
                IconImage {
                    id: profileIcon
                    anchors.centerIn: parent
                    sourceSize.height: parent.height * 0.4
                    sourceSize.width: parent.width * 0.4
                    fillMode: Image.PreserveAspectFit
                    color: "#0affe6"
                    source: "qrc:/Resources/profile.svg"
                }
            }
            MultiEffect {
                source: profileIconRectId
                anchors.fill: profileIconRectId
                shadowBlur: 0.5
                shadowEnabled: true
                shadowColor: "#0affe6"
                shadowVerticalOffset: 0.5
                shadowHorizontalOffset: 0.5
            }

            Column{
                Layout.alignment: Qt.AlignCenter
                Text {
                    id: nameId
                    text: userInfo.fullName
                    font.bold: true
                    font.pointSize: 14
                    color: "#e6e9ee"
                }
                Text {
                    id: emailId
                    text: userInfo.email
                    color: "#727885"
                }
            }

            RowLayout{
                Layout.alignment: Qt.AlignCenter
                Layout.fillWidth: true
                Layout.margins: 5
                spacing: 5
                StatsSection{
                    statsNumber: 24
                    statsName: "Saved"
                    statsHeight: 60
                    statsWidth: 90
                }
                StatsSection{
                    statsNumber: 8
                    statsName: "Routes"
                    statsHeight: 60
                    statsWidth: 90
                }
                StatsSection{
                    statsNumber: 3
                    statsName: "Offline"
                    statsHeight: 60
                    statsWidth: 90
                }
            }

            Column{
                Text{
                    text: "ACTIVITY"
                    color: "#808898"
                    font.pixelSize: 18
                }

                ListModel{
                    ListElement{
                        icon: ""
                        name: "Saved Places"
                    }
                    ListElement{
                        icon: ""
                        name: "Recent Trips"
                    }
                    ListElement{
                        icon: ""
                        name: "Downloaded Maps"
                    }
                }

                ListView{

                }
            }
        }

    }
}
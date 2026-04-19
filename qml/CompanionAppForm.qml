import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Esri.CompanionApp
import QtQuick.Controls.impl

Item {
    id: root
    property CompanionApp model

    MapView {
        id: view
        anchors.fill: parent
        focus: true
        Component.onCompleted: {
                    // Set and keep the focus on MapView to enable keyboard navigation
                    forceActiveFocus();
        }
    }

    // Search Overlay Container
    Item {
        id: searchContainer
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
        }
        z: 10 // Ensure it sits above the MapView
        height: columnLayout.height

        ColumnLayout {
            id: columnLayout
            width: parent.width
            spacing: 0

            // Search Bar Input
            Rectangle {
                Layout.fillWidth: true
                height: 50
                color: "#1b1b1f"
                radius: 4
                border.color: "#1b1b1f"

                // Shadow effect (optional, simplified)
                layer.enabled: true

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 5
                    spacing: 10

                    TextField {
                        id: textField
                        Layout.fillWidth: true
                        placeholderText: "Search for an address..."
                        background: null
                        selectByMouse: true
                        font.pixelSize: 16
                        placeholderTextColor: "white"
                        selectedTextColor: "white"
                        onTextChanged: {
                            suggestView.visible = (text.length > 0);
                            appBackend.setSuggestions(text);
                        }

                        onAccepted: {
                            suggestView.visible = false;
                            appBackend.geocode(textField.text);
                            Qt.inputMethod.hide();
                        }
                    }

                    // Clear/Close Button
                    Rectangle {
                        Layout.preferredWidth: 30
                        Layout.preferredHeight: 30
                        color: "transparent"
                        IconImage{
                         sourceSize.width: parent.width
                         sourceSize.height: parent.height
                         source: "qrc:/Resources/close.svg"
                         color: "white"
                        }
                        MouseArea{
                            anchors.fill: parent
                            onClicked: {
                                textField.text = "";
                                appBackend.clearGraphics();
                                textField.focus = true;
                            }
                        }

                    }
                }
            }

            // Suggestions List
            ListView {
                id: suggestView
                Layout.fillWidth: true
                Layout.preferredHeight: Math.min(count * 45, 300) // Caps height at 300px
                model: appBackend.suggestions
                visible: false
                clip: true

                ScrollBar.vertical: ScrollBar {
                    policy: ScrollBar.AsNeeded
                }

                delegate: ItemDelegate {
                    width: suggestView.width
                    height: 45

                    background: Rectangle {
                        color: highlighted ? "#eee" : "#1b1b1f"
                    }

                    contentItem: Text {
                        text: label
                        verticalAlignment: Text.AlignVCenter
                        leftPadding: 10
                        elide: Text.ElideRight
                        font.pixelSize: 14
                        color: "white"
                    }

                    onClicked: {
                        textField.text = label;
                        suggestView.visible = false;
                        appBackend.geocode(label);
                        Qt.inputMethod.hide();
                    }
                }
            }
        }
    }

    Text {
                        padding: 5
                        width: parent.width
                        wrapMode: Text.Wrap
                        text: appBackend.textString
                    }

    Component.onCompleted: {
        model.mapView = view;
    }
}
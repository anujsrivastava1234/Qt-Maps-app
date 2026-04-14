import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Esri.ArcGISRuntime.Toolkit
import Esri.ArcGISRuntime.Toolkit.Controller

Page {
    id: root
    signal authComplete()

    background: Rectangle { color: "#1d1d20" }

    // Set when ANY auth challenge starts (WebView or external browser)
    property bool authInProgress: false

    Connections {
        target: AuthenticatorController

        // In-app WebView OAuth
        function onDisplayOAuthSignInView() {
            root.authInProgress = true
        }

        // External browser OAuth — host becomes non-empty when challenge starts
        function onCurrentAuthenticatingHostChanged() {
            const host = AuthenticatorController.currentAuthenticatingHost
            if (host !== "")
                root.authInProgress = true
            else if (root.authInProgress)
                root.authComplete()
        }
    }

    // Handles the OAuth WebView dialog when a challenge fires
    Authenticator {
        anchors.fill: parent
    }

    ColumnLayout {
        anchors.centerIn: parent
        spacing: 24

        Text {
            text: "Mapify"
            color: "white"
            font.bold: true
            font.pointSize: 40
            Layout.alignment: Qt.AlignHCenter
        }

        Text {
            text: "Sign in with your ArcGIS account\nto continue"
            color: "#9CA3AF"
            font.pointSize: 13
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
            Layout.maximumWidth: 260
            Layout.alignment: Qt.AlignHCenter
        }

        BusyIndicator {
            id: busyIndicator
            running: !root.authInProgress
            visible: !root.authInProgress
            Layout.alignment: Qt.AlignHCenter
            palette.dark: "#0affe6"
        }

        Text {
            visible: !root.authInProgress
            text: "Waiting for sign-in prompt…"
            color: "#727885"
            font.pointSize: 11
            Layout.alignment: Qt.AlignHCenter
        }

        // Fallback: shown after auth completes in external browser
        // (in case currentAuthenticatingHost detection misses)
        Rectangle {
            visible: root.authInProgress
            Layout.alignment: Qt.AlignHCenter
            width: 200
            height: 44
            radius: 12
            color: "#0affe6"

            Text {
                anchors.centerIn: parent
                text: "Continue to Map"
                color: "#09090b"
                font.bold: true
                font.pointSize: 13
            }

            MouseArea {
                anchors.fill: parent
                onClicked: root.authComplete()
            }
        }
    }
}

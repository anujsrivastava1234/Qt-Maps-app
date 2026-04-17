pragma ComponentBehavior: Bound
import QtCore
import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import QtQuick.Controls
import Esri.CompanionApp
import QtQuick.Controls.impl
import Qt5Compat.GraphicalEffects
import "Screens"
import "Components"

ApplicationWindow {
    id: windowId
    visible: true
    width: 320
    height: 640
    color: "#1d1d20"

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
        color: "#1d1d20"
        visible: !stackView.visible
        height: visible ? 56 : 0
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

    StackView {
        id: stackView
        anchors.fill: parent
        z: 100
        initialItem: authPageComponent
    }

    SequentialAnimation {
        id: authFadeOut
        NumberAnimation {
            target: stackView
            property: "opacity"
            to: 0
            duration: 500
            easing.type: Easing.InQuad
        }
        PropertyAction { target: stackView; property: "visible"; value: false }


    }

    //Pages
    //1. AuthenticationPage
    Component {
        id: authPageComponent
        AuthenticationPage {
            onAuthComplete: authFadeOut.start()
        }
    }

    //2.ProfilePage
    Component{
        id: profileComponent
        Profile{
        }
    }

    Item {
        id: contentRoot
        anchors.fill: parent
        // Rename ID to appBackend to avoid shadowing the "model" property name


        CompanionApp {
            id: appBackend
        }

        PortalUserInfo{
            id: userInfo
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
            background:Rectangle{
                anchors.fill: parent
                color: "#1d1d20"
            }
            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 5
                anchors.horizontalCenter: parent
                //Profile layout
                RowLayout{
                    Layout.fillWidth: true
                    Layout.margins: 10

                    Rectangle{
                        id: profileIconRectId
                        width: 40
                        height: 40
                        radius: 20
                        color: "#26262b"
                        IconImage {
                            id: profileIcon
                            sourceSize.height: parent.height * 0.4
                            sourceSize.width: parent.width * 0.4
                            fillMode: Image.PreserveAspectFit
                            anchors.centerIn: parent
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
                    ColumnLayout{
                        id: profileSectionId
                        anchors.left: profileIconRectId.right
                        anchors.leftMargin: 8
                        spacing: 0.1
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
                            clip: true

                        }
                    }
                    Rectangle{
                        width: 24
                        height: 24
                        anchors.left: profileSectionId.right
                        anchors.leftMargin: 60
                        Layout.alignment: Qt.AlignRight
                        color: "transparent"
                        IconImage{
                            sourceSize.width: parent.width
                            sourceSize.height: parent.height
                            source: "qrc:/Resources/close.svg"
                            fillMode: Image.PreserveAspectFit
                            color: "#9CA3AF"
                        }
                        MouseArea{
                            anchors.fill: parent
                            onClicked: function(){
                                drawer.close()
                            }
                        }
                    }
                }

                RowLayout{
                    Layout.fillWidth: true
                    Layout.margins: 5
                    spacing: 5
                    StatsSection{
                        statsNumber: 24
                        statsName: "Saved"
                        statsHeight: 50
                        statsWidth: 80
                    }
                    StatsSection{
                        statsNumber: 8
                        statsName: "Routes"
                        statsHeight: 50
                        statsWidth: 80
                    }
                    StatsSection{
                        statsNumber: 3
                        statsName: "Offline"
                        statsHeight: 50
                        statsWidth: 80
                    }
                }

                //divider
                Divider{}
                //Profile Btn
                IconButton{
                    id: profileBtn
                    btnWidth: parent.width
                    btnHeight: 40
                    iconSource: "qrc:/Resources/profile.svg"
                    buttonName: qsTr("Profile")
                    onBtnClicked: function(){
                        stackView.opacity = 1
                                stackView.visible = true
                        console.log("Profile Button is clicked")
                        stackView.z = 2000; // Bring stack to front over the map
                        stackView.push(profileComponent)
                        drawer.close() // Close drawer so user sees the page
                    }
                }
                //saved places
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
                //track mode
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
                Divider{}
                //Settings
                IconButton{
                    id: settingsId
                    btnHeight: 40
                    btnWidth: parent.width
                    iconSource: "qrc:/Resources/Settings.svg"
                    buttonName: qsTr("Settings")
                    actionIcon: "qrc:/Resources/right.svg"
                    onBtnClicked: function(){
                        if(mapTypeSection.visible)
                        {
                            mapTypeSection.visible = false
                            settingsId.actionIcon = "qrc:/Resources/right.svg"
                        }else{
                            mapTypeSection.visible = true
                            settingsId.actionIcon = "qrc:/Resources/down.svg"
                        }



                    }
                }
                RowLayout{
                    id: mapTypeSection
                    Layout.fillWidth: true
                    visible: false
                    MapButton{
                        id: standardBtnId
                        btnName: "Standard"
                        iconName: "qrc:/Resources/standard.svg"
                        btnHeight: 50
                        btnWidth: 80
                        isSelected: true
                        onBtnClicked: {
                            appBackend.mapType = 0
                            sateliteBtnId.isSelected = false
                            terrainBtnId.isSelected = false
                            standardBtnId.isSelected = true
                            drawer.close()
                        }
                    }
                    MapButton{
                        id: sateliteBtnId
                        btnName: "Satellite"
                        iconName: "qrc:/Resources/satellite.svg"
                        btnHeight: 50
                        btnWidth: 80
                        isSelected: false
                        onBtnClicked: {
                            appBackend.mapType = 1
                            standardBtnId.isSelected = false
                            terrainBtnId.isSelected = false
                            sateliteBtnId.isSelected = true
                            drawer.close()
                        }
                    }
                    MapButton{
                        id: terrainBtnId
                        btnName: "Terrain"
                        iconName: "qrc:/Resources/terrain.svg"
                        btnHeight: 50
                        btnWidth: 80
                        isSelected: false
                        onBtnClicked: {
                            appBackend.mapType = 2
                            standardBtnId.isSelected = false
                            sateliteBtnId.isSelected = false
                            terrainBtnId.isSelected = true
                            drawer.close()
                        }
                    }
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
                    height: 40
                    radius: 13

                    anchors.bottom: parent.bottom
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.leftMargin: 7
                    anchors.rightMargin: 7
                    anchors.bottomMargin: 10

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
                            width: 12
                            height: 12
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
                            font.pointSize: 12
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
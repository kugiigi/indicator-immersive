import QtQuick 2.9
import QtQuick.Layouts 1.3
import Ubuntu.Components 1.3
import Qt.labs.settings 1.0
import Indicator 1.0
import io.thp.pyotherside 1.4 //for Python
import Ubuntu.Components.Popups 1.3

MainView {
    id: root
    objectName: 'mainView'
    applicationName: 'indicator-immersive'
    automaticOrientation: true
    anchorToKeyboard: true

    width: units.gu(45)
    height: units.gu(75)
    
    Settings {
        id: settings
    
        property int defaultEdgeWidth: 2
        property int defaultEdgeSensitivity: 50
        property int defaultEdgeMinPush: 2
    }

    Page {
        header: PageHeader {
            id: header
            title: i18n.tr("Immersive mode Indicator")
        }

        Flickable {
            id: flickable
            
            anchors {
                top: header.bottom
                left: parent.left
                right: parent.right
                bottom: installColumn.top
                bottomMargin: units.gu(2)
            }

            clip: true
            contentHeight: contentColumn.height + units.gu(4)

            ColumnLayout {
                id: contentColumn
                anchors {
                    left: parent.left
                    top: parent.top
                    right: parent.right
                }
                spacing: units.gu(1)
                
                ListItem {
                    id: expandableListItem

                    Layout.fillWidth: true
                    Layout.preferredHeight: !expansion.expanded ? headerListItem.height : expansion.height
                    expansion.height: headerListItem.height + expandableListLoader.height + units.gu(4)
                    onClicked: expansion.expanded = !expansion.expanded

                    ListItem {
                        id: headerListItem
                        
                        height: expandableHeader.height + divider.height

                        ListItemLayout {
                            id: expandableHeader
                            title.text: i18n.tr("What is this?")
                            title.font.bold: true
                            title.font.pixelSize: units.gu(2)
                            
                            Icon {
                                id: info

                                width: units.gu(3)
                                height: width
                                SlotsLayout.position: SlotsLayout.Leading
                                name: "help"
                                asynchronous: true
                            }

                            Icon {
                                id: arrow

                                width: units.gu(2)
                                height: width
                                SlotsLayout.position: SlotsLayout.Trailing
                                name: "go-down"
                                rotation: expandableListItem.expansion.expanded ? 180 : 0
                                asynchronous: true

                                Behavior on rotation {
                                    UbuntuNumberAnimation {}
                                }
                            }
                        }
                    }

                    Loader {
                        id: expandableListLoader
                        
                        asynchronous: true
                        anchors{
                            top: headerListItem.bottom
                            left: parent.left
                            right: parent.right
                            margins: units.gu(2)
                        }
                        sourceComponent: expandableListItem.expansion.expanded ? expandableListComponent : undefined
                    }
                    
                    Component {
                        id: expandableListComponent
                        ColumnLayout {
                            spacing: units.gu(1)
                
                            Label{
                                Layout.fillWidth: true
                                
                                text: i18n.tr("What is this?")
                                font.bold: true
                                textSize: Label.Large
                                elide: Text.ElideRight
                            }
                            
                            Label{
                                Layout.fillWidth: true
                                
                                text: i18n.tr("This is a proof of concept of a new mode for the desktop environment Lomiri wherein some system gestures are disabled to help the user focus on the current app they're using without much distractions.") + "\n\n"
                                    + i18n.tr("This is specially useful for apps that require different in-app gestures that could conflict with system gesture such as painting/drawing apps and games.") + "\n\n"
                                    + i18n.tr("I call this Immersive mode because I feel like it best describes its purpose. ")
                                    + i18n.tr("However, it's somewhat borrowed from Android so if you can think of a better name then let me know :)")
                                wrapMode: Text.Wrap
                            }
                            
                            Label{
                                Layout.fillWidth: true
                                
                                text: i18n.tr("What does it exactly do?")
                                font.bold: true
                                textSize: Label.Large
                                elide: Text.ElideRight
                            }
                            
                            Label{
                                Layout.fillWidth: true
                                
                                text: i18n.tr("When Immersive mode is enabled, left and right edge gestures are disabled. ")
                                    + i18n.tr("This means you can't swipe from the left to open the launcher or the app drawer and you can't open the app spread from the right edge. ")
                                    + i18n.tr("This is all it does at the moment but if ever this actually gets into Lomiri officially, maybe some other gestures can also be disabled such as the 3-finger gestures in tablets.")
                                wrapMode: Text.Wrap
                            }
                            
                            Label{
                                Layout.fillWidth: true
                                
                                text: i18n.tr("How does it work?")
                                font.bold: true
                                textSize: Label.Large
                                elide: Text.ElideRight
                            }
                            
                            Label{
                                Layout.fillWidth: true
                                
                                text: i18n.tr("Left and right edges are disabled by simply setting Lomiri's GSettings key \"Edge Drag Width\" to 0. ")
                                    + i18n.tr("This settings can also be adjusted via UT Tweak Tool but the range there is only limited to 1-6.")
                                wrapMode: Text.Wrap
                            }
                            
                            Label{
                                Layout.fillWidth: true
                                
                                text: i18n.tr("Anything else?")
                                font.bold: true
                                textSize: Label.Large
                                elide: Text.ElideRight
                            }
                            
                            Label{
                                Layout.fillWidth: true
                                
                                text: " - " + i18n.tr("Some devices such as the Nexus 5 and Meizu MX4 has an issue wherein one edge is still active even with Immersive mode enabled.")
                                    + i18n.tr("The still active edge depends on the orientation and possibly an invisible bug on these devices.") + "\n\n- "
                                    + i18n.tr("Disabling Immersive mode will reset the settings \"Edge Drag Width\" to its default value which is 2. ")
                                    + i18n.tr("So take note for those users who changed this value especially those who use a phone case.") + "\n\n- "
                                    + i18n.tr("While on Immersive mode, 4-finger tap on the screen to open the app drawer.") + "\n\n- "
                                    + i18n.tr("Don't forget to uninstall the indicator here first before uninstalling this app.")
                                wrapMode: Text.Wrap
                            }
                        }
                    }
                }

                ListItem {
                    height: Math.max(implicitHeight, dragWidthlayout.height)
                    divider.visible: false
                                        Layout.fillWidth: true

                    ListItemLayout {
                        id: dragWidthlayout
                        anchors.centerIn: parent
                        title.text: i18n.tr("Default edge width: %1").arg(settings.defaultEdgeWidth)
                        subtitle.text: i18n.tr("This will be used when turning off immersive mode")
                        summary.text: i18n.tr("How big (in grid units) the edge-drag sensitive area should be.")
                    }
                }


                ListItem {
                    height: units.gu(16)
                    divider.visible: false
                    Layout.fillWidth: true

                    Button {
                        id: dragWidthResetButton
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.margins: units.gu(2)

                        action: Action {
                            text: i18n.tr("Reset")
                            onTriggered: {
                                settings.defaultEdgeWidth = 2
                                dragWidthSlider.value = settings.defaultEdgeWidth
                            }
                        }
                    }

                    Slider {
                        id: dragWidthSlider
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: dragWidthResetButton.right
                        anchors.right: parent.right
                        anchors.margins: units.gu(2)

                        minimumValue: 1
                        maximumValue: 6

                        Component.onCompleted: {
                            value = settings.defaultEdgeWidth
                        }
                        
                        onValueChanged: {
                            settings.defaultEdgeWidth = value.toFixed(0)
                        }
                    }
                }
                
                ListItem {
                    height: Math.max(implicitHeight, edgeSenslayout.height)
                    divider.visible: false
                    Layout.fillWidth: true

                    ListItemLayout {
                        id: edgeSenslayout
                        anchors.centerIn: parent
                        title.text: i18n.tr("Default edge mouse sensitivity: %1").arg(settings.defaultEdgeSensitivity)
                        subtitle.text: i18n.tr("This will be used when turning off immersive mode")
                        summary.text: i18n.tr("How sensitive the edges are from mouse push.")
                    }
                }


                ListItem {
                    height: units.gu(16)
                    divider.visible: false
                    Layout.fillWidth: true

                    Button {
                        id: edgeSensResetButton
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.margins: units.gu(2)

                        action: Action {
                            text: i18n.tr("Reset")
                            onTriggered: {
                                settings.defaultEdgeSensitivity = 50
                                edgeSensSlider.value = settings.defaultEdgeSensitivity
                            }
                        }
                    }

                    Slider {
                        id: edgeSensSlider
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: edgeSensResetButton.right
                        anchors.right: parent.right
                        anchors.margins: units.gu(2)

                        minimumValue: 1
                        maximumValue: 100

                        Component.onCompleted: {
                            value = settings.defaultEdgeSensitivity
                        }
                        
                        onValueChanged: {
                            settings.defaultEdgeSensitivity = value.toFixed(0)
                        }
                    }
                }
                
                ListItem {
                    height: Math.max(implicitHeight, edgeMinlayout.height)
                    divider.visible: false
                    Layout.fillWidth: true

                    ListItemLayout {
                        id: edgeMinlayout
                        anchors.centerIn: parent
                        title.text: i18n.tr("Default edge mouse minimum push sensitivity: %1").arg(settings.defaultEdgeMinPush)
                        subtitle.text: i18n.tr("This will be used when turning off immersive mode")
                        summary.text: i18n.tr("How sensitive the edges are from mouse push.")
                    }
                }


                ListItem {
                    height: units.gu(16)
                    divider.visible: false
                    Layout.fillWidth: true

                    Button {
                        id: edgeMinResetButton
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.margins: units.gu(2)

                        action: Action {
                            text: i18n.tr("Reset")
                            onTriggered: {
                                settings.defaultEdgeMinPush = 2
                                edgeMinSlider.value = settings.defaultEdgeMinPush
                            }
                        }
                    }

                    Slider {
                        id: edgeMinSlider
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: edgeMinResetButton.right
                        anchors.right: parent.right
                        anchors.margins: units.gu(2)

                        minimumValue: 1
                        maximumValue: 100

                        Component.onCompleted: {
                            value = settings.defaultEdgeMinPush
                        }
                        
                        onValueChanged: {
                            settings.defaultEdgeMinPush = value.toFixed(0)
                        }
                    }
                }
            }
        }
        
        ColumnLayout {
            id: installColumn
            
            anchors {
                left: parent.left
                bottom: parent.bottom
                right: parent.right
                bottomMargin: units.gu(2)
            }
            
            spacing: units.gu(1)
            
            Rectangle {
                height: units.gu(0.3)
                color: theme.palette.normal.base
                Layout.fillWidth: true
            }
            
            Row {
                Layout.alignment: Qt.AlignHCenter
                spacing: units.gu(2)
    
                Button {
                    id: installButton

                    text: !Indicator.isInstalled ? i18n.tr("Install Indicator") : i18n.tr("Uninstall Indicator")
                    onClicked: {
                        if (Indicator.isInstalled) {
                            Indicator.uninstall();
                        } else {
                            Indicator.install();
                        }
                    }
                    color: !Indicator.isInstalled ? UbuntuColors.green : UbuntuColors.red
                }
                
                Button {
                    id: restartButton
                    visible: false

                    text: i18n.tr("Restart Lomiri/Unity8")
                    onClicked: {
                        var popup = PopupUtils.open(confirmDialog);
                        popup.accepted.connect(function() {
                            py.call('os.system', ["restart unity8"], function (result) {
                            // TODO: add error handling
                            });
                        })
                    }
                }
            }
            
            Label {
                id: message

                text: i18n.tr("Uninstall the indicator here before uninstalling the app!") + "\n"
                horizontalAlignment: Text.AlignHCenter
                color: UbuntuColors.red
                wrapMode: Text.Wrap
                
                Layout.fillWidth: true
            }
        }
    }

     Component {
        id: confirmDialog
        Dialog {
            id: confirmDialogue

            signal accepted;

            title: i18n.tr("Restart Lomiri")
            text: i18n.tr("Do you want to restart Lomiri now?") +
                "<br />" + i18n.tr("All currently open apps will be closed.") +
                "<br />" + i18n.tr("Save all your work before continuing!")

            Button{
                text: i18n.tr("Restart Lomiri")
                color: theme.palette.normal.negative
                onClicked: {
                    confirmDialogue.accepted();
                    PopupUtils.close(confirmDialogue);
                }
            }

            Button{
                text: i18n.tr("Cancel")
                onClicked: PopupUtils.close(confirmDialogue);
            }
        }
    }

    Connections {
        target: Indicator

        onInstalled: {
            if (success) {
                message.text = i18n.tr("Successfully installed!") + "\n" + i18n.tr("Please reboot or restart Lomiri/Unity8");
                message.color = UbuntuColors.green;
                restartButton.visible = true;
            }
            else {
                message.text = i18n.tr("Failed to install");
                message.color = UbuntuColors.red;
            }
        }

        onUninstalled: {
            if (success) {
                message.text = i18n.tr("Successfully uninstalled!") + "\n" + i18n.tr("Please reboot or restart Lomiri/Unity8");
                message.color = UbuntuColors.green;
                restartButton.visible = true;
            }
            else {
                message.text = i18n.tr("Failed to uninstall");
                message.color = UbuntuColors.red;
            }
        }
    }
    
    //initiate a python component for calls to python commands
    Python {
        id: py

        Component.onCompleted: {
            //this works as the import statement in a python script
            importModule('os', function() { console.log("DEBUG: python module os loaded"); });
        }
    }
}

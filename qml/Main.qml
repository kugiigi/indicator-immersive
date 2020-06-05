import QtQuick 2.9
import QtQuick.Layouts 1.3
import Ubuntu.Components 1.3
import Indicator 1.0

MainView {
    id: root
    objectName: 'mainView'
    applicationName: 'indicator-immersive'
    automaticOrientation: true

    width: units.gu(45)
    height: units.gu(75)

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
                    margins: units.gu(2)
                }
                spacing: units.gu(1)
                
                Label{
                    Layout.fillWidth: true
                    
                    text: "What is this?"
                    font.bold: true
                    textSize: Label.Large
                    elide: Text.ElideRight
                }
                
                Label{
                    Layout.fillWidth: true
                    
                    text: "This is a proof of concept of a new mode for the desktop environment Lomiri"
                            + " wherein some system gestures are disabled to help the user focus on the"
                            + " current app they're using without much distractions."
                            + "\n\nThis is specially useful for apps that require different in-app gestures"
                            + " that could conflict with system gestures"
                            + " such as painting/drawing apps and games"
                            + "\n\nI call this \"Immersive mode\" because I feel like it best describes its purpose."
                            + "However, it's somewhat borrowed from Android so if you can think of a better name then let me know :)"
                    wrapMode: Text.Wrap
                }
                
                Label{
                    Layout.fillWidth: true
                    
                    text: "What does it exactly do?"
                    font.bold: true
                    textSize: Label.Large
                    elide: Text.ElideRight
                }
                
                Label{
                    Layout.fillWidth: true
                    
                    text: "When Immersive mode is enabled, left and right edge gestures are disabled."
                            + " This means you can't swipe from the left to open the launcher or the app drawer"
                            + " and you can't open the app spread from the right edge. This is all it does at the moment"
                            + " but if ever this actually gets into Lomiri officially, maybe some other gestures can also be disbaled"
                            + " such as the 3-finger gestures in tablets"
                    wrapMode: Text.Wrap
                }
                
                Label{
                    Layout.fillWidth: true
                    
                    text: "How does it work?"
                    font.bold: true
                    textSize: Label.Large
                    elide: Text.ElideRight
                }
                
                Label{
                    Layout.fillWidth: true
                    
                    text: "Left and right egdes are disabled by simply setting Lomiri's GSettings key <i>\"Edge Drag Width\"</i> to 0."
                            + " This settings can also be adjusted via UT Tweak Tool but the range there is only limited to 1-6."
                    wrapMode: Text.Wrap
                }
                
                Label{
                    Layout.fillWidth: true
                    
                    text: "Anything else?"
                    font.bold: true
                    textSize: Label.Large
                    elide: Text.ElideRight
                }
                
                Label{
                    Layout.fillWidth: true
                    
                    text: " - Some devices such as the Nexus 5 and Meizu MX4 has an issue wherein one edge is still active even with Immersive mode enabled."
                            + " The still active edge depends on the orientation and possibly an \"invisible bug\" on these devices."
                            + "\n\n- Disabling Immersive mode will reset the settings \"Edge Drag Width\" to its default value which is 2."
                            + " So take note for those users who changed this value especially those who use a phone case."
                            + "\n\n- Don't forget to uninstall the indicator here first before uninstalling this app."
                    wrapMode: Text.Wrap
                }
            }
        }
        
        ColumnLayout {
            id: installColumn
            
            anchors {
                left: parent.left
                bottom: parent.bottom
                right: parent.right
                margins: units.gu(2)
            }
            
            spacing: units.gu(1)
    
            Button {
                id: installButton
                
                anchors {
                    horizontalCenter: parent.horizontalCenter
                }

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
            
            Label {
                id: message

                text: " \n "
                horizontalAlignment: Text.AlignHCenter
                
                anchors {
                    left: parent.left
                    right: parent.right
                    horizontalCenter: parent.horizontalCenter
                }
            }
        }
    }

    Connections {
        target: Indicator

        onInstalled: {
            if (success) {
                message.text = i18n.tr("Successfully installed! \nPlease reboot or restart Lomiri/Unity8");
                message.color = UbuntuColors.green;
            }
            else {
                message.text = i18n.tr("Failed to install");
                message.color = UbuntuColors.red;
            }
        }

        onUninstalled: {
            if (success) {
                message.text = i18n.tr("Successfully uninstalled! \nlease reboot or restart Lomiri/Unity8");
                message.color = UbuntuColors.green;
            }
            else {
                message.text = i18n.tr("Failed to uninstall");
                message.color = UbuntuColors.red;
            }
        }
    }
}

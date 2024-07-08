import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15

Window {
        id: secretWindow;
        width: 360
        height: 360
        maximumHeight: height
        maximumWidth: width
        minimumHeight: height
        minimumWidth: width
        flags: Qt.Window | Qt.CustomizeWindowHint | Qt.WindowTitleHint | Qt.WindowCloseButtonHint | Qt.WindowSystemMenuHint
        title: qsTr("SecretMenu")
        visible: false        
        Rectangle {
            color: "lightgray"
            width: 360
            height: 360
        
            Column {
                anchors.centerIn: parent
                spacing: 20
        
                Text {
                    text: "Секретное меню"
                    font.pixelSize: 40
                }
        
                Button {
                    text: "Назад"
                    onClicked: secretWindow.visible = false;
                }
            }
        }
    }

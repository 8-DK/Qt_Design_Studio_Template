import QtQuick 6.5
import QtQuick.Controls 6.5
import QtQuick.Window 2.2
import MatSmily

Window {
    id: root
    width: Constants.width
    height: Constants.height
    visible: true

    ToolBar {
        id: toolBar
        y: 0
        height: parent.height *0.1
        anchors.right: parent.right
        anchors.left: parent.left
        contentHeight: toolButton.implicitHeight

        ToolButton {
            id: toolButton
            width: height
            text: stackView.depth > 1 ? "\u25C0" : "\u2630"
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            font:  Constants.largeFont
            onClicked: {
                if (stackView.depth > 1) {
                    stackView.pop()
                } else {
                    drawer.open()
                }
            }
        }

        Label {
            text: stackView.currentItem.objectName
            anchors.centerIn: parent
        }
    }

    StackView {
        id: stackView
        anchors.top: toolBar.bottom
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        initialItem: dashbord
        property DashBoard  dashbord: DashBoard{}
        property Screen01   screen1: Screen01{}
        property Screen02   screen2: Screen02{}
    }

    Drawer {
        id: drawer
        width: root.width * 0.33
        height: root.height

        Column {
            anchors.fill: parent

            ItemDelegate {
                text: qsTr("Page 1")
                width: parent.width
                onClicked: {
                    stackView.push(stackView.screen1)
                    drawer.close()
                }
            }
            ItemDelegate {
                text: qsTr("Page 2")
                width: parent.width
                onClicked: {
                    stackView.push(stackView.screen2)
                    drawer.close()
                }
            }
        }
    }
}


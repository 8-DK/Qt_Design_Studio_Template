

/*
This is a UI file (.ui.qml) that is intended to be edited in Qt Design Studio only.
It is supposed to be strictly declarative and only uses a subset of QML. If you edit
this file manually, you might introduce QML code that is not supported by Qt Design Studio.
Check out https://doc.qt.io/qtcreator/creator-quick-ui-forms.html for details on .ui.qml files.
*/
import QtQuick 6.5
import QtQuick.Controls 6.5
import MatSmily


Rectangle {
    id: rectangle
    width: Constants.width
    height: Constants.height
    objectName: "Screen01"
    color: Constants.get['backgroundColor']

    signal startNewImage()
    signal startEditImage(int index)

    Component {
        id: listDelegate2

        Item {
            id: delegateItem
            width: listView.width;
            height: listView.height/8
            clip: true
            Row {
                id : contentRow
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width
                height:parent.height
                spacing: 8

                Rectangle {
                    id : upArrRecy
                    width: parent.width*0.1
                    height: parent.height
                    anchors.verticalCenter: parent.verticalCenter
                    color: "transparent"
                    Image {
                        height: parent.height
                        source: "assets/icons/upArrow.svg"
                        fillMode: Image.PreserveAspectFit
                        MouseArea{
                            anchors.fill: parent
                            onClicked: GImageDataModel.moveImageUp(index)
                        }
                    }
                }
                Rectangle {
                    id : dwnArrRecy
                    width: parent.width*0.1
                    height: parent.height
                    anchors.verticalCenter: parent.verticalCenter
                    color: "transparent"
                    Image {
                        height: parent.height
                        fillMode: Image.PreserveAspectFit
                        source: "assets/icons/downArrow.svg"
                        MouseArea{
                            anchors.fill: parent
                            onClicked: GImageDataModel.moveImageDown(index)
                        }
                    }
                }
                Rectangle {
                    width: parent.width*0.4
                    height: parent.height
                    anchors.verticalCenter: parent.verticalCenter
                    color: "transparent"
                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        text: name
                        font.pixelSize: parent.height*0.3
                        color: "black"
                    }
                }
                Image{
                    width: parent.width*0.1
                    height: parent.height
                    anchors.verticalCenter: parent.verticalCenter
                    fillMode: Image.PreserveAspectFit
                    source: "assets/icons/newFile.svg"
                    MouseArea{
                        anchors.fill: parent
                        onClicked: startNewImage()
                    }
                }

                Image {
                    width: parent.width*0.1
                    height: parent.height
                    anchors.verticalCenter: parent.verticalCenter
                    fillMode: Image.PreserveAspectFit
                    source: "assets/icons/editFile.svg"
                    MouseArea{
                        anchors.fill: parent
                        onClicked: startEditImage(index)
                    }
                }

                Image {
                    width: parent.width*0.1
                     height: parent.height
                     fillMode: Image.PreserveAspectFit
                    source: "assets/icons/deleteFile.svg"
                    MouseArea{
                        anchors.fill: parent
                        onClicked: GImageDataModel.removeImage(index)
                    }
                }
            }

            Rectangle{
                id : divider
                width: contentRow.width
                height: 1
                color: "grey"
                anchors.bottom: parent.bottom
                radius: 0.5
            }

            // Animate adding and removing of items:

            ListView.onAdd: SequentialAnimation {
                PropertyAction { target: delegateItem; property: "height"; value: 0 }
                NumberAnimation { target: delegateItem; property: "height"; to: 55; duration: 250; easing.type: Easing.InOutQuad }
            }

            ListView.onRemove: SequentialAnimation {
                PropertyAction { target: delegateItem; property: "ListView.delayRemove"; value: true }
                NumberAnimation { target: delegateItem; property: "height"; to: 0; duration: 250; easing.type: Easing.InOutQuad }

                // Make sure delayRemove is set back to false so that the item can be destroyed
                PropertyAction { target: delegateItem; property: "ListView.delayRemove"; value: false }
            }
        }
    }

    // The view:
    ListView {
        id: listView
        anchors.fill: parent; anchors.margins: 10
        model: GImageDataModel//fruitModel
        delegate: listDelegate2
    }

    Row {
        anchors { left: parent.left; bottom: parent.bottom; margins: 20 }
        spacing: 10

        Button {
            text: "Add an item"
            onClicked: {
                fruitModel.append({
                    "name": "Pizza Margarita",
                    "cost": 5.95,
                    "attributes": [{"description": "Cheese"}, {"description": "Tomato"}]
                })
            }
        }

        Button {
            text: "Remove all items"
            onClicked: fruitModel.clear()
        }
    }
}

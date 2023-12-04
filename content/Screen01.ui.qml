

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

    // The model:
    ListModel {
        id: fruitModel

        ListElement {
            name: "Apple"; cost: 2.45
            attributes: [
                ListElement { description: "Core" },
                ListElement { description: "Deciduous" }
            ]
        }
        ListElement {
            name: "Banana"; cost: 1.95
            attributes: [
                ListElement { description: "Tropical" },
                ListElement { description: "Seedless" }
            ]
        }
        ListElement {
            name: "Cumquat"; cost: 3.25
            attributes: [
                ListElement { description: "Citrus" }
            ]
        }
        ListElement {
            name: "Durian"; cost: 9.95
            attributes: [
                ListElement { description: "Tropical" },
                ListElement { description: "Smelly" }
            ]
        }
    }

    // The delegate for each fruit in the model:
    Component {
        id: listDelegate

        Item {
            id: delegateItem
            width: listView.width; height: 55
            clip: true

            Row {
                anchors.verticalCenter: parent.verticalCenter
                height:parent.height
                spacing: 10

                Column {
                    Image {
                        height: parent.height
                        source: "assets/icons/upArrow.png"
                        fillMode: Image.PreserveAspectFit
                        MouseArea { anchors.fill: parent; onClicked: fruitModel.move(index, index-1, 1) }
                    }
                    Image {
                        height: parent.height
                        fillMode: Image.PreserveAspectFit
                        source: "assets/icons/downArrow.png"
                        MouseArea { anchors.fill: parent; onClicked: fruitModel.move(index, index+1, 1) }
                    }
                }

                Column {
                    anchors.verticalCenter: parent.verticalCenter

                    Text {
                        text: name
                        font.pixelSize: 15
                        color: "black"
                    }
                    Row {
                        spacing: 5
                        Repeater {
                            model: attributes
                            Text { text: description; color: "black" }
                        }
                    }
                }
            }

            Row {
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                spacing: 10

                Image{
                    height: parent.height
                    anchors.verticalCenter: parent.verticalCenter
                    fillMode: Image.PreserveAspectFit
                    source: "assets/icons/plus.png"
                    MouseArea{
                        anchors.fill: parent
                        onClicked: fruitModel.setProperty(index, "cost", cost + 0.25)
                    }
                }

                Text {
                    id: costText
                    anchors.verticalCenter: parent.verticalCenter
                    text: '$' + Number(cost).toFixed(2)
                    font.pixelSize: 15
                    color: "black"
                    font.bold: true
                }

                Image {
                    height: parent.height
                    anchors.verticalCenter: parent.verticalCenter
                    fillMode: Image.PreserveAspectFit
                    source: "assets/icons/minus.png"
                    MouseArea{
                        anchors.fill: parent
                        onClicked: fruitModel.setProperty(index, "cost", Math.max(0,cost-0.25))
                    }
                }

                Image {
                     height: parent.height
                     fillMode: Image.PreserveAspectFit
                    source: "assets/icons/delete.png"
                    MouseArea { anchors.fill:parent; onClicked: fruitModel.remove(index) }
                }
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
        anchors.fill: parent; anchors.margins: 20
        model: fruitModel
        delegate: listDelegate
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

import QtQuick 6.5
import QtQuick.Controls 6.5
import MatSmily
import "MyWidgets"

Rectangle {
    id: rectangle
    width: Constants.width
    height: Constants.height
    objectName: "DashBoard"
    color: Constants.get['thmBgPrimaryColor']

    Column {
        id: column
        anchors.fill: parent
        Row {
            id: row1
            height: parent.height * 0.2
            anchors.left: parent.left
            anchors.right: parent.right
            spacing: width * 0.05
            padding: spacing
            TextBoxCust {
                id: matW
                anchors.verticalCenter: parent.verticalCenter
                placeholder: "8"
            }

            Text {
                id: text1
                text: qsTr("X")
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 12
            }

            TextBoxCust {
                id: matX
                anchors.verticalCenter: parent.verticalCenter
                placeholder: "8"
            }

            ButtonCust {
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }
}

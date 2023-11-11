import QtQuick 6.5
import QtQuick.Controls 6.5
import QtQuick.Window 2.2
import MatSmily

Rectangle {
    id : root
    width: Constants.get['textBoxW']
    height: Constants.get['textBoxH']
    color: Constants.get['wdgtBaseColor']
    border.width: Constants.get['thmDefBoxBorderWidth']
    radius: Constants.get['thmDefBoxRadius']
    border.color: Constants.get['wdgetColor']
    clip: true

    property string placeholder: ""
    property alias text: control.text

    Rectangle {
        id : innerRect
        anchors.fill: parent
        anchors.rightMargin:  parent.width*0.05
        anchors.leftMargin:  parent.width*0.05
        color: "transparent"
        TextEdit  {
            id: control
            text : ""
            anchors.fill: parent
            padding: width *0.05
            verticalAlignment: Text.AlignVCenter
            font.family: Constants.largeFont.family
            font.pixelSize: Constants.largeFont.pixelSize
            horizontalAlignment: Text.AlignHCenter
            onTextChanged: {
                console.log("W : ",Constants.width," H:",Constants.height)
            }

            Text {
                id: placeholderText
                text: placeholder
                anchors.fill: parent
                verticalAlignment: Text.AlignVCenter
                font.family: Constants.largeFont.family
                font.pixelSize: Constants.largeFont.pixelSize
                horizontalAlignment: Text.AlignHCenter
                visible: !parent.text && !parent.activeFocus
            }
        }
    }
}

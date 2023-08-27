import QtQuick.Controls 2.15
import QtQuick
import QtQuick.Controls
import MatSmily

Button {
    id: control
    text: qsTr("Button")
    width: Constants.get['buttonW']
    height: Constants.get['buttonH']

    contentItem: Text {
        text: control.text
        font: control.font
        opacity: enabled ? 1.0 : 0.3
        color: control.down ? "#000000" :  Constants.get['thmBoarderColor']
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }

    background: Rectangle {
        opacity: enabled ? 1 : 0.3
        border.color: control.down ? "#000000" : Constants.get['thmBoarderColor']
        border.width: Constants.get['thmDefBoxBorderWidth']
        radius: Constants.get['thmDefBoxRadius']
    }
}

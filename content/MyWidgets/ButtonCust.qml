import QtQuick.Controls 2.15
import QtQuick
import QtQuick.Controls
import MatSmily

Button {
    id: control
    text: qsTr("Button")
    width: Constants.get['buttonW']
    height: Constants.get['buttonH']
    palette {
        button: "green"
    }
    contentItem: Text {
        text: control.text
        font: control.font
        opacity: enabled ? 1.0 : 0.3
        color: control.down ? "#ffffff" :(parent.hovered ? "#ffffff" :Constants.get['thmBoarderColor'])
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }

    background: Rectangle {
        opacity: enabled ? 1 : 0.3
        color: parent.down ? "#008CBA" :
                             (parent.hovered ? "#45b8de" : "#f6f6f6")
        border.width: Constants.get['thmDefBoxBorderWidth']
        radius: Constants.get['thmDefBoxRadius']
        border.color: "#45b8de"
    }
}

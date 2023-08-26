

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

    property alias title: textItem.text

    Image {
        id: logo1
        anchors.fill: parent
        source: "assets/images/logo.png"
        sourceSize.width: parent.width * 0.8
        fillMode: Image.PreserveAspectFit
    }

    Text {
        id: textItem
        text: qsTr("Hello MatSmily") + " 01"
        anchors.centerIn: parent
        font.family: Constants.largeFont.family
        font.pixelSize: Constants.largeFont.pixelSize
    }
}

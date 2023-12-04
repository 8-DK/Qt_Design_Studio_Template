import QtQuick.Controls 2.15
import QtQuick
import QtQuick.Controls
import MatSmily

Dialog {
    id: dialog
    width: Constants.get['dialogueW']
    height: Constants.get['dialogueH']
    title: "Custom Dialog"
    anchors.centerIn: parent
    property int buttonsEnabled: Dialog.Ok | Dialog.Cancel
    property alias text: intext.text
    TextBoxCust {
        id: intext
        width: parent.width * 0.8
        anchors.horizontalCenter : parent.horizontalCenter
        placeholder: "Enter file name ..."
    }

    ButtonCust {
        id : okBtn
        width: parent.width * 0.3
        text: qsTr("Ok")
        visible: buttonsEnabled & Dialog.Ok
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.rightMargin: parent.width * 0.1
        anchors.bottomMargin: parent.width * 0.03
        onClicked: {
            accepted()
            close()
        }
    }

    ButtonCust {
        text: qsTr("Cancel")
        width: parent.width * 0.3
        visible: buttonsEnabled & Dialog.Cancel
        anchors.bottom: parent.bottom
        anchors.right: okBtn.left
        anchors.rightMargin: parent.width * 0.05
        anchors.bottomMargin: parent.width * 0.03
        onClicked: {
            rejected()
            close()
        }
    }
}

import QtQuick 6.5
import QtQuick
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
                onClicked: {
                    canvas.clear_canvas()
                }
            }
        }

        Row {
            id: colorTools
            anchors.top: row1.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            height: parent.height*0.1
            property color paintColor: "#33B5E5"
            property int showCount: 4
            spacing: rep.width*0.01
            ListView {
                id : rep
                anchors.fill: parent
                orientation: ListView.Horizontal
                model: ["#69D2E7","#A7DBD8","#E0E4CC","#F38630","#FA6900","#FE4365","#FC9D9A","#F9CDAD","#C8C8A9","#83AF9B","#ECD078","#D95B43","#C02942","#542437","#53777A"]
                delegate :
                    Rectangle {
                    width: (colorTools.width/colorTools.showCount)*0.8
                    height:width
                    color: modelData
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            colorTools.paintColor = color
                        }
                    }
                }
            }
        }
        Canvas {
            id: canvas
            width: parent.width
            anchors.top: colorTools.bottom
            anchors.bottom: parent.bottom
            property real lastX
            property real lastY
            property color drawColor: colorTools.paintColor
            property int wgrid: 4
            property int col: 8
            property int row: 10

            onPaint: {
                var ctx = getContext('2d')

                if( lastX > -1 && lastY > -1 )
                {

                    lastX = area.mouseX
                    lastY = area.mouseY

                    //stroke box only
                    lastX = Math.ceil(lastX)
                    lastY = Math.ceil(lastY)

                    var rw = width/col
                    var rh = height/row

                    var x1 = (lastX - (lastX%(rw)));
                    var y1 = (lastY - (lastY%(rh)));
                    ctx.fillStyle = canvas.drawColor
                    ctx.fillRect(x1,y1,rw,rh);
                    ctx.stroke()
                }
                //draw grid
                ctx.lineWidth = 1
                ctx.strokeStyle = "black"
                for (var i = 0; i < col+1; i++) {
                    // Vertical lines
                    ctx.beginPath();
                    ctx.moveTo(i * rw, 0);
                    ctx.lineTo(i * rw, height);
                    ctx.stroke();
                }
                for (var i = 0; i < row+1; i++) {
                    // Horizontal lines
                    ctx.beginPath();
                    ctx.moveTo(0, i * rh);
                    ctx.lineTo(width, i * rh);
                    ctx.stroke();
                }
                ctx.stroke()
            }

            function clear_canvas() {
                canvas.lastX = 0
                canvas.lastY = 0
                var ctx = getContext("2d");
                ctx.reset();
                canvas.requestPaint();
            }

            MouseArea {
                id: area
                anchors.fill: parent
                onPressed: {
                    canvas.lastX = mouseX
                    canvas.lastY = mouseY
                }
                onPositionChanged: {
                    canvas.requestPaint()
                }
            }
        }
    }
}

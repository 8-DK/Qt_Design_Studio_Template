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
            property color color: colorTools.paintColor
            property int wgrid: 20

            onPaint: {
                var ctx = getContext('2d')
                ctx.lineWidth = wgrid//1.5
                ctx.strokeStyle = canvas.color
                ctx.beginPath()
                ctx.moveTo(lastX, lastY)
                lastX = area.mouseX
                lastY = area.mouseY
                ctx.lineTo(lastX, lastY)
                ctx.stroke()

                //draw grid
                ctx.lineWidth = 1
                ctx.strokeStyle = "black"
                ctx.beginPath()
                var nrows = height/wgrid;
                for(var i=0; i < nrows+1; i++){
                    ctx.moveTo(0, wgrid*i);
                    ctx.lineTo(width, wgrid*i);
                }

                var ncols = width/wgrid
                for(var j=0; j < ncols+1; j++){
                    ctx.moveTo(wgrid*j, 0);
                    ctx.lineTo(wgrid*j, height);
                }
                ctx.closePath()
                ctx.stroke()

                ctx.beginPath()
                ctx.lineWidth = wgrid
                ctx.strokeStyle = "red"
                ctx.beginPath()
                //stroke box only
                lastX = Math.ceil(lastX)
                lastY = Math.ceil(lastY)
                var x1 = (lastX - (lastX%wgrid));
                var y1 = (lastY - (lastY%wgrid));

                var x2 = x1 + wgrid
                var y2 = y1 + wgrid

                ctx.fillRect(x1,x2,y1,y2);
                ctx.stroke()


                console.log("X : ",lastX,", Y :",lastX)
                console.log("Rect : ",x1,",",y1," , ",x2,",",y2)
            }

            function clear_canvas() {
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

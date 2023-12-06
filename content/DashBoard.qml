import QtQuick 6.5
import QtQuick
import QtQuick.Controls 6.5
import MatSmily
import "MyWidgets"

Rectangle {
    id: rectangle
    width: root.width//Constants.width
    height: root.height//Constants.height
    objectName: "DashBoard"
    color: Constants.get['thmBgPrimaryColor']

    GetValueDialogue{
        id : saveTofileDialogue
        onAccepted:{
            GImageDataModel.saveImage(text,canvas.col,canvas.row,canvas.colorMap)
            canvas.grabToImage(function(result) {
                if (result.error) {
                    console.error("Error capturing image:", result.errorString);
                } else {
                    var img = result.image;
                    GImageDataModel.saveThumbImage(img,text);
                }
            });
        }
    }

    Column {
        id: column
        anchors.fill: parent

        Row {
            id: row1
            height: parent.height * 0.08
            anchors.left: parent.left
            anchors.right: parent.right
            spacing: width * 0.05
            padding: spacing
            TextBoxCust {
                id: matW
                anchors.verticalCenter: parent.verticalCenter
                placeholder: "8"
                text : "8"
            }

            Text {
                id: text1
                text: qsTr("X")
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 12
            }

            TextBoxCust {
                id: matH
                anchors.verticalCenter: parent.verticalCenter
                placeholder: "8"
                text : "8"
            }

            ButtonCust {
                text: qsTr("Set")
                anchors.verticalCenter: parent.verticalCenter
                onClicked: {
//                    canvas.clear_canvas()
                    console.log("Col : ",matW.text, "Row :",matH.text)
                    canvas.col = parseInt(matW.text)
                    canvas.row = parseInt(matH.text)
                    canvas.clear_canvas()
                }
            }
        }
        Row {
            id: row2
            height: parent.height * 0.08
            anchors.top: row1.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            spacing: width * 0.05
            padding: spacing
            ButtonCust {
                width: parent.width*0.2
                text: qsTr("Clear")
                anchors.verticalCenter: parent.verticalCenter
                onClicked: {
                    canvas.clear_canvas()
                }
            }
            ButtonCust {
                width: parent.width*0.2
                text: qsTr("Save")
                anchors.verticalCenter: parent.verticalCenter
                onClicked: {
                    saveTofileDialogue.open()
                    //                    canvas.clear_canvas()
                }
            }
            ButtonCust {
                width: parent.width*0.2
                text: qsTr("Apply")
                anchors.verticalCenter: parent.verticalCenter
                onClicked: {
                    canvas.clear_canvas()
                }
            }
        }
        Row {
            id: colorTools
            anchors.top: row2.bottom
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
                model: ["#ffffff","#000000","#69D2E7","#A7DBD8","#E0E4CC","#F38630","#FA6900","#FE4365","#FC9D9A","#F9CDAD","#C8C8A9","#83AF9B","#ECD078","#D95B43","#C02942","#542437","#53777A"]
                delegate :
                    Rectangle {
                    width: (colorTools.width/colorTools.showCount)*0.8
                    height:colorTools.height
                    color: modelData
                    border.width: 2
                    border.color: selColMouseArea.hovered ? "#000000" :"#55000000"
                    radius: 10
                    MouseArea{
                        id : selColMouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                        property bool hovered: false
                        property bool pressed: false
                        onEntered: hovered = true
                        onExited: hovered = false
                        onPressed: pressed = true
                        onReleased: pressed = false
                        onClicked: {
                            colorTools.paintColor = color
                        }
                    }
                    Rectangle {
                        id : overlay
                        anchors.fill: parent
                        color: "#55ffffff"
                        visible: selColMouseArea.pressed
                    }
                }
            }
        }
        Canvas {
            id: canvas
            width: parent.width
            height: parent.height * 0.64
            anchors.top: colorTools.bottom
            //            anchors.bottom: parent.bottom
            property bool gridDrawn: false
            property bool redrawCanvas: false
            property real lastX
            property real lastY
            property color drawColor: colorTools.paintColor
            property int wgrid: 4
            property int gridWidth: 1
            property int col: 8
            property int row: 8

            property real rw : width/col
            property real rh : height/row
            onHeightChanged: gridDrawn = false
            onWidthChanged: gridDrawn = false
            property var colorMap: {"":""}

            onPaint: {
                var ctx = getContext('2d')

                if( lastX > -1 && lastY > -1 )
                {
                    lastX = area.mouseX
                    lastY = area.mouseY

                    //stroke box only
                    lastX = Math.ceil(lastX)
                    lastY = Math.ceil(lastY)

                    var x1 = (lastX - (lastX%(rw))) + gridWidth;
                    var y1 = (lastY - (lastY%(rh))) + gridWidth;
                    ctx.fillStyle = canvas.drawColor
                    ctx.fillRect(x1,y1,rw-(gridWidth*2),rh-(gridWidth*2));
                    ctx.stroke()
                    var indices = calculateIndices(lastX, lastY);
                    console.log("Grid Indices - i:", indices.i, " j:", indices.j," Col:",canvas.drawColor);
                    var colr = ctx.fillStyle
                    if((indices.i > -1) && (indices.j > -1) && (colr !== ""))
                        setColorAtIndex(indices.i, indices.j, colr);
                    //                    // To retrieve color at a specific index
                    //                    var storedColor = colorMap[indices.i + "-" + indices.j];
                    //                    console.log("Color at index (", indices.i, ",", indices.j, "):", storedColor);
                }
                //draw grid
                if(gridDrawn == false)
                {
                    ctx.fillStyle = "white"
                    ctx.fillRect(0,0,width,height);
                    ctx.stroke()

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
                    gridDrawn = true
                }
                if(redrawCanvas)
                {
                    for (var i = 0 ; i < col;i++)
                    {
                        for (var j = 0 ; j < row;j++)
                        {
                            var key = i + "-" + j
                            if(!colorMap[key])
                                colorMap[key] = "#ffffff"
                            ctx.fillStyle = colorMap[key]
                            ctx.fillRect(i*rw,j*rh,rw-(gridWidth*1),rh-(gridWidth*1));
                            ctx.stroke()
                        }
                    }
                    redrawCanvas = false
                }
            }

            // Function to set color at a specific index
            function setColorAtIndex(i, j, color) {
                var key = i + "-" + j; // Use a unique key for each grid position
                colorMap[key] = color;
            }

            function calculateIndices(mouseX, mouseY) {
                var gridWidth = canvas.width / col;
                var gridHeight = canvas.height / row;

                var i = Math.floor(mouseX / gridWidth);
                var j = Math.floor(mouseY / gridHeight);

                return { i: i, j: j };
            }

            function clear_canvas() {
                canvas.lastX = -1
                canvas.lastY = -1
                canvas.gridDrawn = false;
                var ctx = getContext("2d");
                ctx.reset();
                canvas.requestPaint();
            }

            MouseArea {
                id: area
                anchors.fill: parent
                onClicked: {
                    canvas.requestPaint()
                }
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

    function startNewFile()
    {
        matW.text = "8"
        matH.text = "8"
        canvas.col = parseInt(matW.text)
        canvas.row = parseInt(matH.text)
        canvas.clear_canvas()
    }

    function startEditFile(index)
    {
        canvas.clear_canvas()
        console.log("Edit image : ",GImageDataModel.getFileName(index))
        saveTofileDialogue.text = GImageDataModel.getFileName(index)
        matW.text = GImageDataModel.getWidth(index)
        matH.text = GImageDataModel.getHeight(index)
        canvas.col = parseInt(matW.text)
        canvas.row = parseInt(matH.text)
        canvas.colorMap = GImageDataModel.getCanvas(index)
        canvas.redrawCanvas = true
        canvas.requestPaint();

    }
}

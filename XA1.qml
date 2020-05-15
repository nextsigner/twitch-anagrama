import QtQuick 2.0
import QtMultimedia 5.0

Rectangle {
    id: r
    width: l.contentWidth+app.fs
    height: l.contentHeight+app.fs
    x:0//x1.x
    //anchors.right: parent.right
    color: 'green'
    opacity: 1.0
    z:999999
    radius: app.fs*0.5
    property string text
    onOpacityChanged:{
        if(r.opacity===0.0)r.destroy(10)
    }
    onYChanged: {
        if(y<r.parent.height*0.1){
            r.opacity=0.0
        }
    }
    Behavior on opacity{
        NumberAnimation{duration: 5000}
    }
    Behavior on y{
        NumberAnimation{duration: 2000}
    }
    UText{
        id: l
        text: r.text
        width: r.width-app.fs
        wrapMode: Text.WordWrap
        anchors.centerIn: r
        font.pixelSize: app.fs*2
        color: 'white'
    }
    Image {
        id: img
        source: "file:./imgs/point.png"
        width: app.fs*5
        height: width
        fillMode: Image.PreserveAspectFit
        anchors.left: r.right
        anchors.leftMargin: app.fs
        anchors.verticalCenter: r.verticalCenter
        rotation: 25
    }
    Audio{
        id: ap
        source: 'file:./sounds/acert1.wav'
        autoLoad: true
        autoPlay: true
    }
    Component.onCompleted: {
       r.y=0
        xPanelData.visible=true
        xPanelPrev.visible=false
    }
}

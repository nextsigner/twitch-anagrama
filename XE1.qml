import QtQuick 2.0
import QtMultimedia 5.0

Rectangle {
    id: r
    width: xApp.width*0.3
    height: l.contentHeight+app.fs
    anchors.right: parent.right
    color: 'red'
    opacity: 1.0
    z:999999
    radius: app.fs*0.5
    property string text
    onOpacityChanged:{
        if(r.opacity===0.0)r.destroy(10)
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
    Audio{
        id: ap
        source: 'file:./sounds/fail.wav'
        autoLoad: true
        autoPlay: true
    }
    Component.onCompleted: {
       r.y=0
        r.opacity=0.0
    }
}

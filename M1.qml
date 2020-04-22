import QtQuick 2.0

Item {
    id: r
    width: w
    height: width
    property int w: app.fs
    property int vel: 1000
    onYChanged:{
        if(y<0-r.height){
            r.destroy(1)
        }
    }
    Behavior on y{
        NumberAnimation{duration: r.vel; easing.type: Easing.InCirc}
    }
    Rectangle{
        id: bg
        anchors.fill: r
        radius: width*0.5
    }
    Component.onCompleted: {
        r.y=0-r.height-50
    }
}

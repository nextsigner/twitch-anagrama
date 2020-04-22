import QtQuick 2.0

Item {
    id: r
    width: w
    height: width
    property int w: app.fs
    property int vel: 500
    property int xd:-1
    property int yd:-1
    property var uForAutoKill
    onYChanged:{
        td.restart()
    }
    Behavior on x{
        NumberAnimation{duration: r.vel;}
    }
    Behavior on y{
        NumberAnimation{duration: r.vel;}
    }
    Rectangle{
        id: bg
        anchors.fill: r
        radius: width*0.5
        Rectangle{
            id: efe1
            height: parent.width*3
            width: 1
            anchors.centerIn: parent
            SequentialAnimation{
                running: true
                loops: Animation.Infinite
                NumberAnimation {
                    target: efe1
                    property: "rotation"
                    duration: 2000
                    easing.type: Easing.InOutQuad
                    from: 0
                    to:700
                }
            }
        }
    }
    Timer{
        id: td
        interval: 250
        onTriggered: {
            r.destroy(1)
        }
    }
    Timer{
        id: tdir
        running: x1.autoKill
        repeat: true
        interval: 100
        onTriggered: {
            if(x1.autoKill){
                if(r.uForAutoKill&&r.uForAutoKill.x){
                    r.x=r.uForAutoKill.x
                    r.y=r.uForAutoKill.y
                }
            }else{
                r.x=maCursor.mouseX
                r.y=maCursor.mouseY
            }

        }
    }
    Component.onCompleted: {
        r.x=r.xd
        r.y=r.yd
    }
}

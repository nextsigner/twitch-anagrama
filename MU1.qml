import QtQuick 2.0

Item {
    id: r
    width: w
    height: width
    property int w: app.fs
    property int vel: 3000
    property int xd: 0
    property int yd: 0
    property var objShooter
    onYChanged:{
        tDestroy.restart()
        if(y>r.parent.height){
            r.destroy(1)
        }
    }
    onXChanged: tDestroy.restart()
    Behavior on x{
        NumberAnimation{duration: r.vel;}
    }
    Behavior on y{
        NumberAnimation{duration: r.vel;}
    }
    Behavior on opacity{
        NumberAnimation{duration: 250;}
    }
    onOpacityChanged: {
        if(opacity===0.0){
            //unik.speak('Eliminado')
            r.destroy(10)
        }
    }
    AnimatedImage {
        id: animation1;
        width: r.w*3
        height: width
        source: "file:./img/m1.gif"
        anchors.centerIn: r
        visible: !animation.visible
        paused: !visible
    }
    AnimatedImage {
        id: animation;
        width: r.w*3
        height: width
        source: "file:./img/e1.gif"
        anchors.centerIn: r
        visible: false
        paused: !visible
    }
    Timer{
        id: tShowExp
        running: false
        repeat: false
        interval: 500
        onTriggered: {
            r.opacity=0.0
        }
    }
    Timer{
        running: true
        repeat: true
        interval: 50
        onTriggered: {
            stop()
            if(r.y>=p1.y&&r.y<=p1.y+p1.height&&r.x>=p1.x&&r.x+r.width<=p1.x+p1.width){
                p1.recept()
                animation.visible=true
                tShowExp.start()
                if(r.objShooter){
                    r.objShooter.addScore()
                }
                return
            }
            for(let i=0;i<x1.children.length;i++){
                let obj=x1.children[i]
                if(obj.objectName.indexOf('obj')===0){
                    if(obj.y+r.height>=r.y&&obj.y-r.height<r.y&&obj.x+r.width>=r.x&&obj.x-r.width<r.x){
                        p1.recept()
                        animation.visible=true
                        tShowExp.start()
                        return
                    }
                }
            }
            start()
        }
    }
    Timer{
        id: tDestroy
        running: false
        repeat: true
        interval: 300
        onTriggered: {
            r.destroy(1)
        }
    }
    Component.onCompleted: {
        r.x=r.xd
        r.y=r.yd
    }
}

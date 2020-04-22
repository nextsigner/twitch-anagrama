import QtQuick 2.0
import QtGraphicalEffects 1.0

Item {
    id: r
    width: w
    height: w
    property int numShot: 0
    property int w: app.fs*2
    property color c1: 'red'
    Behavior on x{
        NumberAnimation{duration: 100}
    }
    Behavior on y{
        NumberAnimation{duration: 100}
    }
    Rectangle{
        width: r.w
        height: width
        color: 'transparent'
        //border.width: 1
        //border.color: 'red'
    }
    Rectangle{
        id: xc1
        width: r.width
        height: width
        radius: width*0.5
        color: 'transparent'
        border.width: 10
        border.color: app.c2
        anchors.centerIn: r
        Behavior on rotation{
            NumberAnimation{duration: 100}
        }
        SequentialAnimation{
            running: true
            loops: Animation.Infinite
            NumberAnimation {
                target: xc1
                property: "border.width"
                duration: 500
                easing.type: Easing.InOutQuad
                from: app.fs*0.8
                to:2
            }
            NumberAnimation {
                target: xc1
                property: "border.width"
                duration: 800
                easing.type: Easing.InOutQuad
                from: 2
                to:app.fs*0.8
            }
        }
        Rectangle{
            width: r.width
            height: width
            radius: width*0.5
            anchors.centerIn: parent
            z: parent.z-1
        }
        XEd1{
            height: app.fs
            tc: app.fs*0.3
            anchors.centerIn: parent
        }
    }
    Item{
        id: xShooter
        width: r.width
        height: r.height
        anchors.centerIn: r
        Item{
             width: parent.width
             height: parent.height*0.5
             anchors.bottom: parent.bottom
             //anchors.centerIn: parent
             rotation: 180
             clip: true
             opacity: 0.5
             Rectangle{
                width: parent.width
                height: width
                radius: width*0.5
                color: 'blue'
             }
        }
        Image {
            id: img1
            source: "file:./img/ar1.png"
            anchors.centerIn: parent
            anchors.verticalCenterOffset: parent.height*0.25
            width: r.w*0.75
            height: r.w*0.75
        }
        ColorOverlay {
            id: co
            anchors.fill: img1
            source: img1
            color: app.c2
            opacity: 0.0
            onOpacityChanged:{
                if(opacity===1.0){
                    opacity=0.0
                }
            }
            Behavior on opacity{
                NumberAnimation{duration: 300}
            }
        }
    }
    function u(){
        if(y<100)return
        y-=10
    }
    function d(){
        if(y>r.parent.height-r.height)return
        y+=10
    }
    function r(){
        if(x>parent.width-width)return
        x+=10
    }
    function l(){
        if(r.x-10<0)return
        r.x-=10
    }
    function rot(px, py){
        var	dx = parseInt(r.x-r.width*0.5) - px,
        dy = parseInt(r.y+r.width*0.5) - py;
        var theta = Math.atan2(dy, dx); // range (-PI, PI]
        theta *= 180 / Math.PI;
        xShooter.rotation= theta-90
    }
    function recept(){
        co.opacity=1.0
    }
    function s(){
        ap.stop()
        let ws=app.fs*0.25
        let comp=Qt.createComponent("M1.qml")
        let obj=comp.createObject(r.parent, {w: ws, x: r.x+r.width*0.5-ws*0.5, y:r.y+r.height, objectName: 'obj'+r.numShot})
        //let obj=comp.createObject(r.parent, {w: ws, x: r.x+r.width*0.5-ws*0.5, y:r.y, objectName: 'obj1'})
        ap.play()
        r.numShot++
    }
    function s2(px, py, objForKill){
        ap.stop()
        let ws=app.fs*0.25
        let comp=Qt.createComponent("M2.qml")
        let obj=comp.createObject(r.parent, {w: ws, rotation: xShooter.rotation, x: r.x+r.width*0.5-ws*0.5, y:r.y+r.height*0.5, xd: px, yd: py, objectName: 'obj'+r.numShot, uForAutoKill: objForKill})
        //let obj=comp.createObject(r.parent, {w: ws, x: r.x+r.width*0.5-ws*0.5, y:r.y, objectName: 'obj1'})
        ap.play()
        r.numShot++
    }
}

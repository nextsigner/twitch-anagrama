import QtQuick 2.0

Item{
    id: r
    width: parent.width+tc*2
    height: parent.width*0.25
    property int tc: app.fs
    Row{
        anchors.centerIn: r
        Item{
            width: r.width*0.5
            height: r.height
            Rectangle{
                width: r.tc
                height: width
                radius: width*0.5
                anchors.verticalCenter: parent.verticalCenter
            }
        }
        Item{
            width: r.width*0.5
            height: r.height
            Rectangle{
                width: r.tc
                height: width
                radius: width*0.5
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }
    SequentialAnimation{
        running: true
        loops: Animation.Infinite
        NumberAnimation {
            target: r
            properties: "rotation"
            duration: 600
            from:0
            to:360
            //easing.type: Easing.InCirc
        }
        NumberAnimation {
            target: r
            properties: "rotation"
            duration: 1000
            from:0
            to:360
            //easing.type: Easing.InCirc
        }
        NumberAnimation {
            target: r
            properties: "rotation"
            duration: 1000
            from:0
            to:360
            //easing.type: Easing.InCirc
        }
    }
}

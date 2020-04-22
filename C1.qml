import QtQuick 2.0

Rectangle {
    id: r
    width: app.fs*2
    height: width
    color: 'transparent'
    border.width: 2
    border.color: 'red'
    radius: width*0.5
    Behavior on x{
        NumberAnimation{duration: 100}
    }
    Behavior on y{
        NumberAnimation{duration: 100}
    }
    Item{
        width: r.width
        height: 2
        anchors.centerIn: r
        Rectangle{
            width: r.width*0.25
            height: parent.height
            color: r.border.color
        }
        Rectangle{
            width: r.width*0.25
            height: parent.height
            color: r.border.color
            anchors.right: parent.right
        }
    }
    Item{
        rotation: -90
        width: r.width
        height: 2
        anchors.centerIn: r
        Rectangle{
            width: r.width*0.25
            height: parent.height
            color: r.border.color
        }
        Rectangle{
            width: r.width*0.25
            height: parent.height
            color: r.border.color
            anchors.right: parent.right
        }
    }
}

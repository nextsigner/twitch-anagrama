import QtQuick 2.0

Rectangle {
    id: r
    width: parent.width
    border.width: 1
    border.color: app.c2
    color: 'transparent'
    //height: app.fs*1.4
    //    SequentialAnimation{
    //        running: flowWU.width>r.parent.width
    //        loops: Animation.Infinite
    //        NumberAnimation {
    //            id:na1
    //            target: flowWU
    //            property: "x"
    //            duration: app.wordsUsed.length*1000
    //            //easing.type: Easing.InOutQuad
    //            from: 0
    //            to: 0-flowWU.width*0.5-flowWU.spacing
    //        }
    ////        NumberAnimation {
    ////            id:na2
    ////            target: flowWU
    ////            property: "x"
    ////            from: flowWU.x
    ////            to: 0
    ////        }
    //    }
    Flickable{
        id: flWU
        anchors.fill: r
        contentWidth: r.width
        contentHeight: flowWU.height
        Flow{
            id: flowWU
            spacing: app.fs
            Behavior on x{
                NumberAnimation{duration: 8000}
            }
            Repeater{
                id: repWU
                model: app.wordsUsed
                Rectangle{
                    width: labelWord.contentWidth+app.fs
                    height: labelWord.height+app.fs*0.2
                    border.width: 2
                    border.color: app.c2
                    radius: app.fs*0.25
                    color: 'transparent'
                    UText{
                        id: labelWord
                        text: modelData
                        width: contentWidth
                        anchors.centerIn: parent
                    }
                }
            }
        }
    }
    Timer{
        id: tUpdate
        running: true
        repeat: true
        interval: 1000
        property int v: 0
        onTriggered: {
            var a=app.wordsUsed
            repWU.model=a
            if(flWU.contentY===0){
                flWU.contentY=flWU.contentHeight-flWU.height
            }
            if(flWU.contentY===flWU.contentHeight-flWU.height){
                flWU.contentY=0
            }
        }
    }
}

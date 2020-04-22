import QtQuick 2.0

Item {
    id: r
    width: parent.width
    height: app.fs*1.4
    //    SequentialAnimation{
    //        running: rowWordsUsed.width>r.parent.width
    //        loops: Animation.Infinite
    //        NumberAnimation {
    //            id:na1
    //            target: rowWordsUsed
    //            property: "x"
    //            duration: app.wordsUsed.length*1000
    //            //easing.type: Easing.InOutQuad
    //            from: 0
    //            to: 0-rowWordsUsed.width*0.5-rowWordsUsed.spacing
    //        }
    ////        NumberAnimation {
    ////            id:na2
    ////            target: rowWordsUsed
    ////            property: "x"
    ////            from: rowWordsUsed.x
    ////            to: 0
    ////        }
    //    }
    Row{
        id: rowWordsUsed
        spacing: app.fs
        Behavior on x{
            NumberAnimation{duration: 8000}
        }
        Repeater{
            id: repWU
            model: app.wordsUsed
            Rectangle{
                width: labelWord.contentWidth+app.fs
                height: r.height
                border.width: 2
                border.color: app.c2
                radius: app.fs*0.25
                color: 'transparent'
                UText{
                    id: labelWord
                    text: modelData
                    anchors.centerIn: parent
                }
            }
        }
    }
    Row{
        id: rowWordsUsed2
        spacing: app.fs
        anchors.left: rowWordsUsed.right
        anchors.leftMargin: rowWordsUsed.spacing
        anchors.verticalCenter: rowWordsUsed.verticalCenter
        Repeater{
            id: repWU2
            model: app.wordsUsed
            Rectangle{
                width: labelWord2.contentWidth+app.fs
                height: r.height
                border.width: 2
                border.color: app.c2
                radius: app.fs*0.25
                color: 'transparent'
                UText{
                    id: labelWord2
                    text: modelData
                    anchors.centerIn: parent
                }
            }
        }
    }
    Row{
        id: rowWordsUsed3
        spacing: app.fs
        anchors.right: rowWordsUsed.left
        anchors.rightMargin: rowWordsUsed.spacing
        anchors.verticalCenter: rowWordsUsed.verticalCenter
        Repeater{
            id: repWU3
            model: app.wordsUsed
            Rectangle{
                width: labelWord2.contentWidth+app.fs
                height: r.height
                border.width: 2
                border.color: app.c2
                radius: app.fs*0.25
                color: 'transparent'
                UText{
                    id: labelWord2
                    text: modelData
                    anchors.centerIn: parent
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
            repWU2.model=a

            if(rowWordsUsed.width<=r.width)return
            if(rowWordsUsed.x===0){
                rowWordsUsed.x=0-rowWordsUsed.width
            }
            if(rowWordsUsed.x===0-rowWordsUsed.width){
                rowWordsUsed.x=0
            }
        }
    }
}

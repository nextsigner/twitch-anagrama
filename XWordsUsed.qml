import QtQuick 2.0

Rectangle {
    id: r
    width: parent.width
    border.width: 1
    border.color: app.c2
    color: 'transparent'
    clip: true
    property int fs: app.fs*4
    UText{id: txtCant; text: '<b>'+app.wordsUsed.length+'</b>'; font.pixelSize: r.width*0.5; opacity: 0.65;anchors.centerIn: r}
    Item{
        id: xwu
        anchors.fill: r

    }


    Component{
        id: compUWU
        Rectangle{
            id: xCompUWU
            width: parent.width-app.fs*0.5
            height: labelWord.contentHeight+app.fs
            anchors.horizontalCenter: parent.horizontalCenter
//            border.width: 2
//            border.color: app.c2
//            radius: app.fs*0.25
            color: 'transparent'
            property string word
            property int time
            onYChanged:{
                if(y<0-xCompUWU.height)xCompUWU.destroy(10)
            }
            Behavior on y{
                NumberAnimation{duration: time*2000}
            }
            UText{
                id: labelWord
                text: word
                font.pixelSize: r.fs
                width: xCompUWU.width
                wrapMode: Text.WrapAnywhere
                horizontalAlignment: Text.AlignHCenter
                textFormat: Text.RichText
                anchors.centerIn: parent
            }
            Component.onCompleted: {
                y=0-xCompUWU.height*2
            }
        }
    }
    Timer{
        id: tMove
        running: true
        repeat: true
        interval: 1000
        property int uc: 0
        onTriggered: {
            if(app.wordsUsed.length===0)return
            if(xwu.children.length>1)return
            let data=''
            for(var i=0;i<app.wordsUsed.length;i++){
                data+='<span style="font-size:'+parseInt(app.fs*1.5)+'px">'+app.wordsUsedBy[app.wordsUsed.indexOf(app.wordsUsed[i])]+'</span><br />'
                data+=app.wordsUsed[i]
                if(i<app.wordsUsed.length-1){
                    data+='<br /><br />'
                }
            }
            tMove.interval=app.wordsUsed.length*1000
            let comp=compUWU
            let obj=comp.createObject(xwu, {y:r.height+app.fs*2, word:data, time: app.wordsUsed.length})
            txtCant.text='<b>'+app.wordsUsed.length+'</b>'
        }
    }
    //    Timer{
    //        id: tUpdate
    //        running: true
    //        repeat: true
    //        interval: 300
    //        onTriggered: {
    //            if(lmUWU.count!==app.wordsUsed.length){
    //                lmUWU.append(lmUWU.addItem(app.wordsUsed[app.wordsUsed.length-1]))
    //            }
    //        }
    //    }
}

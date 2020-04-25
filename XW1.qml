import QtQuick 2.0
import QtMultimedia 5.0

Rectangle {
    id: r
    width: xApp.width*0.75
    height: xApp.height*0.75
    anchors.centerIn: parent
    color: 'green'
    //opacity: 0.0
    z:999999
    border.width: 4
    border.color: 'white'
    radius: app.fs*0.5

    property string u
    property int s
    onOpacityChanged:{
        //if(r.opacity===0.0)r.destroy(10)
    }
    Behavior on opacity{
        NumberAnimation{duration: 5000}
    }
    Behavior on y{
        NumberAnimation{duration: 2000}
    }
    MouseArea{
        anchors.fill: r
        onDoubleClicked: r.destroy(10)
    }
    Column{
        anchors.centerIn: r
        UText{
            id: l
            text: 'Felicitaciones '+r.u+'!!!'
            width: r.width-app.fs
            wrapMode: Text.WordWrap
            horizontalAlignment: Text.AlignHCenter
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: app.fs*5
            color: 'white'
        }
        UText{
            id: l2
            text: 'Has ganado la partida'
            width: r.width-app.fs
            wrapMode: Text.WordWrap
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: app.fs*3
            color: 'white'
        }
        UText{
            id: l3
            text: 'Conseguiste acumular'
            width: r.width-app.fs
            wrapMode: Text.WordWrap
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: app.fs*3
            color: 'white'
        }
        UText{
            id: l4
            text: '<b>'+r.s+'</b> puntos!'
            width: r.width-app.fs
            wrapMode: Text.WordWrap
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: app.fs*3
            color: 'white'
        }
        UText{
            id: l5
            width: r.width-app.fs
            wrapMode: Text.WordWrap
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: app.fs*3
            color: 'white'
        }
    }
    Image {
        id: img
        source: "file:./imgs/w1.png"
        width: app.fs*10
        height: width
        fillMode: Image.PreserveAspectFit
        anchors.right: r.right
        anchors.rightMargin: 0-app.fs*1.5
        anchors.top: r.top
        anchors.topMargin: app.fs*3
        //anchors.verticalCenter: r.verticalCenter
        rotation: 25
    }
    Audio{
        id: ap
        source: 'file:./sounds/win.wav'
        autoLoad: true
        autoPlay: true
    }
    Timer{
        running: true
        repeat: false
        interval: 500
        onTriggered: {
            let v=0
            let uw=''
            for(var i=0;i<app.wordsUsed.length;i++){
                if(app.wordsUsedBy[i]===r.u){
                    if(v===0){
                        uw+=app.wordsUsed[i]
                    }else{
                        uw+='|'+app.wordsUsed[i]
                    }
                    v++
                }
            }
            v=0
            let auw=''
            for(var i=0;i<app.wordsUsed.length;i++){
                if(v===0){
                    auw+=app.wordsUsed[i]
                }else{
                    auw+='|'+app.wordsUsed[i]
                }
                v++
            }
            let d=new Date(Date.now())
            let ms=d.getTime()
            let sql='insert into gameswins(nickname, word, userwords, allwords, points, ms)values(\''+r.u+'\', \''+app.cWord+'\', \''+uw+'\', \''+auw+'\', '+r.s+', '+ms+')'
            console.log(sql)
            unik.sqlQuery(sql)

            sql='select id from gameswins where nickname=\''+r.u+'\''
            let rows=unik.getSqlData(sql)
            l5.text='<b>Esta es tu victoria número '+parseInt(rows.length + 1)+'</b>.'
        }
    }
    Component.onCompleted: {

    }
}

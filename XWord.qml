import QtQuick 2.0
import "funcs.js" as JS

Rectangle {
    id: r
    width: parent.width-app.fs//labelCWord.contentWidth+app.fs
    height:x1.crono.timer.running?labelCWord.contentHeight+app.fs:labelData.contentHeight+app.fs
    color: app.c1
    border.width: 2
    border.color: app.c2
    radius: app.fs*0.5
    anchors.horizontalCenter: parent.horizontalCenter
    UText{
        id: labelCWord
        text: '<b>'+app.cWord+'</b>'
        width: r.width-app.fs*0.5
        font.pixelSize: app.fs*3
        wrapMode: Text.WrapAnywhere
        anchors.centerIn: r
    }
    Rectangle{
        anchors.fill: r
        color: app.c1
        border.width: 2
        border.color: app.c2
        radius: app.fs*0.5
        visible: !x1.crono.timer.running
        UText{
            id: labelData
            property string ct: 'Seleccionar palabra'
            text: ct
            font.pixelSize: app.fs*2.5
            width: r.width-app.fs
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
            anchors.centerIn: parent
        }
    }
    MouseArea{
        anchors.fill: r
        onClicked: xShowSig.search(app.cWord, 'app', false)
        onDoubleClicked: {
            app.idGame=''
            app.wordsUsed=[]
            app.wordsUsedBy=[]
            let sql='SELECT * FROM words ORDER BY random() LIMIT 1;'
            let rows=unik.getSqlData(sql)
            //uLogView.showLog('W0:'+rows.length)
            if(rows.length>0){
                app.cWord=rows[0].col[0]
            }
            //uLogView.showLog('W:'+app.cWord)
            let cons=''
            let cv=0
            for(var i=0;i<app.cWord.length;i++){
                if(app.cWord.charAt(i)!=='á'&&app.cWord.charAt(i)!=='é'&&app.cWord.charAt(i)!=='í'&&app.cWord.charAt(i)!=='ó'&&app.cWord.charAt(i)!=='ú'&&app.cWord.charAt(i)!=='a'&&app.cWord.charAt(i)!=='e'&&app.cWord.charAt(i)!=='i'&&app.cWord.charAt(i)!=='o'&&app.cWord.charAt(i)!=='u'){
                    cons+=app.cWord.charAt(i)
                }else{
                    cv++
                }
            }
            labelData.text='Palabra de '+app.cWord.length+' letras consonantes  ['+cons+'] y '+cv+' vocales'
            //xShowSig.search(app.cWord, 'app', false)
        }
    }
}

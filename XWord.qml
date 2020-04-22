import QtQuick 2.0
import "funcs.js" as JS

Rectangle {
    id: r
    width: labelCWord.contentWidth+app.fs
    height:labelCWord.contentHeight+app.fs
    color: app.c1
    border.width: 2
    border.color: app.c2
    radius: app.fs*0.5
    anchors.horizontalCenter: parent.horizontalCenter
    UText{
        id: labelCWord
        text: '<b>'+app.cWord+'</b>'
        font.pixelSize: app.fs*3
        anchors.centerIn: r
    }
    MouseArea{
        anchors.fill: r
        onClicked: xShowSig.search(app.cWord, 'app', false)
        onDoubleClicked: {
            app.wordsUsed=[]
            app.wordsUsedBy=[]
            app.cWord=JS.getWord()
            xShowSig.search(app.cWord, 'app', false)
        }
    }

}

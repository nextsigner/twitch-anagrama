import QtQuick 2.5
import QtQuick.Controls 2.0
import QtMultimedia 5.0
import QtQuick.Particles 2.0
import Qt.labs.settings 1.0
import "funcs.js" as JS

Rectangle {
    id: r
    width: xApp.width*0.5
    height: parent.height
    color: app.c1
//    border.width: 8
//    border.color: 'blue'
    clip: true
    property alias wordList: xL1
    property alias cbe: cbCommandEnabled.checked
    //property alias ti: tiMsg
    property alias crono: xCrono
    Settings{
        id: sX1
        property bool cbCE: false
    }
    Column{
        spacing: app.fs*0.5
        anchors.centerIn: r
        XWord{id: xWord}
        XCrono{
            id: xCrono
            width: r.width
            countDown: true
            anchors.horizontalCenter: parent.horizontalCenter
        }
        XWordsUsed{
            id: xWordUsed
            height: r.height-xWord.height-xCrono.height-app.fs*2-xWV.height
        }
        Row{
            visible:false
            UText{
                text: 'Comando !r'
            }
            CheckBox{
                id: cbCommandEnabled
                onCheckedChanged: sX1.cbCE=checked
            }
        }

//        UTextInput{
//            id: tiMsg
//            label:'Mensage:'
//            width: r.width-app.fs
//            anchors.horizontalCenter: parent.horizontalCenter
//            focus: true
//            textInput.onFocusChanged: {
//                if(textInput.focus){
//                    textInput.selectAll()
//                }
//            }
//            onSeted: {
//                if(text==='')return
//                if(text==='p'){
//                    text=''
//                    if(!x1.crono.timer.running){
//                        x1.wordList.showPoints('Comencemos! ')
//                        x1.crono.timer.running=true
//                    }else{
//                        x1.wordList.showFail('Stop! ')
//                        x1.crono.timer.running=false
//                    }
//                    return
//                }else{
//                    app.sendToChat(text)
//                }
//            }
//            Keys.onReturnPressed: {
//                //uLogView.showLog('Return pressed!')
//                //app.sendToChat(text)
//            }
//        }

    }
    UText{
        text: 'idGame: '+app.idGame
        font.pixelSize: app.fs*0.5
        x: 8
        y:8
        visible: false
    }
    XL1{
        id: xL1
        height: r.height-xWord.height-xCrono.height-app.fs*10
        anchors.top: r.bottom
    }
    Component.onCompleted: {
        cbCommandEnabled.checked=sX1.cbCE
    }

    function agregarPalabra(w, u){
        let m0=w.split(' ')
        let uw=m0[0]
        xL1.list.append(xL1.list.addItem(w, app.cWord, u))
    }
    function inTime(){
        return xCrono.inTime
    }
}

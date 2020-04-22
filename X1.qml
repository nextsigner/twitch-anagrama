import QtQuick 2.5
import QtQuick.Controls 2.0
import QtMultimedia 5.0
import QtQuick.Particles 2.0
import Qt.labs.settings 1.0
import "funcs.js" as JS

Rectangle {
    id: r
    width: parent.width*0.8
    height: parent.height
    color: app.c1
    border.width: 2
    border.color: 'red'
    clip: true
    property alias cbe: cbCommandEnabled.checked
    Settings{
        id: sX1
        property bool cbCE: false
    }
    Column{
        spacing: app.fs*0.5
        anchors.centerIn: r
        XWordsUsed{id: xWordUsed}
        XWord{id: xWord}
        XCrono{
            id: xCrono
            countDown: true
            anchors.horizontalCenter: parent.horizontalCenter
        }
        Row{
            UText{
                text: 'Comando !r'
            }
            CheckBox{
                id: cbCommandEnabled
                onCheckedChanged: sX1.cbCE=checked
            }
        }
        XL1{
            id: xL1
            height: r.height-xWord.height-xCrono.height-app.fs*10
        }
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
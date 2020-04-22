import QtQuick 2.7
import QtQuick.Controls 2.0
import QtWebEngine 1.4
import Qt.labs.settings 1.0
import "funcs.js" as JS

Item {
    id: r
    //visible: false
    width: (xApp.width-x1.width)*0.5
    height: col.height+app.fs*2
    property int h: 0
    property int m: 0
    property int s: 0
    property int ms: 0
    property int hCD: 0
    property int mCD: 0
    property int sCD: 0
    property int msCD: 0
    property bool temp: true
    property bool countDown: false
    property var arrayTime: [0,0,0,0]
    property var arrayTimeCD: [0,0,0]
    property var arrayName: ['Hora', 'Minutos', 'Segundos', 'Milisegundos']
    property var arrayNameCD: ['Minutos', 'Segundos', 'Milisegundos']
    property bool inTime: tTempCountDown.running
    onMChanged: {
        if(!r.countDown){
            if(m===0){
                m=0
                h--
            }
        }
    }
    Settings{
        id: sCrono
        property int minutosCD: 10
    }
    Column{
        id: col
        spacing: app.fs*0.5
        anchors.centerIn: r
        Row{
            height: app.fs*2
            UText{
                id: labelMode
                width: r.width-app.fs
                wrapMode: Text.WordWrap
                font.pixelSize: app.fs
                horizontalAlignment: Text.AlignHCenter
            }
        }
        Row{
            anchors.horizontalCenter: parent.horizontalCenter
            height: colBotsCrono.height
            Column{
                id: colBotsCrono
                width: app.fs*2
                Boton{
                    w:app.fs*2
                    h:w
                    d:'d'
                    t:!tTempCountDown.running?'\uf04b':'\uf04c'
                    c:app.c1
                    b:app.c2
                    onClicking: {
                        if(r.mCD===0&&r.sCD===0){
                                setCountDownInit(sCrono.minutosCD)
                                tTempCountDown.running=true
                        }else{
                            tTempCountDown.running=!tTempCountDown.running
                        }

                    }
                }
                Boton{
                    w:app.fs*2
                    h:w
                    d:'d'
                    t:'\uf04d'
                    c:app.c1
                    b:app.c2
                    onClicking: {
                        tTempCountDown.stop()
                        r.mCD=0
                        r.sCD=0
                        r.msCD=0
                        setArrayTimeCD()
                    }
                }
                Boton{
                    w:app.fs*2
                    h:w
                    d:'d'
                    t:'S'
                    c:app.c1
                    b:app.c2
                    onClicking: {
                            rowSBMinCD.visible=!rowSBMinCD.visible
                    }
                }
            }
            Row{
                anchors.centerIn: r
                Repeater{
                    model: r.countDown?r.arrayTimeCD:r.arrayTime
                    Rectangle{
                        width: app.fs*6
                        height: width
                        border.width: r.inTime?unikSettings.borderWidth*2:unikSettings.borderWidth
                        border.color: r.inTime?'red':app.c2
                        radius: app.fs*0.25
                        color: app.c1
                        UText{
                            text: r.countDown?r.arrayNameCD[index]:r.arrayName[index]
                            font.pixelSize: app.fs*0.6
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.top: parent.top
                            anchors.topMargin: app.fs*0.5
                        }
                        UText{
                            text: r.countDown?r.arrayTimeCD[index]:r.arrayTime[index]
                            font.pixelSize: app.fs*2.5
                            anchors.centerIn: parent
                        }
                    }
                }
            }
        }
        Row{
            id: rowSBMinCD
            spacing: app.fs
            visible: false
            UText{
                text: 'Cantidad de Minutos'
                anchors.verticalCenter: parent.verticalCenter
            }
            SpinBox{
                id: sbMinCD
                from:1
                to:60
                stepSize: 1
                onValueChanged: sCrono.minutosCD=value
            }
        }
    }
    Timer{
        id: tTempCountDown
        running: false
        repeat: true
        interval: 10
        onRunningChanged: {
            if(running){
                app.sendToChat('[Juego dice] Comencemos! ')
            }else{
                app.sendToChat('[Juego dice] Stop! ')
            }
        }
        onTriggered: {
            if(r.msCD===0){
                r.msCD=100
                if(r.sCD===0){
                    if(r.mCD===0&&r.sCD===0){
                        stop()
                        return
                    }
                    r.sCD=59
                    r.mCD--
                    if(r.mCD===0){
                        //r.mCD=59
                        //r.hCD--
                    }
                }else{
                    r.sCD--
                }
            }else{
                r.msCD-=1
            }
            if(!r.countDown){
                setArrayTime()
            }else{
                setArrayTimeCD()
            }
        }
    }
    Component.onCompleted: {
        sbMinCD.value=sCrono.minutosCD
        //setCountDownInit(2)
    }
    function setCountDownInit(m){
        r.sCD=60
        r.mCD=m-1
        let mf=''+m
        if(mf.length===1){
            mf='0'+mf
        }
        labelMode.text=''+mf+' minutos de tiempo\npara enviar palabras.'
        tTempCountDown.start()
    }
    function setArrayTime(){
        let a=[]
        a.push(r.h)
        a.push(r.m)
        a.push(r.s)
        a.push(r.ms)
        r.arrayTime=a
    }
    function setArrayTimeCD(){
        let a=[]
        let hf=''+r.hCD
        if(hf.length===1){
            hf='0'+hf
        }
        let mf=''+r.mCD
        if(mf.length===1){
            mf='0'+mf
        }
        let sf=''+r.sCD
        if(sf.length===1){
            sf='0'+sf
        }
        a.push(mf)
        a.push(sf)
        a.push(r.msCD)
        r.arrayTimeCD=a
        //uLogView.showLog('a: '+a.toString())
    }
}

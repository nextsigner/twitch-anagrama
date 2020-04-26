import QtQuick 2.7
import QtQuick.Controls 2.0
import QtWebEngine 1.4
import Qt.labs.settings 1.0
import "funcs.js" as JS

Item {
    id: r
    //visible: false
    width: parent.width-app.fs
    height: app.fs*6
    property alias timer: tTempCountDown
    property int h: 0
    property int m: 0
    property int s: 0
    property int ms: 0
    property int hCD: 0
    property int mCD: 0
    property int sCD: 0
    property int msCD: 0
    property int fromMCD: 10
    property bool temp: true
    property bool countDown: false
    property var arrayTime: [0,0,0,0]
    property var arrayTimeCD: [0,0]
    property var arrayName: ['Hora', 'Minutos', 'Segundos', 'Milisegundos']
    property var arrayNameCD: ['Minutos', 'Segundos', 'Milisegundos']
    property bool inTime: tTempCountDown.running
    property string cIdGame:''
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
        anchors.centerIn: r
        Row{
            anchors.centerIn: r
            spacing: app.fs*0.25
            Repeater{
                model: r.countDown?r.arrayTimeCD:r.arrayTime
                Rectangle{
                    width: r.width/2-app.fs*0.25
                    height: app.fs*7
                    border.width: r.inTime?6:2
                    border.color: r.inTime?'red':app.c2
                    radius: app.fs*0.25
                    color: app.c1
                    UText{
                        text: r.countDown?r.arrayTimeCD[index]:r.arrayTime[index]
                        font.pixelSize: app.fs*7
                        anchors.centerIn: parent
                    }
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            //uLogView.showLog('-0')
                            if(index===0){
                                //uLogView.showLog('0')
                                if(r.mCD===0&&r.sCD===0){
                                    setCountDownInit(sCrono.minutosCD)
                                    var d1=new Date(Date.now())
                                    let nid=''+d1.getDate()+d1.getMonth()+d1.getFullYear()+d1.getHours()+d1.getMinutes()+d1.getSeconds()+app.cWord
                                    //uLogView.showLog('nid: '+nid)
                                    app.idGame=nid
                                    tTempCountDown.running=true
                                }else{
                                    tTempCountDown.running=!tTempCountDown.running
                                }
                            }
                            if(index===2){
                                app.idGame=0
                                tTempCountDown.stop()
                                r.mCD=0
                                r.sCD=0
                                r.msCD=0
                                setArrayTimeCD()
                            }
                            if(index===1){
                                rowSBMinCD.visible=!rowSBMinCD.visible
                            }
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
        interval: 1000
        onTriggered: {
            //if(r.msCD===0){
                r.msCD=100
                if(r.sCD===0){

                    //Probar con poco tiempo
                    //if(r.mCD===0&&r.sCD<40){
                    if(r.mCD===0&&r.sCD===0){
                        unik.speak('Tiempo finalizado.')
                        xPanelData.showWinner()
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
//            }else{
//                r.msCD-=1
//            }
            if(!r.countDown){
                setArrayTime()
            }else{
//                if(r.mCD===){

//                }
                setArrayTimeCD()
            }
            r.cIdGame=app.idGame
        }
    }
    Component.onCompleted: {
        sbMinCD.value=sCrono.minutosCD
        //setCountDownInit(2)
    }
    function setCountDownInit(m){
        r.fromMCD=m
        r.sCD=60
        r.mCD=m-1
        let mf=''+m
        if(mf.length===1){
            mf='0'+mf
        }
        //labelMode.text=''+mf+' minutos de tiempo\npara enviar palabras.'
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
        //a.push(r.msCD)
        r.arrayTimeCD=a
        //uLogView.showLog('a: '+a.toString())
    }
    function toogleCD(){
        if(r.mCD===0&&r.sCD===0){
            setCountDownInit(sCrono.minutosCD)
            var d1=new Date(Date.now())
            let nid=''+d1.getDate()+d1.getMonth()+d1.getFullYear()+d1.getHours()+d1.getMinutes()+d1.getSeconds()
            //uLogView.showLog('nid: '+nid)
            app.idGame=nid
            tTempCountDown.running=true
            unik.speak('Temporizador iniciado.')
        }else{
            tTempCountDown.running=!tTempCountDown.running
            if(tTempCountDown.running){
                unik.speak('Temporizador iniciado.')
            }else{
                unik.speak('Temporizador detenido.')
            }
        }
    }
}

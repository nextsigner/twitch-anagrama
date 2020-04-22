import QtQuick 2.7
import QtQuick.Controls 2.0
import QtWebEngine 1.4
import QtQuick.Window 2.2
import "funcs.js" as JS
import "qrc:/"
ApplicationWindow {
    id: app
    visible: true
    visibility: "Maximized"
    color: 'black'
    property string moduleName: 'twitchanagrama'
    property int fs: app.width*0.015
    property color c1: 'black'
    property color c2: 'white'
    property color c3: 'gray'
    property color c4: 'red'
    property string uHtml: ''
    property bool voiceEnabled: true
    property string user: ''
    property string url: ''

    //Variables de Juego
    property int maxWordLength: 0
    property string cWord: 'Ninguna'
    property string uSearchWord: 'Ninguna'
    property var wordsUsed: []
    property var wordsUsedBy: []

    FontLoader{name: "FontAwesome"; source: "qrc:/fontawesome-webfont.ttf"}
    USettings{
        id: unikSettings
        url:pws+'/'+app.moduleName
        onCurrentNumColorChanged: setVars()
        Component.onCompleted: {
            setVars()
        }
        function setVars(){
            let m0=defaultColors.split('|')
            let ct=m0[currentNumColor].split('-')
            app.c1=ct[0]
            app.c2=ct[1]
            app.c3=ct[2]
            app.c4=ct[3]
        }
    }
    Item{
        id: xApp
        anchors.fill: parent
        Row{
            XPanelData{id:xPanelData}
            X1{
                id: x1
                width: xApp.width*0.5
            }
            Rectangle{
                width: (xApp.width-x1.width)*0.5
                height: xApp.height
                WebEngineView{
                    id: wv
                    anchors.fill: parent
                    onLoadProgressChanged: {
                        if(loadProgress===100)tCheck.start()
                    }
                }
                XShowSig{
                    id: xShowSig
                    height: parent.height//-app.fs*10
                    onWordIsValidated: {
                        app.sendToChat('[Juego dice] Palabra actual '+word)
                    }
                    Rectangle{
                        anchors.fill: parent
                        border.width: 2
                        border.color: 'red'
                        color: 'transparent'
                    }
                }
            }
        }
        Timer{
            id: ts
            running: false
            repeat: false
            interval: 3000
            onTriggered: {
                wv.runJavaScript('document.getElementsByTagName("textarea")[0].focus()', function(resultFocus) {
                    wv.runJavaScript('document.getElementsByTagName("div").length', function(result) {
                        uLogView.showLog('div: '+result)
                        let d=new Date(Date.now())

                            let ndEnviar=result-7
                            wv.runJavaScript('document.getElementsByTagName("div")['+ndEnviar+'].click()', function(resultEnviar) {
                                uLogView.showLog('div: '+unik.toHtmlEscaped(resultEnviar))
                            });

                        let nd=result-8
                        wv.runJavaScript('document.getElementsByTagName("div")['+nd+'].innerHTML', function(result2) {
                            uLogView.showLog('div: '+unik.toHtmlEscaped(result2))
                        });
                        //                    wv.runJavaScript('document.getElementsByTagName("textarea")[0].click()', function(result2) {
                        //                        uLogView.showLog('textarea: '+result2)
                        //                    });
                        //uLogView.showLog('textarea: '+result)
                    });
                });
            }
        }
        BotonUX{
            text: 'Enviar'
            z: uLogView.z+1
            onClicked: {
                let comp=Qt.createComponent("XE1.qml")
                let obj=comp.createObject(xApp, {y:500, text:'lskdf añsdfas as fasd a fas salfk añ'})
            }
        }
        ULogView{
            id: uLogView
            width: parent.width*0.5
        }
        UWarnings{id: uWarnings}
    }
    Timer{
        id:tCheck
        running: false
        repeat: true
        interval: 250
        onTriggered: {
            wv.runJavaScript('document.getElementById("root").innerText', function(result) {
                if(result!==app.uHtml){
                    let d0=result//.replace(/\n/g, 'XXXXX')
                    if(d0.indexOf(':')>0){
                        let d1=d0.split(':')
                        let d2=d1[d1.length-1]
                        let d3=d2.split('Enviar')
                        let mensaje = d3[0]

                        let d5=d0.split('\n\n')
                        let d6=d5[d5.length-3]
                        let d7=d0.split(':')
                        let d8=d7[d7.length-2].split('\n')
                        let usuario=''+d8[d8.length-1].replace('chat\n', '')
                        let msg=usuario+' dice '+mensaje

                        if((''+msg).indexOf('chat.whatsapp.com')<0&&(''+mensaje).indexOf('!')!==1){
                            //unik.speak(msg)
                        }
                        if(isVM(msg)&&msg.indexOf('[Juego dice]')<0&&msg.indexOf('!r')>=0&&x1.cbe){
                            if(!x1.inTime()){
                                unik.speak(''+usuario+' responde antes de tiempo.')
                                //return
                            }else{
                                let m0=mensaje.split('!r')
                                let m1=m0[1].split(' ')
                                //uLogView.showLog('m1: '+m1.toString())
                                if(m1.length>=1){
                                    let pf=(''+m1[1]).replace(/_/g, '')
                                    if(pf.indexOf('undefined')>=0)return
                                    unik.speak(''+usuario+' responde palabra '+pf)
                                    x1.agregarPalabra(pf, usuario)
                                }
                            }
                        }
                        if(isVM(msg)&&msg.indexOf('[Juego dice]')<0&&!x1.cbe){
                            if(!x1.inTime()){
                                unik.speak(''+usuario+' responde antes de tiempo.')
                                //return
                            }else{
                                let m1=mensaje.split(' ')
                                //uLogView.showLog('m1: '+m1.toString())
                                if(m1.length>=1){
                                    let pf=(''+m1[1]).replace(/_/g, '')
                                    if(pf.indexOf('undefined')>=0)return
                                    unik.speak(''+usuario+' responde palabra '+pf)
                                    x1.agregarPalabra(pf, usuario)
                                }
                            }
                        }
                        /*
                        if(msg.indexOf(''+app.user)>=0 &&msg.indexOf('show')>=0){
                            app.visible=true
                        }
                        if(msg.indexOf(''+app.user)>=0 &&msg.indexOf('show')>=0){
                            app.visible=true
                        }
                        if(msg.in dexOf(''+app.user)>=0 &&msg.indexOf('hide')>=0){
                            app.visible=false
                        }
                        if(msg.indexOf(''+app.user)>=0 &&msg.indexOf('launch')>=0){
                            Qt.openUrlExternally(app.url)
                        }*/
                        //app.flags = Qt.Window | Qt.FramelessWindowHint | Qt.WindowStaysOnTopHint
                        //app.flags = Qt.Window | Qt.FramelessWindowHint
                    }
                }
                app.uHtml=result
                //uLogView.showLog(result)
            });
        }
    }
    Shortcut{
        sequence: 'Esc'
        onActivated: {
            if(uLogView.visible){
                uLogView.visible=false
                return
            }
            Qt.quit()
        }
    }
    Shortcut{
        sequence: 'Up'
        onActivated: {

        }
    }
    Shortcut{
        sequence: 'Down'
        onActivated: {

        }
    }
    Shortcut{
        sequence: 'Right'
        onActivated: {

        }
    }
    Shortcut{
        sequence: 'Left'
        onActivated: {

        }
    }
    Shortcut{
        sequence: 'Space'
        onActivated: {

        }
    }
    Shortcut{
        sequence: 'Ctrl+a'
        onActivated: {

        }
    }
    Shortcut{
        sequence: 'r'
        onActivated: {

        }
    }
    Shortcut{
        sequence: 'Ctrl+c'
        onActivated: {
            if(unikSettings.currentNumColor<16){
                unikSettings.currentNumColor++
            }else{
                unikSettings.currentNumColor=0
            }
        }
    }
    Component.onCompleted: {
        let user=''
        let launch=false
        let args = Qt.application.arguments
        //uLogView.showLog(args)
        for(var i=0;i<args.length;i++){
            //uLogView.showLog(args[i])
            if(args[i].indexOf('-twitchUser=')>=0){
                let d0=args[i].split('-twitchUser=')
                //uLogView.showLog(d0[1])
                user=d0[1]
                app.user=user
                app.url='https://www.twitch.tv/embed/'+user+'/chat'
                //uLogView.showLog('Channel: '+app.url)
            }
            if(args[i].indexOf('-launch')>=0){
                launch=true
            }
        }
        wv.url=app.url
        if(launch){
            Qt.openUrlExternally(app.url)
        }

        //Depurando
        app.visible=true
        //getViewersCount()

        unik.sqliteInit('scores.sqlite')
        let sql='CREATE TABLE IF NOT EXISTS scores'
            +'('
            +'id INTEGER PRIMARY KEY AUTOINCREMENT,'
            +'nickname TEXT NOT NULL,'
            +'score NUMERIC NOT NULL'
            +')'
        unik.sqlQuery(sql)
        sql='CREATE TABLE IF NOT EXISTS hscores'
                +'('
                +'id INTEGER PRIMARY KEY AUTOINCREMENT,'
                +'nickname TEXT NOT NULL,'
                +'palabra TEXT NOT NULL,'
                +'respuesta TEXT NOT NULL,'
                +'ms NUMERIC NOT NULL,'
                +'score NUMERIC NOT NULL'
                +')'
        unik.sqlQuery(sql)

        app.maxWordLength=JS.getWordCount()
        app.cWord=JS.getWord()
    }
    function isVM(m){
        let s1='Nightbot'
        if(m.indexOf(s1)>=0)return false;
        return true
    }
    function sendToChat(msg){
        let s='#include <AutoItConstants.au3>\n'
        +'MouseClick($MOUSE_CLICK_LEFT, 1200, 650, 1)\n'
        +'Sleep(100)\n'
        +'Send("'+msg+'{ENTER}")\n'
        +'Sleep(250)\n'
        +'Send("{ENTER}")\n'
        let d=new Date(Date.now())
        let fn=unik.getPath(4)+'/autoit'+d.getTime()+'.au3'
        unik.setFile(fn, s)
        unik.ejecutarLineaDeComandoAparte("cmd /c \""+fn+"\"")
    }
}


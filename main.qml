import QtQuick 2.7
import QtQuick.Controls 2.0
import QtWebEngine 1.4
import QtQuick.Window 2.2
import "funcs.js" as JS
import "qrc:/"
ApplicationWindow {
    id: app
    visible: true
    //visibility: "Maximized"
    flags: Qt.FramelessWindowHint
    width: 1280+840
    height: 720
    x:0
    y:0
    color: 'black'
    property string moduleName: 'twitchanagrama'
    property int fs: xApp.width*0.015
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
    property string idGame: '*'

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
        width: 1280
        height: app.height
        Row{
            XPanelData{
                id:xPanelData
                width: xApp.width*0.75
                visible: app.idGame!==''
            }
            XPanelPrev{
                id:xPanelPrev
                width: xApp.width*0.75
                visible: app.idGame===''
            }
            X1{
                id: x1
                width: xApp.width*0.25
            }
        }
        Rectangle{
            id: xWV
            width: 840
            height: xApp.height
            x:1280
            //            state: 'show'
            //            states: [
            //                State {
            //                    name: "show"
            //                    PropertyChanges {
            //                        target: xWV
            //                        x: xApp.width-xWV.width
            //                    }
            //                },
            //                State {
            //                    name: "hide"
            //                    PropertyChanges {
            //                        target: xWV
            //                        x: xApp.width
            //                    }
            //                }
            //            ]
            Behavior on x{
                NumberAnimation{duration: 250;easing.type: Easing.InOutQuad}
            }
            WebEngineView{
                id: wv
                anchors.fill: parent
                onLoadProgressChanged: {
                    if(loadProgress===100)tCheck.start()
                }
                onJavaScriptDialogRequested: {
                    if((''+wv.url).indexOf('twitch.tv')<0&&(''+wv.url).indexOf('/chat')<0)return
                    autoItRequest('Send("{ENTER}")\n')
                }
            }
            XShowSig{
                id: xShowSig
                height: parent.height//-app.fs*10
                onWordIsValidated: {
                    //app.sendToChat('[Juego dice] Palabra actual '+word)
                }
                Rectangle{
                    anchors.fill: parent
                    border.width: 2
                    border.color: 'red'
                    color: 'transparent'
                }
            }
            Timer{
                id: tSetTiEnabled
                running: true
                repeat: true
                interval: 3000
                onTriggered: {
                    wv.runJavaScript('document.getElementById("root").innerText', function(result) {
                        if(result.indexOf('CHAT DE LA TRANSMISIÓN')>=0){
                            sendToChat('Juego conectado al Chat')
                            stop()
                        }
                    });
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
        //        BotonUX{
        //            text: 'Enviar'
        //            z: uLogView.z+1
        //            onClicked: {
        //                sendToChat('Probando')
        //            }
        //        }
        ULogView{
            id: uLogView
            width: parent.width*0.5
        }
        UWarnings{id: uWarnings}
    }
    Rectangle{
        width: 1280
        height: 720
        color: 'transparent'
        border.width: 2
        border.color: 'red'
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
                        //                        if(msg.indexOf('Config.')>=0){
                        //                            return
                        //                        }

                        if(!isVM(usuario)){
                            app.uHtml=result
                            return
                        }
                        if(usuario.indexOf('nextsigner')===0&&mensaje.indexOf('!t')>=0){
                            x1.crono.toogleCD()
                            app.uHtml=result
                            return
                        }
                        //                        if(usuario.indexOf('nextsigner')===0&&mensaje.indexOf('!ts')>=0){
                        //                            x1.crono.timer.stop()
                        //                            unik.speak('Temporizador detenido.')
                        //                            app.uHtml=result
                        //                            return
                        //                        }
                        if(msg.indexOf('Juego conectado al Chat')>=0){
                            //xWV.state='hide'
                            unik.speak('Chat iniciado.')
                            app.uHtml=result
                            return
                        }
                        if(isVM(msg)&&msg.indexOf('!r')>=0&&x1.cbe){
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
                        if(isVM(msg)&&!x1.cbe){
                            if(!x1.inTime()){
                                unik.speak(msg)
                                app.uHtml=result
                                return
                                //unik.speak(''+usuario+' responde antes de tiempo.')
                                //return
                            }else{
                                let m1=mensaje.split(' ')
                                //uLogView.showLog('m1: '+m1.toString())
                                if(m1.length>=1){
                                    let pf=(''+m1[1]).replace(/_/g, '').replace(/ /g, '').replace(/\n/g, '').replace(/ \r/g, '')
                                    //uLogView.showLog('pf:['+pf+']['+app.cWord+']')
                                    if(pf===app.cWord){
                                        let fmsg='Mal intento de '+usuario+'!\nLa palabra '+pf+' no es válida.'
                                        x1.wordList.showFail(fmsg)
                                        app.uHtml=result
                                        return
                                    }
                                    if(pf.indexOf('undefined')>=0)return
                                    //unik.speak(''+usuario+' responde palabra '+pf)
                                    if(x1.wordList.isLetterWordValid(pf)){
                                        x1.agregarPalabra(pf, usuario)
                                    }else{
                                        let d=new Date(Date.now())
                                        let sql='insert into hscores(nickname, palabra, respuesta, game, ms, score)values(\''+usuario+'\',\''+pf+'\',\''+app.cWord+'\',\''+app.idGame+'\', '+d.getTime()+', -1)'
                                        unik.sqlQuery(sql)
                                        let m=''+usuario+' ha fallado!'
                                        x1.wordList.showFail(m)
                                        xPanelData.timer.restart()
                                        xPanelData.upDateData()
                                    }
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
                            app.visible=falseJuego conectado al Chat

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
            //            if(x1.ti.textInput.focus){
            //                xApp.focus=true
            //                return
            //            }
            if(wv.focus){
                xApp.focus=true
                return
            }
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
        sequence: 'w'
        onActivated: {
            //xWV.state=xWV.state==='show'?'hide':'show'
            //if(xWV.state==='hide')x1.ti.focus=true
            //if(xWV.state==='show')wv.focus=true
        }
    }
    Shortcut{
        sequence: 'p'
        onActivated: {
            //x1.crono.timer.running=!x1.crono.timer.running
            //if(xWV.state==='hide')x1.ti.focus=true
            //if(xWV.state==='show')wv.focus=true
        }
    }
    Shortcut{
        sequence: 'i'
        onActivated: {
            //x1.ti.focus=true
        }
    }
    Shortcut{
        sequence: 'r'
        onActivated: {
            app.wordsUsed.push(JS.getWord())
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
        app.idGame=''

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

        unik.sqliteInit('anagrama2.sqlite')
        let sql='CREATE TABLE IF NOT EXISTS scores'
            +'('
            +'id INTEGER PRIMARY KEY AUTOINCREMENT,'
            +'nickname TEXT NOT NULL,'
            +'game TEXT NOT NULL,'
            +'ms NUMERIC NOT NULL,'
            +'score NUMERIC NOT NULL'
            +')'
        unik.sqlQuery(sql)
        sql='CREATE TABLE IF NOT EXISTS hscores'
                +'('
                +'id INTEGER PRIMARY KEY AUTOINCREMENT,'
                +'nickname TEXT NOT NULL,'
                +'palabra TEXT NOT NULL,'
                +'respuesta TEXT NOT NULL,'
                +'game TEXT NOT NULL,'
                +'ms NUMERIC NOT NULL,'
                +'score NUMERIC NOT NULL'
                +')'
        unik.sqlQuery(sql)
        sql='CREATE TABLE IF NOT EXISTS games'
                +'('
                +'id INTEGER PRIMARY KEY AUTOINCREMENT,'
                +'nickname TEXT NOT NULL,'
                +'game TEXT NOT NULL,'
                +'points NUMERIC NOT NULL'
                +')'
        unik.sqlQuery(sql)
        sql='CREATE TABLE IF NOT EXISTS gameswins'
                +'('
                +'id INTEGER PRIMARY KEY AUTOINCREMENT,'
                +'nickname TEXT NOT NULL,'
                +'word TEXT NOT NULL,'
                +'userwords TEXT NOT NULL,'
                +'allwords TEXT NOT NULL,'
                +'points NUMERIC NOT NULL,'
                +'ms NUMERIC NOT NULL'
                +')'
        unik.sqlQuery(sql)

        app.maxWordLength=JS.getWordCount()
        app.cWord='algarabía'
        //app.cWord=JS.getWord()
    }
    function isVM(m){
        let s1='Nightbot'
        if(m.indexOf(s1)>=0)return false;
        let s2='StreamElements'
        if(m.indexOf(s2)>=0)return false;
        let s3='[Juego dice]'
        if(m.indexOf(s3)>=0)return false;
        return true
    }
    function autoItRequest(c){
        let s='#include <AutoItConstants.au3>\n'
            +c+'\n'
        let d=new Date(Date.now())
        let fn=unik.getPath(4)+'/autoit'+d.getTime()+'.au3'
        unik.setFile(fn, s)
        unik.ejecutarLineaDeComandoAparte("cmd /c \""+fn+"\"")
    }

    function sendToChat(msg){
        clipboard.setText(msg)
        let posx=xApp.width+100
        //        if(xWV.state==='hide'){
        //            posx=1280
        //        }
        //let posxR=x1.x+x1.ti.x+x1.ti.width-app.fs
        //let posyR=x1.ti.y+x1.ti.parent.y+x1.ti.height//*0.5+app.fs
        wv.focus=true
        let s='#include <AutoItConstants.au3>\n'
            +'MouseClick($MOUSE_CLICK_LEFT, '+posx+', 650, 1)\n'
            +'Sleep(100)\n'
            +'Send("{RCTRL down}v{RCTRL up}{ENTER}")\n'
        //+'Send("{RCTRL up}")\n'
            +'Sleep(500)\n'
        // +'Send("{ENTER}")\n'
        //+'Send("{RCTRL up}")\n'
        //+'Send("{LCTRL up}")\n'
        //+'Sleep(100)\n'
        //+'MouseClick($MOUSE_CLICK_LEFT, '+posxR+', '+posyR+', 1)\n'
        //+'Send("{RCTRL down}a{RCTRL up}")\n'
        //+'Send("{SHIFT}")\n'
        let d=new Date(Date.now())
        let fn=unik.getPath(4)+'/autoit'+d.getTime()+'.au3'
        unik.setFile(fn, s)
        unik.ejecutarLineaDeComandoAparte("cmd /c \""+fn+"\"")
    }
}


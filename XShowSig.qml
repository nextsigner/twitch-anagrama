import QtQuick 2.7
import QtQuick.Controls 2.0
import QtWebEngine 1.4
import "funcs.js" as JS

Item {
    id: r
    visible: false
    width: (xApp.width-x1.width)*0.5
    height: xApp.height
    signal wordIsValidated(string word, string user)
    signal wordIsNotValidated(string word, string user)
    signal proccessing()
    WebEngineView{
        id: wvSearch
        anchors.fill: parent
        property string w: '?'
        property string u: '?'
        property string uw: '?'
        property bool fromList: false
        onLoadProgressChanged: {
            if(loadProgress!==100){
                proccessing()
            }
            if(loadProgress===100){
                if(!fromList){
                    r.visible=true
                }
                if(uw===w)return
                //tCheckIfWordExist.start()
                wvSearch.runJavaScript('document.getElementById("resultados").innerText', function(result) {
                    //uLogView.showLog('R:'+fromList+'-result: '+result)
                    if(uw===w)return
                    let s1='Aviso: La palabra '+w+' no está en el Diccionario.'
                    let s2='Aviso: La palabra'
                    let s3='no está en el Diccionario.'

                    if(result.indexOf(s2)>=0&&result.indexOf(s3)>=0){
                        if(fromList){
                            uw=w
                            let msg=u+''+w+' no existe!'
                            let d=new Date(Date.now())
                            let sql='insert into hscores(nickname, palabra, respuesta, game, ms, score)values(\''+u+'\',\''+w+'\',\''+app.cWord+'\',\''+app.idGame+'\', '+d.getTime()+', -2)'
                            unik.sqlQuery(sql)
                            x1.wordList.showFail(msg)
                            wordIsNotValidated(w, u)
                            return
                        }
                        //unik.speak('Error: '+s1)
                        if(u==='app'){
                            //uLogView.showLog('App falla al seleccionar palabra no válida '+w)
                            unik.speak('Atención! La palabra actual no esta en el diccionario RAE.')
                            uw=w
                            return
                        }
                        let d=new Date(Date.now())
                        let sql='insert into hscores(nickname, palabra, respuesta, game, ms, score)values(\''+u+'\',\''+w+'\',\''+app.cWord+'\',\''+app.idGame+'\', '+d.getTime()+', -1)'
                        unik.sqlQuery(sql)
                        let m=''+u+' ha fallado!'
                        x1.wordList.showFail(m)
                        xPanelData.timer.restart()
                        xPanelData.upDateData()
                    }else{
                        if(fromList){
                            uw=w
                            wordIsValidated(w, u)
                        }else{
                            unik.speak('La palabra actual es válida según el diccionario RAE')
                        }
                    }
                    uw=w
                });
            }
        }
    }
    Boton{
        w:app.fs*2
        h:w
        d:'d'
        t:'X'
        c:app.c1
        b:app.c2
        onClicking: {
            r.visible=false
        }
    }
    function search(w, u, fromList){
        wvSearch.fromList=fromList
        wvSearch.uw=''
        wvSearch.w=w
        wvSearch.u=u
        let d=new Date(Date.now())
        let wcorr1=(''+w).replace(/ /g, '')
        let abc=['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'ñ', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z', 'á', 'é', 'í', 'ó', 'ú']
        let wcorr2=''
        for(var i=0;i<wcorr1.length;i++){
            if(abc.indexOf(wcorr1[i])>=0){
                wcorr2+=wcorr1[i]
            }
        }
        let url='https://dle.rae.es/'+wcorr2+'?m=form&r='+d.getTime()
        //uLogView.showLog('url:['+url+']')
        wvSearch.url=url
    }
    //    function isWordValid(){
    //        app.uSearchWord=w
    //        //JS.getHtmlSearchWord(w, wvSearch)
    //    }
    //    function showSig(w){
    //       //uLogView.showLog('HTML: '+JS.getHtmlSearchWord(w, procHtml))
    //        // wvSearch.loadHtml(JS.getHtmlSearchWord(w))
    //    }
}

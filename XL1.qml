import QtQuick 2.0
import "funcs.js" as JS

Item {
    id: r
    width: x1.width-app.fs
    anchors.horizontalCenter: parent.horizontalCenter
    property alias list: lm
    ListView{
        id: lv
        width: r.width
        height: r.height
        model: lm
        delegate: rowList
        spacing: app.fs*0.25
        Rectangle{
            anchors.fill: parent
            color: 'transparent'
            border.width: 2
            border.color: app.c2
        }
        ListModel{
            id: lm
            onCountChanged: {
                if(count>0){
                    tcheckIsValid.start()
                }
            }
            function addItem(w, cw, u){
                return {
                    word: w,
                    currentWord: cw,
                    user: u
                }
            }
        }
    }
    Component{
        id: rowList
        Rectangle{
            width: r.width
            height: info.contentHeight+app.fs
            color: app.c1
            border.width: 2
            border.color:app.c2
            UText{
                id: info
                text: '<b>Usuario: </b>'+user+' <b>Palabra Actual: </b>'+currentWord+' <b>Envió: </b>'+word
                width: r.width-app.fs
                wrapMode: Text.WordWrap
                anchors.centerIn: parent
            }
        }
    }
    XShowSig{
        id: xShowSigList
        width: r.width*0.5
        height: r.height
        visible: false
        onWordIsValidated: {
            wordProccess(word, user)
            lm.remove(0)
            tcheckIsValid.start()
        }
        onWordIsNotValidated: {
            unik.speak('Palabra '+word+'de  '+user+' rechazada.')
            lm.remove(0)
            tcheckIsValid.start()
        }
        onProccessing: tcheckIsValid.restart()
        Rectangle{
            anchors.fill: parent
            border.width: 2
            border.color: 'red'
            color: 'transparent'
        }
    }  
    Timer{
        id: tcheckIsValid
        running: false
        repeat: true
        interval: 2000
        onTriggered: {
            if(lm.get(0)){
                xShowSigList.search(lm.get(0).word, lm.get(0).user, true)
            }
        }
    }

    function isLetterWordValid(w, u){
        //unik.speak('Procesando '+w)
        let wcorr1=(''+w).replace(/ /g, '').replace(/\n/g, '').toLowerCase()
        var i=0
        var cwSA=app.cWord.toLowerCase().replace(/á/g, 'a').replace(/é/g, 'e').replace(/í/g, 'i').replace(/ó/g, 'o').replace(/u/g, 'ú')
        //uLogView.showLog('cwSA:['+cwSA+'] wcorr1:['+wcorr1+']')
        //uLogView.showLog('cant: '+JS.contarCaracteres(wcorr1, wcorr1.charAt(1)))
        let cwCA=false
        for(i=0;i<wcorr1.length;i++){
            //uLogView.showLog('l'+i+': '+wcorr1.charAt(i))
            if(app.cWord.indexOf(wcorr1.charAt(i))<0&&cwSA.indexOf(wcorr1.charAt(i))<0){
                //unik.speak('Letra '+wcorr1.charAt(i)+' inexistente '+w+' palabra actual '+app.cWord)
                return false
            }
        }
        for(i=0;i<app.cWord.length;i++){
            if(app.cWord.charAt(i)==='í'){
                cwCA=true
                break
            }
        }
        for(i=0;i<wcorr1.length;i++){
            let clu=JS.contarCaracteres(wcorr1, wcorr1.charAt(i))
            let clapp
            if(cwCA){
                clapp=JS.contarCaracteres(cwSA, wcorr1.charAt(i))
            }else{
                clapp=JS.contarCaracteres(app.cWord, wcorr1.charAt(i))
            }
            if(clu>clapp){
                //unik.speak('Usuario '+u+' se ha excedido de letras '+wcorr1.charAt(i))
                return false
            }
        }
        return true
    }
    function wordProccess(w, u){
        //unik.speak('Procesando '+w)
        let wcorr1=(''+w).replace(/ /g, '').replace(/\n/g, '')
        /*var i=0
        //uLogView.showLog('cant: '+JS.contarCaracteres(wcorr1, wcorr1.charAt(1)))
        for(i=0;i<wcorr1.length;i++){
            //uLogView.showLog('l'+i+': '+wcorr1.charAt(i))
            if(app.cWord.indexOf(wcorr1.charAt(i))<0){
                unik.speak('Letra '+wcorr1.charAt(i)+' inexistente '+w+' palabra actual '+app.cWord)
                return
            }
        }
        for(i=0;i<wcorr1.length;i++){
            let clu=JS.contarCaracteres(wcorr1, wcorr1.charAt(i))
            let clapp=JS.contarCaracteres(app.cWord, wcorr1.charAt(i))
            if(clu>clapp){
                unik.speak('Usuario '+u+' se ha excedido de letras '+wcorr1.charAt(i))
                return
            }
        }*/
        //uLogView.showLog('Calculando '+wcorr1.length+' de  '+app.cWord.length+' es igual a '+calcularPuntos(wcorr1))
        //unik.speak('Calculando '+wcorr1.length+' de  '+app.cWord.length+' es igual a '+calcularPuntos(wcorr1))
        //unik.speak('Palabra '+w+'de  '+u+' aceptada.')
        let point=parseFloat(calcularPuntos(wcorr1)).toFixed(2)
        let msg='<b>'+u+'</b> ha sumado <b>'+point+'</b> puntos!'
        showPoints(msg)
        registrarScore(u, wcorr1, app.cWord, point)
    }
    function calcularPuntos(w){
        let porc=parseFloat(parseFloat( w.length / app.cWord.length) * 100)
        return porc*w.length
    }
    function registrarScore(u, w, cw, score){
        let d=new Date(Date.now())
        if(app.wordsUsed.indexOf(w)>=0){
            let msg=''
            if(u===app.wordsUsedBy[app.wordsUsed.indexOf(w)]){
                msg='Ya habías enviado esta la palabra <b>'+w+'!</b>'
            }else{
                msg='La palabra '+w+' ya la ganó <b>'+app.wordsUsedBy[app.wordsUsed.indexOf(w)]+'</b>!'
            }
            showFail(msg)
            return
        }
        app.wordsUsedBy.push(u)
        app.wordsUsed.push(w)
        let sql='select * from scores where nickname=\''+u+'\''
        let rows=unik.getSqlData(sql)
        let rec=0.00
        if(rows.length>0){
            let va=parseInt(rows[0].col[2])
            //uLogView.showLog('va: '+va)
            let cv=parseInt(score+va)
            //rec=score
            //uLogView.showLog('cv: '+cv)
            sql='update scores set score='+cv+' where nickname=\''+u+'\''
            unik.sqlQuery(sql)
        }else{
            sql='insert into scores(nickname, game, ms, score)values(\''+u+'\',\''+app.idGame+'\', '+d.getTime()+', '+parseFloat(score).toFixed(2)+')'
            unik.sqlQuery(sql)
        }
        rec=parseFloat(score).toFixed(2)
        sql='insert into hscores(nickname, palabra, respuesta, game, ms, score)values(\''+u+'\',\''+w+'\',\''+cw+'\',\''+app.idGame+'\', '+d.getTime()+', '+rec+')'
        unik.sqlQuery(sql)

        //Sumar puntos de juego
        sql='select * from hscores where nickname=\''+u+'\' and game=\''+app.idGame+'\''
        rows=unik.getSqlData(sql)
        rec=0.00
        if(rows.length>0){
            for(let i=0;i<rows.length;i++){
               rec=parseFloat(rec+parseFloat(rows[i].col[6]))
            }
            //uLogView.showLog('rec: '+rec)
            sql='insert into games(nickname, game, points)values(\''+u+'\',\''+app.idGame+'\', '+rec+')'
            //uLogView.showLog('sql: '+sql)
            //console.log(sql)
            unik.sqlQuery(sql)
        }
        xPanelData.timer.restart()
        xPanelData.upDateData()
    }
    function showFail(w){
        let comp=Qt.createComponent("XE1.qml")
        let obj=comp.createObject(xApp, {y:xApp.height, text:w})
    }
    function showPoints(w){
        let comp=Qt.createComponent("XA1.qml")
        let obj=comp.createObject(xApp, {y:xApp.height, text:w})
    }
}

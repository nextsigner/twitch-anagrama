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
    Component.onCompleted: {
        //            lm.append(lm.addItem('aaadsafas a fa', 'aaaa da fasfasd fas as ccccc'))
        //            lm.append(lm.addItem('aaaa', 'aaaaccccc'))
        //            lm.append(lm.addItem('aaaa', 'aaaaccccc'))
        //            lm.append(lm.addItem('aaaa', 'aaaaccccc'))
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
    function wordProccess(w, u){
        //unik.speak('Procesando '+w)
        let wcorr1=(''+w).replace(/ /g, '').replace(/\n/g, '')
        var i=0
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
        }
        //uLogView.showLog('Calculando '+wcorr1.length+' de  '+app.cWord.length+' es igual a '+calcularPuntos(wcorr1))
        //unik.speak('Calculando '+wcorr1.length+' de  '+app.cWord.length+' es igual a '+calcularPuntos(wcorr1))
        unik.speak('Palabra '+w+'de  '+u+' aceptada.')
        registrarScore(u, wcorr1, app.cWord, calcularPuntos(wcorr1))
    }
    function calcularPuntos(w){
        let porc=parseFloat(parseFloat( w.length / app.cWord.length) * 100)
        return porc*w.length
    }
    function registrarScore(u, w, cw, score){
        if(app.wordsUsed.indexOf(w)>=0){
            unik.speak('Esta palabra ya está utilizada por '+app.wordsUsedBy[app.wordsUsed.indexOf(w)])
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
            sql='insert into scores(nickname, score)values(\''+u+'\', '+parseFloat(score).toFixed(2)+')'
            unik.sqlQuery(sql)
        }
        rec=parseFloat(score).toFixed(2)
        let d=new Date(Date.now())
        sql='insert into hscores(nickname, palabra, respuesta, ms, score)values(\''+u+'\',\''+w+'\',\''+cw+'\', '+d.getTime()+', '+rec+')'
        unik.sqlQuery(sql)
    }
}
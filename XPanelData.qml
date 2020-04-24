import QtQuick 2.0

Rectangle{
    id: r
    width: xApp.width*0.5
    height: xApp.height
    color: app.c1
    Column{
        spacing: app.fs
        anchors.horizontalCenter: r.horizontalCenter
        anchors.top: r.top
        anchors.topMargin: app.fs
        //anchors.centerIn: r
        Rectangle{
            id: xScoreTopFive
            width: r.width-app.fs
            height: colHS.height+app.fs
            color: app.c3
            Column{
                id: colHS
                spacing: app.fs*0.25
                anchors.centerIn: parent

//                Rectangle{
//                    width: xScoreTopFive.width-app.fs
//                    height: app.fs*1.2
//                    color: app.c2
//                    border.width: 1
//                    border.color: app.c2
//                    UText{
//                        text:  '<b>Los mejores</b>'
//                        font.pixelSize: app.fs
//                        color: app.c1
//                        anchors.centerIn: parent
//                    }
//                }
//                Repeater{
//                    id: repHS
//                    model: []
//                    Rectangle{
//                        width: xScoreTopFive.width-app.fs
//                        height: app.fs*1.4
//                        border.width: 2
//                        border.color: app.c2
//                        radius: app.fs*0.25
//                        color: app.c1
//                        UText{
//                            text:  '<b>'+parseInt(index + 1)+'</b>:'+modelData+' '+r.a2[index]+' pts.'
//                            anchors.centerIn: parent
//                        }
//                    }
//                }



                Rectangle{
                    width: xScoreTopFive.width-app.fs
                    height: app.fs*2.3
                    color: app.c2
                    border.width: 1
                    border.color: app.c2
                    UText{
                        text:  'Juego con Palabra <b>"'+app.cWord+'"</b>'
                        font.pixelSize: app.fs*2
                        color: app.c1
                        anchors.centerIn: parent
                    }
                }
                Repeater{
                    id: repGame
                    model: []
                    Rectangle{
                        width: xScoreTopFive.width-app.fs
                        height: txtUG.contentHeight+app.fs*0.5
                        border.width: 2
                        border.color: app.c2
                        radius: app.fs*0.25
                        color: app.c1
                        UText{
                            id: txtUG
                            text:  modelData
                            font.pixelSize: app.fs*2
                            width: parent.width-app.fs
                            wrapMode: Text.WordWrap
                            horizontalAlignment: Text.AlignHCenter
                            anchors.centerIn: parent
                        }
                    }
                }
                Rectangle{
                    width: xScoreTopFive.width-app.fs
                    height: app.fs*2.3
                    color: app.c2
                    border.width: 1
                    border.color: app.c2
                    UText{
                        text:  '<b>Últimas Palabras ingresadas</b>'
                        font.pixelSize: app.fs*2
                        color: app.c1
                        anchors.centerIn: parent
                    }
                }
                Repeater{
                    id: repUP
                    model: []
                    Rectangle{
                        width: xScoreTopFive.width-app.fs
                        height: txtUP.contentHeight+app.fs*0.5
                        border.width: 2
                        border.color: app.c2
                        radius: app.fs*0.25
                        color: (''+modelData).indexOf('-1pts')>=0?'red':'green'
                        UText{
                            id: txtUP
                            text:  (''+modelData).indexOf('-1pts')<0?modelData:(''+modelData).replace('-1pts', 'palabra no válida.')
                            font.pixelSize: app.fs*2
                            width: parent.width-app.fs
                            wrapMode: Text.WordWrap
                            horizontalAlignment: Text.AlignHCenter
                            anchors.centerIn: parent
                        }
                    }
                }
            }
        }

//        UText{
//            id: labelHScore
//            width: r.width-app.fs
//            wrapMode: Text.WordWrap
//            font.pixelSize: app.fs*0.5
//            //text:  '<b>'+parseInt(index + 1)+'</b>:'+modelData+' '+r.a2[index]+' pts.'
//            //anchors.centerIn: parent
//        }
//        UText{
//            width: r.width*0.8
//            height: contentHeight
//            text: 'Si envías por el chat el comando "!r palabra" (escribe signo de exclamación y la letra "r" luego una palabra), de este modo podrás incluir tu anagrama en la lista de puntos. \n\nTambién puedes enviar audios de Whatsapp, para saber cómo funciona este juego. Envía !wsp en el chat y obtendrás un enlace al grupo del canal para recibir una explicación o ayuda.\n\nMi Whatsapp es +54 11 3802 4370'
//            font.pixelSize: app.fs*0.7
//            wrapMode: Text.WordWrap
//            anchors.horizontalCenter: parent.horizontalCenter
//        }

    }

    Timer{
        running: true
        repeat: true
        interval: 2000
        onTriggered: {
//            let sql='select * from scores order by score desc limit 5;'
//            let rows=unik.getSqlData(sql)
//            let a1=[]
//            let a2=[]
//            for(let i=0;i<rows.length;i++){
//                if(i===0){
//                    //x1.winScore=rows[i].col[2]
//                }
//                if(i===4){
//                    //x1.winLastScore=rows[i].col[2]
//                }
//                a1.push(rows[i].col[1])
//                a2.push(rows[i].col[4])
//            }
//            r.a1=a1
//            r.a2=a2
//            repHS.model=a1

            let sql='select * from hscores order by score desc limit 1;'
            let rows=unik.getSqlData(sql)
            //uLogView.showLog('rows: '+rows.length)
            if(rows.length>0){
                let u=rows[0].col[1]
                let p=rows[0].col[2]
                let r=rows[0].col[3]
                let f=rows[0].col[4]
                let s=rows[0].col[5]
                let d=new Date(parseInt(f))
                let h=''+d.getHours()
                if(h.length===1){
                    h='0'+h
                }
                let m=''+d.getMinutes()
                if(m.length===1){
                    m='0'+m
                }
                let sec=''+d.getSeconds()
                if(sec.length===1){
                    sec='0'+sec
                }
                let dia=''+d.getDate()
                if(dia.length===1){
                    dia='0'+dia
                }
                let mes=''+d.getMonth()+1
                if(mes.length===1){
                    mes='0'+mes
                }
                let anio=d.getFullYear()
                let fecha=' el día '+dia+'/'+mes+'/'+anio+' a las '+h+':'+m+':'+s+' GMT -3'
                //labelHScore.text='<b>Record: </b> El usuario '+u+' obtuvo '+s+' puntos con la palabra '+r+' y obtenida de la palabra '+p+' '+fecha
            }

            //Puntajes de Juego Actual
            //sql='select * from games where game=\''+app.idGame+'\' order by points desc limit 5;'
            sql='SELECT DISTINCT nickname, points from games WHERE game=\''+app.idGame+'\' ORDER by points DESC'
            rows=unik.getSqlData(sql)
            let ag=[]
            let uag=[]
            for(let i=0;i<rows.length;i++){
                if(uag.indexOf(rows[i].col[0])<0){
                    let cadg='<b>'+rows[i].col[0]+'</b> '+parseInt(rows[i].col[1])+'pts'
                    ag.push(cadg)
                    uag.push(rows[i].col[0])
                }
            }
            //console.log('::::::::::::::::::::::::::::ag:'+ag.toString())
            repGame.model=ag

            //Ultimas palabras
            sql='select * from hscores where game=\''+app.idGame+'\' order by ms desc limit 10;'
            rows=unik.getSqlData(sql)
            let aup=[]
            for(let i=0;i<rows.length;i++){
                let cad='<b>'+rows[i].col[1]+'</b> sumó '+rows[i].col[6]+'pts con la palabra <b>"'+rows[i].col[2]+'"</b> en <b>"'+rows[i].col[3]+'"</b>'
                aup.push(cad)
            }
            repUP.model=aup
        }
    }
    property var objData: ({})
    property var a1: []
    property var a2: []
    //    Component.onCompleted: {

    //    }
}

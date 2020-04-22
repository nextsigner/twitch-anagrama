import QtQuick 2.0

Rectangle{
    id: r
    width: (xApp.width-x1.width)*0.5
    height: xApp.height
    color: app.c1
    Column{
        spacing: app.fs
        anchors.centerIn: r
        Rectangle{
            id: xScoreTopFive
            width: r.width-app.fs
            height: colHS.height+app.fs
            color: app.c3
            Column{
                id: colHS
                spacing: app.fs*0.25
                anchors.centerIn: parent
                Rectangle{
                    width: xScoreTopFive.width-app.fs
                    height: app.fs*3
                    color: app.c2
                    border.width: 1
                    border.color: app.c2
                    UText{
                        text:  '<b>Top Five Records</b>'
                        font.pixelSize: app.fs*1.5
                        color: app.c1
                        anchors.centerIn: parent
                    }
                }
                Repeater{
                    id: repHS
                    model: []
                    Rectangle{
                        width: xScoreTopFive.width-app.fs
                        height: app.fs*2
                        border.width: 2
                        border.color: app.c2
                        radius: app.fs*0.5
                        color: app.c1
                        UText{
                            text:  '<b>'+parseInt(index + 1)+'</b>:'+modelData+' '+r.a2[index]+' pts.'
                            anchors.centerIn: parent
                        }
                    }
                }
            }
        }
        UText{
            id: labelHScore
            width: r.width-app.fs
            wrapMode: Text.WordWrap
            //text:  '<b>'+parseInt(index + 1)+'</b>:'+modelData+' '+r.a2[index]+' pts.'
            //anchors.centerIn: parent
        }
        UText{
            width: r.width*0.8
            height: contentHeight
            text: 'Si envías por el chat el comando "!r palabra" (escribe signo de exclamación y la letra "r" luego una palabra), de este modo podrás incluir tu anagrama en la lista de puntos. \n\nTambién puedes enviar audios de Whatsapp, para saber cómo funciona este juego. Envía !wsp en el chat y obtendrás un enlace al grupo del canal para recibir una explicación o ayuda.\n\nMi Whatsapp es +54 11 3802 4370'
            font.pixelSize: app.fs*0.7
            wrapMode: Text.WordWrap
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }

    Timer{
        running: true
        repeat: true
        interval: 2000
        onTriggered: {
            let sql='select * from scores order by score desc limit 5;'
            let rows=unik.getSqlData(sql)
            let a1=[]
            let a2=[]
            for(let i=0;i<rows.length;i++){
                if(i===0){
                    //x1.winScore=rows[i].col[2]
                }
                if(i===4){
                    //x1.winLastScore=rows[i].col[2]
                }
                a1.push(rows[i].col[1])
                a2.push(rows[i].col[2])
            }
            r.a1=a1
            r.a2=a2
            repHS.model=a1

            sql='select * from hscores order by score desc limit 1;'
            rows=unik.getSqlData(sql)
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
                labelHScore.text='<b>Record: </b> El usuario '+u+' obtuvo '+s+' puntos con la palabra '+r+' y obtenida de la palabra '+p+' '+fecha
            }
        }
    }
    property var objData: ({})
    property var a1: []
    property var a2: []
    Component.onCompleted: {
        for(let i=0;i<5;i++){
            r.a1.push('Nadie')
            r.a2.push(0)
            //r.objData['nn'+parseint(i+1)]='Nadie'
            //r.objData['pts'+parseint(i+1)]=0
        }
        repHS.model=r.a1
    }
   }

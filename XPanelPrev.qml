import QtQuick 2.0

Rectangle{
    id: r
    width: xApp.width*0.5
    height: xApp.height
    color: app.c1
    property int fs: app.fs*3

    Rectangle{
        id: r2
        width: r.width
        height: r.height
        color: app.c1
        Column{
            id: colHS
            //anchors.centerIn: parent
            Rectangle{
                width: r.width-app.fs
                height: r.fs*1.6
                color: app.c1
                border.width: 1
                border.color: app.c2
                UText{
                    text:  '<b>ANAGRAMA TWITCH</b>'
                    font.pixelSize: r.fs*1.5
                    color: app.c2
                    anchors.centerIn: parent
                }
            }

            Rectangle{
                width: r.width-app.fs
                height: r.fs*1.1
                color: app.c2
                border.width: 1
                border.color: app.c2
                UText{
                    text:  '<b>GANADOR MÁXIMO</b>'
                    font.pixelSize: r.fs
                    color: app.c1
                    anchors.centerIn: parent
                }
            }
            Rectangle{
                width: r.width-app.fs
                height: txtGM.contentHeight+app.fs*0.5
                border.width: 2
                border.color: app.c2
                radius: app.fs*0.25
                color: app.c1
                UText{
                    id: txtGM
                    //text:  '<b>nextsigner :)</b>'
                    font.pixelSize: r.fs
                    width: parent.width-app.fs
                    wrapMode: Text.WordWrap
                    horizontalAlignment: Text.AlignHCenter
                    anchors.centerIn: parent
                }
            }
            Rectangle{
                width: r.width-app.fs
                height: r.fs*1.1
                color: app.c2
                border.width: 1
                border.color: app.c2
                UText{
                    text:  '<b>PALABRA RECORD</b>'
                    font.pixelSize: r.fs
                    color: app.c1
                    anchors.centerIn: parent
                }
            }
            Rectangle{
                width: r.width-app.fs
                height: txtPR.contentHeight+app.fs*0.5
                border.width: 2
                border.color: app.c2
                radius: app.fs*0.25
                color: app.c1
                UText{
                    id: txtPR
                    //text:  '<b>saranagarana :)</b>'
                    font.pixelSize: r.fs
                    width: parent.width-app.fs
                    wrapMode: Text.WordWrap
                    horizontalAlignment: Text.AlignHCenter
                    anchors.centerIn: parent
                }
            }
            Item {
                width: 1
                height: r.fs*0.25
            }
            UText{
                width: r.width-app.fs*2
                height: contentHeight
                text: 'Para jugar enviá en el chat una palabra que se pueda formar con las letras de la palabra que se muestra en la parte superior derecha de esta pantalla.\n\nTambién puedes enviar audios de Whatsapp, para saber cómo funciona este juego.\n\nEnvía !wsp en el chat y obtendrás un enlace al grupo del canal para recibir una explicación o ayuda.\n\nMi Whatsapp es +54 11 3802 4370'
                font.pixelSize: app.fs*1.2
                wrapMode: Text.WordWrap
                anchors.horizontalCenter: parent.horizontalCenter
            }

        }
    }



    Timer{
        id: ud
        running: r.visible
        repeat: true
        interval: 2000
        onTriggered: {
            upDateData()
        }
    }
    function upDateData(){
        //Máximo Ganador
        let sql='SELECT nickname, COUNT( nickname ) AS total FROM  gameswins GROUP BY nickname ORDER BY total DESC LIMIT 1'
        let rows=unik.getSqlData(sql)
        if(rows.length>0){
            txtGM.text='<b>'+rows[0].col[0]+'</b> tiene '+rows[0].col[1]+' victorias'
        }else{
            txtGM.text='Nadie tiene victorias'
        }


        //Palabra Record
        sql='SELECT * FROM  hscores WHERE score>0 ORDER BY score DESC LIMIT 1;'
        rows=unik.getSqlData(sql)
        if(rows.length>0){
//            let d=new Date(parseInt(rows[0].col[5]))
//            let h=''+d.getHours()
//            if(h.length===1){
//                h='0'+h
//            }
//            let m=''+d.getMinutes()
//            if(m.length===1){
//                m='0'+m
//            }
//            let sec=''+d.getSeconds()
//            if(sec.length===1){
//                sec='0'+sec
//            }
//            let dia=''+d.getDate()
//            if(dia.length===1){
//                dia='0'+dia
//            }
//            let mes=''+d.getMonth()+1
//            if(mes.length===1){
//                mes='0'+mes
//            }
//            let anio=d.getFullYear()
//            let fecha=' el día '+dia+'/'+mes+'/'+anio+' a las '+h+':'+m+':'+sec+' GMT -3'
            //txtPR.text='<b>'+rows[0].col[1]+'</b> logró '+rows[0].col[6]+' puntos con la palabra '+rows[0].col[3]+' cuando la palabra en juego era '+rows[0].col[2]+' el día '+fecha
            txtPR.text='<b>'+rows[0].col[1]+' '+rows[0].col[6]+'pts '+rows[0].col[3]+' de '+rows[0].col[2]
        }else{
            txtPR.text='Nadie logró una palabra record.'
        }
    }
}

import QtQuick 2.0

Item {
    id: r
    anchors.fill: parent
    Column{
        spacing: app.fs
        anchors.centerIn: r
        UText{
            text: '<b>TWITCH</b><br /><b>ANAGRAMA</b>'
            textFormat: Text.RichText
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: app.fs*6
        }
        UText{
            text: 'Creado por @nextsigner'
            textFormat: Text.RichText
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: app.fs*2
        }
    }
}

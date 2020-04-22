import QtQuick 2.0

Item {
    id: r
    width: parent.width
    height: app.fs*2
    anchors.top: parent.top
    property int score: 0
    Row{
        spacing: app.fs*3
        anchors.centerIn: r
        UText{
            text: 'Twitch Galaxian'
        }
        UText{
            text: 'Score: '+r.score+' pts'
        }
    }
}

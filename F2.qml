import QtQuick 2.5
import QtQuick.Particles 2.0

Item {
    id: r
    width: parent.width
    height: parent.height
    property int p: 1
    onYChanged:{
        if(y>r.parent.height){
            //emitter.enabled=false
            r.destroy(10)
        }
    }
    Behavior on y{
        NumberAnimation{duration: 16000}
    }
    ParticleSystem {
        id: particleSystem
    }
    Emitter {
        id: emitter
        anchors.centerIn: parent
        width: r.width;
        height: r.height
        system: particleSystem
        emitRate: 1
        lifeSpan: 16000
        lifeSpanVariation: 16000
        size: app.fs*0.5
        endSize: app.fs*0.5
    }
    ImageParticle {
        id: particles
        anchors.fill: parent
        source: "file:./img/planets_"+r.p+".png"
        alpha: 0
        alphaVariation: 0.2
        colorVariation: 1.0
        system: particleSystem
    }
    Component.onCompleted: {
        r.y=r.parent.height+100
    }
}

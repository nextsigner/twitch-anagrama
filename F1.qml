import QtQuick 2.5
import QtQuick.Particles 2.0

Item {
    id: r
    width: parent.width
    height: parent.height
    onYChanged:{
        if(y>r.parent.height){
            //emitter.enabled=false
            r.destroy(10)
        }
    }
    Behavior on y{
        NumberAnimation{duration: 8000}
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
        emitRate: 30
        lifeSpan: 5000
        lifeSpanVariation: 5000
        size: 4
        endSize: 1
    }
    ImageParticle {
        id: particles
        anchors.fill: parent
        source: "file:./img/star1.png"
        alpha: 0
        //alphaVariation: 0.2
        //colorVariation: 1.0
        system: particleSystem
    }
    Component.onCompleted: {
        r.y=r.parent.height+100
    }
}

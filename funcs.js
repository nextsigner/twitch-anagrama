function getRandomRange(min, max) {
    return parseInt(Math.random() * (max - min) + min);
}
function getWordCount(){
    let fd=unik.getFile('spanish')
    let m0=fd.split('\n')
    return m0.length
}
function getWord(){
    let pw=getRandomRange(1, app.maxWordLength-1)
    let fd=unik.getFile('spanish')
    let m0=fd.split('\n')
    let word=m0[pw]
    return word
    //uLogView.showLog('Word: '+word)
}
function getHtmlSearchWord(w, wv){
    var req = new XMLHttpRequest();
    req.open('GET', 'https://dle.rae.es/'+w+'?m=form', true);
    req.onreadystatechange = function (aEvt) {
        if (req.readyState == 4) {
            if(req.status == 200)
                wv.loadHtml(req.responseText);
            else
                wv.loadHtml("Error loading page\n");
        }
    };
    req.send(null);
    //uLogView.showLog('Word: '+word)
}

function contarCaracteres(s, l) {
    let c=0
    for(var i=0;i<s.length;i++){
        if(s.charAt(i)===l){
            c++
        }
    }
    return c
}

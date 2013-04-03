SOUND = null;

function loadSound (src) { 
    var sound = document.createElement("audio"); 
    SOUND = sound;
    if ("src" in sound) { 
        sound.autoPlay = false; 
    } 
    else {
        alert("Error: Your browser does not support webaudio.  Please update your browser");
    } 
    sound.src = src; 
    document.body.appendChild(sound); 
    return sound; 
 } 

ff = function() {
    //SOUND.pause();
    SOUND.currentTime = 120; // Time in seconds.
    //SOUND.play();
}

$(function () {
    var sound = loadSound("content/DontWorryChild.ogg");  //  preload
    $("button").click(function () {
        sound.currentTime = 60;
        sound.play();
        setTimeout(ff,3000);
    });
});

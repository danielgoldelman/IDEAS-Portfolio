window.addEventListener('DOMContentLoaded', event => {
    var w = window.innerWidth;
    console.log(w)
    if (w < 768) {
        var vids = document.getElementsByTagName('video');
        for (var i = 0; i < vids.length; i++) {
            vids[i].width = "260";
            vids[i].height = "150";
        }
    }
});
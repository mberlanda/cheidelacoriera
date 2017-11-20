var fullScreenBtns = document.getElementsByClassName('fullscreen-btn');

$().ready(function(){
  initializeFullScreen();
  for (i = 0; i < fullScreenBtns.length; i++) {
    var btn = fullScreenBtns[i];
    prepareButton(btn);
  }
})

function initializeFullScreen(){
  // detect enter or exit fullscreen mode
  document.addEventListener('webkitfullscreenchange', fullscreenChange);
  document.addEventListener('mozfullscreenchange', fullscreenChange);
  document.addEventListener('fullscreenchange', fullscreenChange);
  document.addEventListener('MSFullscreenChange', fullscreenChange);

  function fullscreenChange() {
    if (document.fullscreenEnabled ||
         document.webkitIsFullScreen ||
         document.mozFullScreen ||
         document.msFullscreenElement) {
      // console.log('enter fullscreen');
    }
    else {
      // force to reload iframe once to prevent the iframe source didn't care about trying to resize the window
      var activeIframes = document.querySelectorAll('[full-screen-enabled="true"]');
      for (i = 0; i < activeIframes.length; i++) {
        var iframe = activeIframes[i];
        iframe.setAttribute('full-screen-enabled', 'false');
        iframe.src = iframe.src;
      }
      // console.log('exit fullscreen');
    }
  }
}

function prepareButton(button){
  button.addEventListener('click', function(){
    fullscreen(button);
  }, false);

  function fullscreen(button) {
    // check if fullscreen mode is available
    if (document.fullscreenEnabled ||
      document.webkitFullscreenEnabled ||
      document.mozFullScreenEnabled ||
      document.msFullscreenEnabled) {

      // which element will be fullscreen
      var iframe = button.closest('.photogallery-item').getElementsByClassName('embed-responsive-item')[0].getElementsByClassName('iframe-fullscreen')[0];
      // Do fullscreen
      if (iframe.requestFullscreen) {
        iframe.requestFullscreen();
        // Set attribute full-screen-enabled to tag the current iframe expanded
        iframe.setAttribute('full-screen-enabled', 'true');
      } else if (iframe.webkitRequestFullscreen) {
        iframe.webkitRequestFullscreen();
        iframe.setAttribute('full-screen-enabled', 'true');
      } else if (iframe.mozRequestFullScreen) {
        iframe.mozRequestFullScreen();
        iframe.setAttribute('full-screen-enabled', 'true');
      } else if (iframe.msRequestFullscreen) {
        iframe.msRequestFullscreen();
        iframe.setAttribute('full-screen-enabled', 'true');
      }
    }
    else {
      document.querySelector('.error').innerHTML = 'Your browser is not supported';
    }
  }
}

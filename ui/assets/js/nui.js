$(function(){
  window.addEventListener('message', function(event) {
    var crosshair = $(".crosshair-wrapper");

    switch(event.data.display) {
      case 'show':
				crosshair.fadeIn();
      break;
      case 'hide':
				crosshair.fadeOut();
      break;
    }
  });
});
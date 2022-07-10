$(function(){
  window.addEventListener('message', function(event) {
    var $xHair = $(".crosshair-wrapper");
    var $xHit = $(".crosshair-hitmarker");

    if (event.data.type == 'hit') {
      $xHit.show(0, function() {
        setTimeout(() => {
          $xHit.hide(0)
        }, 80);
      }); 
    }

    switch(event.data.display) {
      case 'show':
				$xHair.fadeIn();
      break;
      case 'hide':
				$xHair.fadeOut();
      break;
    }
  });
});
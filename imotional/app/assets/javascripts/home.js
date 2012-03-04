$(function(){
  var sever = 'ws://localhost:8485';
  var socket = new WebSocket(sever);
  var log = $('#log');

  socket.onmessage = function(msg) {
    // console.log("msg %o", msg);
    var data = msg.data.replace(/\r|\n/g, '');
    // log.prepend('<div>' + data + '</div>');
    
    // data is in xxx,yyy,zzz format
    try {
      coords = data.split(',');
      if(coords.length < 2) return;
      
      ball.x = coords[0];
      ball.y = coords[1];
    } catch(ex) {
      console.log(ex);
    }
  };
  
  var canvas = document.getElementById('canvas'),
      context = canvas.getContext('2d'),
      ball = new Ball(),
      vx = 1;

  ball.x = 50;
  ball.y = 100;

  (function drawFrame () {
    window.requestAnimationFrame(drawFrame, canvas);
    context.clearRect(0, 0, canvas.width, canvas.height);
    
    sl.log('x,y', JSON.stringify({x: ball.x, y: ball.y}));
    
    ball.draw(context);
  }());

});
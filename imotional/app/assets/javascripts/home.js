$(function(){
  var canvas = document.getElementById('canvas'),
      context = canvas.getContext('2d'),
      ball = new Ball(5),
      vx = 1, x0, y0;

  x0 = canvas.width / 2;
  y0 = canvas.height / 2;

  ball.x = x0;
  ball.y = y0;

  (function drawFrame () {
    window.requestAnimationFrame(drawFrame, canvas);
    context.clearRect(0, 0, canvas.width, canvas.height);
    
    // sl.log('x,y', JSON.stringify({x: ball.x, y: ball.y}));
    
    ball.draw(context);
  }());
  
  var mouse = utils.captureMouse(canvas);
  var isMouseDown = false;
  canvas.addEventListener('mousedown', function () {
    isMouseDown = true;
     // canvas.addEventListener('mousemove', onMouseMove, false);
   }, false);
   
  canvas.addEventListener('mousemove', function() {
    if(isMouseDown) {
      ball.x = mouse.x;
      ball.y = mouse.y;
    }
  });

   canvas.addEventListener('mouseup', function () {
     isMouseDown = false;
     // canvas.removeEventListener('mousemove', onMouseMove, false);
   }, false);


   var count = 0;
   setInterval(function() {
     sl.log('MPS', count);
     count = 0;
   },1000);


  var sever = 'ws://localhost:8485';
   // var sever = 'ws://marrily.com:8485';
   var socket = new WebSocket(sever);
   // var log = $('#log');
   
   var t = new Date;

	var screenScalingFactor = 5000;
  
   var lastAcceleration;
   var vx = vy = 0;
   var dx = dy = 0;
   socket.onmessage = function(msg) {
	  
     count++;
     var data = msg.data;
     sl.log('data', data);
     acceleration = data.split(',');
		 sl.log('acceleration[0]', acceleration[0])
		 sl.log('acceleration[1]', acceleration[1])

     if(acceleration.length < 2) return;
   	 
		if (Math.abs(acceleration[0]) < 0.05) acceleration[0] = 0;
		if (Math.abs(acceleration[1]) < 0.05) acceleration[1] = 0;
		if (Math.abs(acceleration[2]) < 0.05) acceleration[2] = 0;

		if (acceleration[0] > 0)	acceleration[0] = acceleration[0]*0.75;
	  // else {
		// 			var i;
		// 			for (i=0; i<3; i++) {
		// 				acceleration[i] = acceleration[i] * Math.pow(2, acceleration[i]);
		// 			}
		// 		}		
     // var t1 = new Date;
     // var dT = (t1 - t)/1000;
     // var dT2 = ((t1 - t) * (t1 - t)) / 1000000;
		var dT = (1.0/100.0);
		
		dx = (vx*dT + acceleration[0]*dT*dT/2.0)*screenScalingFactor;
		dy = (vy*dT + acceleration[1]*dT*dT/2.0)*screenScalingFactor;

			
//     dx = (vx*dT+0.5 * acceleration[0] * dT2 *3779)*20; //* 3779;
//     dy = (vy*dT+0.5 * acceleration[1] * dT2 *3779)*20; //* 3779;
		 
		 vx = (vx + (acceleration[0]) * dT) * 0.95;
		 vy = (vy + (acceleration[1]) * dT) * 0.95	;
     
     ball.x -= dx;
     ball.y += dy;

		if (ball.x < 10) { 
			ball.x = 10;
		} else if (ball.x > 900) {
			ball.x = 900;
		}
		
		if (ball.y < 80) {
			ball.y = 80;
		} else if (ball.y > 500) {
			ball.y = 500;
		}
     
     console.log("%o", {data: data, dy: dy, dx: dx, vx: vx, vy: vy, x: ball.x, y: ball.y, deltaT: dT, time: t});
		 //t = t1;
     sl.log("x,y", JSON.stringify({x: ball.x, y: ball.y}));
   };


});
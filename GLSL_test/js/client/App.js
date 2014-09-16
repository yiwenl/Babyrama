var App = function() {

	var gui, webgl, webcam;
	var data;
	var animationFrameId;
	var onReady;

	var initApplication = function() {
		data = new DataModel();
		gui = new Gui(data); 
		gui.init();
		
		webgl = new WebGL(data);
		webgl.initContext("webgl_canvas");
		webgl.loadShaders(["fragment_shader", "vertex_shader"], initWegGLProgram.bind(this));
		//webcam = new Webcam("webcam_video");
		//webcam.init();
	};

	var start = function() {
		render();
	};

	var render = function() {
		webgl.render();
		animationFrameId = window.requestAnimFrame(render);
	};

	var stop = function() {
		window.cancelRequestAnimFrame(animationFrameId);
	};

	var initWegGLProgram = function() {
		webgl.initProgram();
		this.onReady();
	};

	return {
		init : initApplication,
		start : start,
		stop : stop,
		onReady : onReady
	}
}

/******** requestAnimFrame ********/
window.requestAnimFrame = (function() {
  return window.requestAnimationFrame ||
         window.webkitRequestAnimationFrame ||
         window.mozRequestAnimationFrame ||
         window.oRequestAnimationFrame ||
         window.msRequestAnimationFrame ||
         function(/* function FrameRequestCallback */ callback, /* DOMElement Element */ element) {
           return window.setTimeout(callback, 1000/60);
         };
})();

window.cancelRequestAnimFrame = (function() {
  return window.cancelAnimationFrame ||
         window.mozCancelRequestAnimationFrame ||
         window.oCancelRequestAnimationFrame ||
         window.msCancelRequestAnimationFrame ||
         window.clearTimeout;
})(); 

/******** log ********/
function log(o, e) {
	if (console && console.log) {
		e != undefined ? console.log(o, e) : console.log(o);
	}
} 

function logOff() {
	log = function() {};
}

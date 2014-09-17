var Webcam = function(canvasID) {
	
	var gum;
	var constraints = {
		video : true,
		sound : false
	};
	var video = document.getElementById(canvasID);
	
	var onReady;

	var onSuccess = function(stream) {
		video.onloadedmetadata = onMetaData.bind(this);
		video.src = window.URL.createObjectURL(stream);
		
	};

	var onMetaData = function(e) {
		this.onReady();
	};

	var onError = function(e) {
		console.error(e);
	};

	var initWebcam = function() {
		if (Modernizr.getusermedia) {
			gum = Modernizr.prefixed('getUserMedia', navigator);
			gum(constraints, onSuccess.bind(this), onError);
		} 
		else {
			log("webcam not supported");
		}
	};

	return {
		init : initWebcam,
		onReady : onReady,
		video : video
	}

}

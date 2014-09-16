var Webcam = function(canvasID) {

	var gum;
	var constraints = {
		video : true,
		sound : false
	};
	var video = document.getElementById(canvasID);
	video.onloadedmetadata = onMetaData;

	var onSuccess = function(stream) {
		video.src = window.URL.createObjectURL(stream);
	};

	var onMetaData = function() {
		log("onMetaData");
	};

	var onError = function() {

	};

	var initWebcam = function() {
		if (Modernizr.getusermedia) {
			gum = Modernizr.prefixed('getUserMedia', navigator);
			updateWebcam();
		} 
		else {
			log("webcam not supported");
		}
	};

	var updateWebcam = function() {
		gum(constraints, onSuccess, onError);
	};

	return {
		init : initWebcam
	}

}

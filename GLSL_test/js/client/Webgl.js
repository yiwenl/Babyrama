// WEBGL

var WebGL = function(model) {
	
	var context;
	var program;
	var aShaders = [];
	var shaderToLoad = 0;
	var data = model;

	var onShadersLoaded = function() {
		log("do nothing");
	};

	var initContext = function(canvasID, options) {
		if (Modernizr.webgl) {
			var canvas = document.getElementById(canvasID);
			var contextNames = ["webgl", "experimental-webgl"];
			for (var i = 0; i < contextNames.length; i++) {
				try {
					context = canvas.getContext(contextNames[i], options);
				} catch(e) {}
				if (context) {
					return;
				}
			}
			log("webgl initialization error");
		} else {
			log("webgl not supported");
		}
	};

	var setContext = function(context) {
		this.ctx = context;
	}

	var onShaderLoaded = function(shaderDomElem, eventData) {
		var shader;
		switch(shaderDomElem.type) {
			case "x-shader/x-vertex" :
				shader = context.createShader(context.VERTEX_SHADER); 
				break;
			case "x-shader/x-fragment" :
				shader = context.createShader(context.FRAGMENT_SHADER);
				break;
			default :
				log("error on shader type for shader '" + shaderDomElem.id + "'");
				break;
		}
		if (shader) {
			context.shaderSource(shader, eventData.target.responseText);
			context.compileShader(shader);
			var success = context.getShaderParameter(shader, context.COMPILE_STATUS);
			if (!success) {
				log("error compiling '" + shader.id + "'  : " + context.getShaderInfoLog(shader));
				context.deleteShader(shader);
				return null;
			}
			aShaders.push(shader);
		}
		shaderToLoad--;
		if (shaderToLoad === 0) {
			onShadersLoaded();
		};
	};

	var loadShaders = function(shadersID, callback) {
		onShadersLoaded = callback;
		shaderToLoad = shadersID.length;
		for(var i = 0 ; i < shaderToLoad ; i++) {
			loadShader(shadersID[i]); 
		}
	};

	var loadShader = function(shaderID) {
		var shaderDomElem = document.getElementById(shaderID);
		if (!shaderDomElem) {
			log("shader '" + shaderID + "' not found.");
			return null;
		}
		var shaderXHR = new XMLHttpRequest();
		shaderXHR.open("GET", shaderDomElem.src, true);
		shaderXHR.onload = onShaderLoaded.bind(this, shaderDomElem);
		return shaderXHR.send(null);
	};

	var initProgram = function() {
		program = context.createProgram();
		for (var i = 0; i < aShaders.length; i++) {
			context.attachShader(program, aShaders[i]);
		}
		context.linkProgram(program);
		var success = context.getProgramParameter(program, context.LINK_STATUS);
		if (!success) {
			log("Error in program linking:" + context.getProgramInfoLog(program));
			context.deleteProgram(program);
		} 
		context.useProgram(program);
	};

	var render = function() {
		var positionLocation = context.getAttribLocation(program, "a_position");
		var multiplier = context.getUniformLocation(program, "u_multiplier");
		context.uniform4f(multiplier, data.redMultiplier, data.greenMultiplier, data.blueMultiplier, 1)
		var buffer = context.createBuffer();
		context.bindBuffer(context.ARRAY_BUFFER, buffer);
		context.bufferData(
		    context.ARRAY_BUFFER, 
		    new Float32Array([
		        -1.0, -1.0, 
		         1.0, -1.0, 
		        -1.0,  1.0, 
		        -1.0,  1.0, 
		         1.0, -1.0, 
		         1.0,  1.0]), 
		    context.STATIC_DRAW);
		context.enableVertexAttribArray(positionLocation);
		context.vertexAttribPointer(positionLocation, 2, context.FLOAT, false, 0, 0);
		context.drawArrays(context.TRIANGLES, 0, 6);
	}

	return {
		render : render,
		initContext : initContext,
		loadShaders : loadShaders,
		initProgram : initProgram
	}
}

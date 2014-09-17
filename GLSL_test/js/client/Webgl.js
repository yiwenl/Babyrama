// WEBGL

var WebGL = function(model) {
	
	var canvas;
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
			canvas = document.getElementById(canvasID);
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

	var preRender = function() {
		var resolutionLocation = context.getUniformLocation(program, "u_resolution");
		context.uniform2f(resolutionLocation, canvas.width, canvas.height);
	};

	var setRectangle = function (c, x, y, w, h) {
		var x1 = x;
		var x2 = x + w;
		var y1 = y;
		var y2 = y + h;
		c.bufferData(
			c.ARRAY_BUFFER,
			new Float32Array([
				x1, y1,
				x2, y1,
				x1, y2,
				x1, y2,
				x2, y1,
				x2, y2]),
			c.STATIC_DRAW
		);
	}

	var render = function() {
		var c = context;
		
		var multiplier = c.getUniformLocation(program, "u_multiplier");
		c.uniform4f(multiplier, data.redMultiplier, data.greenMultiplier, data.blueMultiplier, 1);

		var percentDisplay = c.getUniformLocation(program, "u_percentDisplay");
		c.uniform1f(percentDisplay, .625 - data.percentDisplay * .01 * .625);
		
		var positionLocation = c.getAttribLocation(program, "a_position");
  		var texturePosLocation = c.getAttribLocation(program, "a_texturePos");

		var texturePosBuffer = c.createBuffer();
		c.bindBuffer(c.ARRAY_BUFFER, texturePosBuffer);
		c.bufferData(c.ARRAY_BUFFER, new Float32Array([
			0.0,  0.0,
			1.0,  0.0,
			0.0,  1.0,
			0.0,  1.0,
			1.0,  0.0,
			1.0,  1.0]), c.STATIC_DRAW);
		c.enableVertexAttribArray(texturePosLocation);
		c.vertexAttribPointer(texturePosLocation, 2, c.FLOAT, false, 0.0, 0.0);

		// create texture
		var texture = c.createTexture();
		c.bindTexture(c.TEXTURE_2D, texture);

		c.texParameteri(c.TEXTURE_2D, c.TEXTURE_WRAP_S, c.CLAMP_TO_EDGE);
		c.texParameteri(c.TEXTURE_2D, c.TEXTURE_WRAP_T, c.CLAMP_TO_EDGE);
		c.texParameteri(c.TEXTURE_2D, c.TEXTURE_MIN_FILTER, c.NEAREST);
		c.texParameteri(c.TEXTURE_2D, c.TEXTURE_MAG_FILTER, c.NEAREST);

		c.texImage2D(c.TEXTURE_2D, 0.0, c.RGBA, c.RGBA, c.UNSIGNED_BYTE, data.texture);

		var buffer = c.createBuffer();
		c.bindBuffer(c.ARRAY_BUFFER, buffer);
		c.enableVertexAttribArray(positionLocation);
		c.vertexAttribPointer(positionLocation, 2, c.FLOAT, false, 0.0, 0.0);
		setRectangle(c, 0.0, 0.0, data.texture.videoWidth, data.texture.videoHeight);

		c.drawArrays(c.TRIANGLES, 0.0, 6);
	};

	

	return {
		preRender : preRender,
		render : render,
		initContext : initContext,
		loadShaders : loadShaders,
		initProgram : initProgram
	}
}

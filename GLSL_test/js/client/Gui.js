// GUI

var Gui = function(model) {

	var gui;
	var model = model;
	
	var initGui = function() {
		gui = new dat.GUI();
		addRGBMultiplier();	
	};

	var addRGBMultiplier = function () {
		var f = gui.addFolder('Colors Multiplier');
		f.add(model, "redMultiplier", 0, 1);
		f.add(model, "greenMultiplier", 0, 1);
		f.add(model, "blueMultiplier", 0, 1);
		f.open();
	};

	return {
		init : initGui
	}
}





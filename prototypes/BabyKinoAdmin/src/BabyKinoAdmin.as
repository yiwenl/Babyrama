package {

	/**
	 *	Class description.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 11.0
	 *
	 *	@author bongiovi.tw
	 *	@since  4:37:41 PM
	 */   
	
	import com.bit101.components.ComboBox;
	import com.bit101.components.HSlider;
	import com.bit101.components.Label;
	import com.bit101.components.PushButton;
	import com.bit101.components.Window;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.filters.BlurFilter;
	import flash.filters.ShaderFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.media.Camera;
	import flash.media.Video;
	
	import marcel.debug.Logger;
	import marcel.debug.loggers.SOSLogger;
	
	[SWF(width=1024, height=768, frameRate=30, backgroundColor=0)]
	public class BabyKinoAdmin extends Sprite {
	
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		[Embed(source="shaders/LensBlur.pbj", mimeType="application/octet-stream")]
		public var BlurLens:Class;
		
		[Embed(source="shaders/Contrast.pbj", mimeType="application/octet-stream")]
		public var Contrast:Class;
		
		
		public var VIDEO_WIDTH					: int = 320;
		public var VIDEO_HEIGHT					: int = 240;
		
		private var cam:Camera;
		private var vid:Video;
		private var bmpd:BitmapData;
		private var bmpdBlur:BitmapData;
		private var bmp:Bitmap;
		
		private var window:Window;
		private var sliderBright:HSlider;
		private var sliderBlur:HSlider;
		private var sliderRed:HSlider;
		private var sliderGreen:HSlider;
		private var sliderBlue:HSlider;
		private var sliderBlurRadius:HSlider;
		private var sliderContrast:HSlider;
		
		private var lblRedPrc:Label;
		private var lblGreenPrc:Label;
		private var lblBluePrc:Label;
		private var lblBrightnessPrc:Label;
		private var lblBlurPrc:Label;
		private var lblBlurRadiusPrc:Label;
		private var lblContrastPrc:Label;
		
		private var shaderLens:Shader = new Shader(new BlurLens);
		private var lensFilter:ShaderFilter;
		private var shaderContrast:Shader = new Shader(new Contrast);
		private var contrastFilter:ShaderFilter;
		
		private var _scaleFactor:Number = 2;

		private var cb:ComboBox;

		private var _configFile:File;
		
		public function BabyKinoAdmin() {
			Logger.addLogger(new SOSLogger);
			_configFile = File.applicationDirectory.resolvePath("config.xml");
			_init();
		}
		
		
		private function _init() : void {
			lensFilter = new ShaderFilter(shaderLens);
			contrastFilter = new ShaderFilter(shaderContrast);
			
			VIDEO_WIDTH = stage.stageWidth/_scaleFactor;
			VIDEO_HEIGHT = stage.stageHeight/_scaleFactor;
			cam = Camera.getCamera();
			cam.setMode(VIDEO_WIDTH, VIDEO_HEIGHT, 30);
			vid = new Video(VIDEO_WIDTH, VIDEO_HEIGHT);
			vid.attachCamera(cam);
			
			bmpd = new BitmapData(VIDEO_WIDTH, VIDEO_HEIGHT, false, 0);
			bmpdBlur = new BitmapData(VIDEO_WIDTH, VIDEO_HEIGHT, false, 0);
			bmp = Bitmap(addChild(new Bitmap(bmpd)));
			bmp.scaleX = bmp.scaleY = _scaleFactor;
			bmp.smoothing = true;
			
			__initControl();
			
			loadData(0);
			addEventListener(Event.ENTER_FRAME, __loop);
		}
		
		
		private function __initControl():void {
			window = new Window(this, 5, 5, "Controls");
			window.width = 400;
			window.height = 180;
			window.hasMinimizeButton = true;
			
			var lblRed:Label 	= new Label(window.content, 10, 10, "RED : ");
			var lblGreen:Label 	= new Label(window.content, 10, 30, "GREEN : ");
			var lblBlue:Label 	= new Label(window.content, 10, 50, "BLUE : ");
			var lblBrightness:Label = new Label(window.content, 10, 70, "BRIGHTNESS : ");
			var lblBlur:Label 	= new Label(window.content, 10, 90, "BLUR : ");
			var lblBlurRadius:Label 	= new Label(window.content, 10, 110, "BLUR RADIUS : ");
			var lblContrast:Label 		= new Label(window.content, 10, 130, "CONTRAST : ");
			
			
			lblRedPrc 			= new Label(window.content, 210, 10, "");
			lblGreenPrc 		= new Label(window.content, 210, 30, "");
			lblBluePrc 			= new Label(window.content, 210, 50, "");
			lblBrightnessPrc 	= new Label(window.content, 210, 70, "");
			lblBlurPrc 			= new Label(window.content, 210, 90, "");
			lblBlurRadiusPrc	= new Label(window.content, 210, 110, "");
			lblContrastPrc	= new Label(window.content, 210, 130, "");
			
			sliderRed = new HSlider(window.content, 100, 12, __onSlideHandler);
			sliderRed.value = 100;
			sliderGreen = new HSlider(window.content, 100, 32, __onSlideHandler);
			sliderGreen.value = 100;
			sliderBlue = new HSlider(window.content, 100, 52, __onSlideHandler);
			sliderBlue.value = 50;
			sliderBright = new HSlider(window.content, 100, 72, __onSlideHandler);
			sliderBright.value = 100;
			sliderBlur = new HSlider(window.content, 100, 92, __onSlideHandler);
			sliderBlur.value = 50;
			sliderBlurRadius = new HSlider(window.content, 100, 112, __onSlideHandler);
			sliderBlurRadius.value = 50;
			sliderContrast = new HSlider(window.content, 100, 132, __onSlideHandler);
			sliderContrast.value = 50;
			
			
			cb = new ComboBox(window.content, 250, 10, "First day", ["First day", "First week", "First month", "First year"]);
			cb.selectedIndex = 0;
			cb.addEventListener(Event.SELECT, _onSelected);
			new PushButton(window.content, 250, 40, "SAVE", __onSaveHandler);
			new PushButton(window.content, 250, 70, "EXPORT", __onExportHandler);
			
			__onSlideHandler();
		}
		
		
		private function __onExportHandler(e:Event) : void {
			__onSaveHandler();
			var fs:FileStream = new FileStream();
			fs.open(_configFile, FileMode.READ);
			var xml:XML = XML(fs.readUTFBytes(fs.bytesAvailable));
			fs.close();
			
			var file:File = File.desktopDirectory.resolvePath("config.xml");
			var stream:FileStream = new FileStream();
			stream.open(file, FileMode.WRITE);
			stream.writeUTFBytes(xml.toXMLString());
			stream.close();
		}
		
		
		private function _onSelected(e:Event) : void {	loadData(cb.selectedIndex);	}
		
		
		private function __onSaveHandler(e:Event=null) : void {
			var fs:FileStream = new FileStream();
			fs.open(_configFile, FileMode.READ);
			var xml:XML = XML(fs.readUTFBytes(fs.bytesAvailable));
			fs.close();
			
			xml.step[cb.selectedIndex].red = sliderRed.value / 100;
			xml.step[cb.selectedIndex].green = sliderGreen.value / 100;
			xml.step[cb.selectedIndex].blue = sliderBlue.value / 100;
			xml.step[cb.selectedIndex].brightness = sliderBright.value / 100;
			xml.step[cb.selectedIndex].contrast = sliderContrast.value / 50;
			xml.step[cb.selectedIndex].blur = sliderBlur.value / 100 * 30;
			xml.step[cb.selectedIndex].blurRadius = sliderBlurRadius.value * 4;
			
			var stream:FileStream = new FileStream();
			var filePath:String = _configFile.nativePath;
			var file:File = new File(filePath);
			stream = new FileStream();
			stream.open(file, FileMode.WRITE);
			var s:String = '<?xml version="1.0" encoding="utf-8"?>\n';
			s += xml.toXMLString();
			stream.writeUTFBytes(s);
			stream.close();
		}
		
		
		private function loadData(index:int) : void {
			var fs:FileStream = new FileStream();
			fs.open(_configFile, FileMode.READ);
			var xml:XML = XML(fs.readUTFBytes(fs.bytesAvailable)).step[index];
			fs.close();
			sliderRed.value = Number(xml.red) * 100;
			sliderGreen.value = Number(xml.green) * 100;
			sliderBlue.value = Number(xml.blue) * 100;
			sliderBright.value = Number(xml.brightness) * 100;
			sliderContrast.value = Number(xml.contrast) * 50;
			sliderBlur.value = Number(xml.blur) * 100 / 30;
			sliderBlurRadius.value = Number(xml.blurRadius) / 4;
			__onSlideHandler();
		}
		
		
		private function __loop(event:Event):void {
			bmpd.draw(vid);
			bmpdBlur.draw(vid);
			var blur:Number = sliderBlur.value / 100 * 30;
			bmpdBlur.applyFilter(bmpdBlur, bmpdBlur.rect, new Point, new BlurFilter(blur, blur, 1));
			shaderLens.data.srcBlur.input = bmpdBlur;
			shaderLens.data.center.value = [mouseX/_scaleFactor, mouseY/_scaleFactor];
			shaderLens.data.radius.value = [400 * sliderBlurRadius.value/100];
			shaderContrast.data.offset.value = [ sliderContrast.value / 50];
			bmpd.applyFilter(bmpd, bmpd.rect, bmpd.rect.topLeft, lensFilter);
			bmpd.applyFilter(bmpd, bmpd.rect, bmpd.rect.topLeft, contrastFilter);
		}	
		
		
		private function __onSlideHandler(e:Event=null) : void {
			var brightness:Number = sliderBright.value / 100;
			var ct:ColorTransform = bmp.transform.colorTransform;
			ct.redMultiplier 	= sliderRed.value / 100 * brightness;
			ct.greenMultiplier 	= sliderGreen.value / 100 * brightness;
			ct.blueMultiplier 	= sliderBlue.value / 100 * brightness;
			bmp.transform.colorTransform = ct;
			
			
			lblRedPrc.text = sliderRed.value + "%";
			lblGreenPrc.text = sliderGreen.value + "%";
			lblBluePrc.text = sliderBlue.value + "%";
			lblBlurPrc.text = (sliderBlur.value / 100 * 30).toString();
			lblBrightnessPrc.text = sliderBright.value + "%";
			lblBlurRadiusPrc.text = (400 * sliderBlurRadius.value/100).toString();
			lblContrastPrc.text = (sliderContrast.value / 50).toString();
		}
	}
}
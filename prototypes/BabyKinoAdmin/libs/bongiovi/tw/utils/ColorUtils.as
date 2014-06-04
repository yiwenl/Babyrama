//AS3///////////////////////////////////////////////////////////////////////////
// 
// Copyright 2009 
// 
////////////////////////////////////////////////////////////////////////////////

package bongiovi.tw.utils {
	import flash.display.BitmapData;

	/**
	 *	Class description.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author LIN Yi-Wen
	 *	@since  2009-08-26
	 */

	
	
	public class ColorUtils {
	
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
	
		/**
		 *	@constructor
		 */
		public function ColorUtils(){}
		
		
		public static function getARGB(pixelValue:Number) : Object {
			var alphaValue:uint = pixelValue >> 24 & 0xFF;
			var red:uint = pixelValue >> 16 & 0xFF;
			var green:uint = pixelValue >> 8 & 0xFF;
			var blue:uint = pixelValue & 0xFF;
			
			return {a:alphaValue, r:red, g:green, b:blue};
		}
		
		public static function getRGB(pixelValue:uint) : Object {
			var red:uint = pixelValue >> 16 & 0xFF;
			var green:uint = pixelValue >> 8 & 0xFF;
			var blue:uint = pixelValue & 0xFF;
			
			return {r:red, g:green, b:blue};
		}
		
		
		public static function getColor(r:Number, g:Number, b:Number, a:Number=255) : Number {
			var sColor:String	= getColorString(a) + getColorString(r) + getColorString(g) + getColorString(b);
			return parseInt(sColor, 16)
		}
		
		
		public static function getColorString(color:Number) : String {
			var s:String = color.toString(16);
			if(s.length == 1)	s	= "0" + s;
			return s;
		}
		
		
		public static function hex2rgb(pixelValue:uint) : Object {
			var alphaValue:uint = pixelValue >> 24 & 0xFF;
			var red:uint = pixelValue >> 16 & 0xFF;
			var green:uint = pixelValue >> 8 & 0xFF;
			var blue:uint = pixelValue & 0xFF;
			
			return {a:alphaValue, r:red, g:green, b:blue};
		}
		
		
		public static function rgb2hex(r:Number, g:Number, b:Number, alpha:Number=255) : Number {
			return (alpha << 24 | r << 16 | g << 8 | b);
		}
		
		
		public static function HSB2GRB(h:Number = 1, s:Number = 1, b:Number = 1):Object{
			h = int(h) % 360;
			var i:int = int(int(h / 60.0) % 6);
			var f:Number = h / 60.0 - int(h / 60.0);
			var p:Number = b * (1 - s);
			var q:Number = b * (1 - s * f);
			var t:Number = b * (1 - (1 - f) * s);
			switch (i) {   
				case 0: return { r:b, g:t, b:p };
				case 1: return { r:q, g:b, b:p };
				case 2: return { r:p, g:b, b:t };
				case 3: return { r:p, g:q, b:b };
				case 4: return { r:t, g:p, b:b };
				case 5: return { r:b, g:p, b:q };
			}
			return { r:0, g:0, b:0 };
		}
		
		
		public static function getRandomColorFrom(colors:Array) : uint {	return colors[int(Math.random() * colors.length)];	}
		
		
		public static function getColorBetween(c1:uint, c2:uint, percent:Number) : uint {
			var finalColor:uint = 0x000000;
			var tmp1:int;
			var tmp2:int;
			var channel:int;
			
			//	BLUE
			tmp1 = c1  & 0xFF;
			tmp2 = c2 & 0xFF;
			channel = int(tmp1 * percent + tmp2 * (1-percent));
			finalColor = channel;
			
			//	GREEN
			tmp1 = c1 >> 8 & 0xFF;
			tmp2 = c2 >> 8 & 0xFF;
			channel = int(tmp1 * percent + tmp2 * (1-percent));
			finalColor = finalColor | channel << 8;
			
			//	RED
			tmp1 = c1 >> 16 & 0xFF;
			tmp2 = c2 >> 16 & 0xFF;
			channel = int(tmp1 * percent + tmp2 * (1-percent));
			finalColor = finalColor | channel << 16;
			
			return finalColor;
		}
		
		
		public static function isBitmapTransparent(bmpd:BitmapData) : Boolean {	return bmpd.histogram(bmpd.rect)[3][0] === bmpd.width * bmpd.height;	}
		
		public static function brightnessColor(color:uint, level:Number) : uint {
			var a:uint = color >> 24 & 0xFF; 
			var r:uint = color >> 16 & 0xFF; 
			var g:uint = color >> 8 & 0xFF; 
			var b:uint = color & 0xFF;
			
			r *= level;
			g *= level;
			b *= level;
			
			if(r > 0xFF) r = 0xFF;
			if(g > 0xFF) g = 0xFF;
			if(b > 0xFF) b = 0xFF;
			
			var newColor:uint = a << 24 | r << 16 | g << 8 | b;
			return newColor;
		}
		
		
		public static function getColorFromImage(bmpd:BitmapData, interval:int=2) : Array {
			var colors:Array = [];
			var oExistedColor:Object = {};
			
			
			for(var j:int=0; j<bmpd.height/interval; j++) {
				for(var i:int=0; i<bmpd.width/interval; i++) {
					var color:uint = bmpd.getPixel32(i, j);
					if(oExistedColor[color] == undefined) {
						colors.push(color);
						oExistedColor[color] = 1;
					}
				}
			}
			
			
			return colors;
		}
	}

}

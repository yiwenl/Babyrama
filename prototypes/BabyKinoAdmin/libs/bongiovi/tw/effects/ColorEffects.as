/**
 *  Color Effects
 *	
 * 	@langversion ActionScript 3
 *	@playerversion Flash 9.0.0
 *
 *	@author Lin bongiovi
 *	@since  22.05.2008
 */
package bongiovi.tw.effects {
	import flash.display.*;	import flash.events.*;	import flash.filters.ColorMatrixFilter;		public dynamic class ColorEffects extends EventDispatcher{
		private static var _nRed:Number 						= 0.3086;
		private static var _nGreen:Number 						= 0.6094;
		private static var _nBlue:Number 						= 0.0820;
		
		
		public function ColorEffects(){
			tracethis("Activated");
		}
		
		
		/**
		 *	@public
		 *	@param	type
		 *	
		 *	return Filter Function
		 */
		public static function getFilterFunction(type:String) : Function {
			switch (type){
				case "contrast" :
					return setContrast;
				break;
				case "saturation" :
					return setSaturation;
				break;
				case "hue" :
					return setHue;
				break;
				case "brightness" :
					return brightness;
				break;
				
			}
			
			return null;
		}
		
		
		/**
		 * Set Contrast  0 ~ 1
		 * 
		 * @param  target 
		 * @param  nLevel 
		 * @return 
		 */
		
		public static function setContrast(target:*, nLevel:Number):void{
			var Scale : Number = nLevel * 11;
			var Offset : Number = 63.5 - (nLevel * 698.5);
			var Contrast_Matrix : Array = [Scale, 0, 0, 0, Offset, 0, Scale, 0, 0, Offset, 0, 0, Scale, 0, Offset, 0, 0, 0, 1, 0];
			(target as DisplayObject).filters = [new ColorMatrixFilter (Contrast_Matrix)];
		}
		
		
		/**
		 * Set Saturation , 0 ~ 3;
		 * 
		 * @param  target 
		 * @param  nLevel 
		 * @return 
		 */
		
		public static function setSaturation(target:*, nLevel:Number, brightness:Number=0):ColorMatrixFilter{
			var srcRa:Number 	= (1 - nLevel) * _nRed + nLevel;
			var srcGa:Number 	= (1 - nLevel) * _nGreen;
			var srcBa:Number 	= (1 - nLevel) * _nBlue;
			var srcRb:Number 	= (1 - nLevel) * _nRed;
			var srcGb:Number 	= (1 - nLevel) * _nGreen + nLevel;
			var srcBb:Number 	= (1 - nLevel) * _nBlue;
			var srcRc:Number 	= (1 - nLevel) * _nRed;
			var srcGc:Number 	= (1 - nLevel) * _nGreen;
			var srcBc:Number 	= (1 - nLevel) * _nBlue + nLevel;
			var Saturation_Matrix : Array = [	srcRa, srcGa, srcBa, 0, brightness, 
												srcRb, srcGb, srcBb, 0, brightness, 
												srcRc, srcGc, srcBc, 0, brightness, 
												0, 0, 0, 1, 0];
			var filter:ColorMatrixFilter = new ColorMatrixFilter (Saturation_Matrix);
			if(target != null)	(target as DisplayObject).filters = [filter];
			return filter;
		}
		
		/**
		 * Set Hue, -180 ~ 180
		 * 
		 * @param  target 
		 * @param  hue    
		 * @return 
		 */
		
		public static function setHue(target:*, hue:Number):void{
			hue = Math.min(180,Math.max(-180,hue))/180*Math.PI;
			var cosVal:Number = Math.cos(hue);
			var sinVal:Number = Math.sin(hue);
			var lumR:Number = 0.213;
			var lumG:Number = 0.715;
			var lumB:Number = 0.072;
			var HueMatrix: Array=[
			lumR+cosVal*(1-lumR)+sinVal*(-lumR),lumG+cosVal*(-lumG)+sinVal*(-lumG),lumB+cosVal*(-lumB)+sinVal*(1-lumB),0,0,
			lumR+cosVal*(-lumR)+sinVal*(0.143),lumG+cosVal*(1-lumG)+sinVal*(0.140),lumB+cosVal*(-lumB)+sinVal*(-0.283),0,0,
			lumR+cosVal*(-lumR)+sinVal*(-(1-lumR)),lumG+cosVal*(-lumG)+sinVal*(lumG),lumB+cosVal*(1-lumB)+sinVal*(lumB),0,0,
			0,0,0,1,0
			];
			
			(target as DisplayObject).filters = [new ColorMatrixFilter (HueMatrix)];
		}
		
		
		/**
		 * Set to gray style
		 * 
		 * @param  target 
		 * @param  value  
		 * @return 
		 */
		
		public static function toGrayScale(target:*, value:Number):void{
			var matrix:Array = new Array();
			matrix = matrix.concat([value, 0, 0, 0, 0]); // red
			matrix = matrix.concat([value, 0, 0, 0, 0]); // green
			matrix = matrix.concat([value, 0, 0, 0, 0]); // blue
			matrix = matrix.concat([0, 0, 0, 1, 0]); // alpha
			
			var filter:ColorMatrixFilter = new ColorMatrixFilter(matrix);
			var filters:Array = new Array();
			filters.push(filter);
			(target as DisplayObject).filters = filters;
		}
		
		
		/**
		 * Set brightness -255 ~ 255
		 * 
		 * @param  target 
		 * @param  value  
		 * @return 
		 */
		 
		public static function brightness(target:*, value:Number=1):void{
			var matrix:Array = new Array();
			matrix = matrix.concat([1, 0, 0, 0, value]); 		// red
			matrix = matrix.concat([0, 1, 0, 0, value]); 		// green
			matrix = matrix.concat([0, 0, 1, 0, value]); 		// blue
			matrix = matrix.concat([0, 0, 0, 1, 0]); 			// alpha
			
			var filter:ColorMatrixFilter = new ColorMatrixFilter(matrix);
			var filters:Array = new Array();
			filters.push(filter);
			(target as DisplayObject).filters = filters;
		}
		
		
		/**
		 * Set to ColorMF
		 * 
		 * @param  target 
		 * @param  value  
		 * @return 
		 */
		 
		public static function setColorMF(target:*, matrix:Array):void{
			var filter:ColorMatrixFilter = new ColorMatrixFilter(matrix);
			var filters:Array = new Array();
			filters.push(filter);
			(target as DisplayObject).filters = filters;
		}
		
		
		public static function rgb2hue(red:uint, green:uint, blue:uint):Number {  
			var r:Number = red/0xff;  
			var g:Number = green / 0xff;  
			var b:Number = blue / 0xff;  
			var max:Number = Math.max(r, g, b);  
			var min:Number = Math.min(r, g, b);  
			var hue:Number;  
			
			if (max == min) {  
				return 0;
			}  
			
			switch (max) {           
				case r:  
					hue = 60 * (g - b) / (max - min);  
					hue = (hue < 0)?(hue + 360):hue;  
					break;  
				case g:  
					hue = 60 * (b - r) / (max - min) + 120;  
					break;  
				case b:  
					hue = 60 * (r - g) / (max - min) + 240;  
					break;  
			}  

	     	return hue;  
		}
		
		
		public static function tracethis(str:*):void{
			trace("# Color Effect 			#  "+str);
		}
	}
}
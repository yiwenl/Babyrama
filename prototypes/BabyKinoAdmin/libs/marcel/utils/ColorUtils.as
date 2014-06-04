/**
 * Licensed under the MIT License
 *
 * Copyright (c) 2010 Alexandre Croiseaux
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of
 * this software and associated documentation files (the "Software"), to deal in
 * the Software without restriction, including without limitation the rights to
 * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
 * the Software, and to permit persons to whom the Software is furnished to do so,
 * subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
 * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
 * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
 * IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 *
 */
package marcel.utils
{
	import flash.display.DisplayObject;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.ColorTransform;
	
	/**
	* 	Class that contains static utility methods for manipulating and working
	*	with Colors.
	* 	@author Alexandre Croiseaux
	*/
	public class ColorUtils
	{
		//--------------------------------------------------------------------------
		//
		//  Private vars
		//
		//--------------------------------------------------------------------------
		private static const RWGT:Number = .3086;
		private static const GWGT:Number = .6094;
		private static const BWGT:Number = .0820;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Constructs a new ColorUtils instance.
		 */
		public function ColorUtils() { };
		
		
		//--------------------------------------------------------------------------
		//
		//  Public vars
		//
		//--------------------------------------------------------------------------
		/**
		 * alpha value of the current ColorUtils object.
		 */
		public var a:uint = 1 ;
		/**
		 * red value of the current ColorUtils object.
		 */
		public var r:uint = 0 ;
		/**
		 * green value of the current ColorUtils object.
		 */
		public var g:uint = 0 ;
		/**
		 * blue value of the current ColorUtils object.
		 */
		public var b:uint = 0 ;
		/**
		 * hex value of the current ColorUtils object.
		 */
		public var hex:uint = 0 ;
		
		public static const LUMINANCE_FILTER:ColorMatrixFilter = new ColorMatrixFilter(new Array(RWGT, GWGT, BWGT, 0, 0, RWGT, GWGT, BWGT, 0, 0, RWGT, GWGT, BWGT, 0, 0, 0, 0, 0, 1, 0));
		public static const NEGATIVE_FILTER:ColorMatrixFilter = new ColorMatrixFilter(new Array(-1, 0, 0, 0, 255, 0, -1, 0, 0, 255, 0, 0, -1, 0, 255, 0, 0, 0, 1, 0));
		
		
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		/**
		 * Returns alpha multiply of current ColorUtils object.
		 */
		public function get alphaMultiply():Number { return a / 0xFF };
		
		/**
		 * Transforms the current ColorUtils instance into a ColorTransform instance.
		 * @return	a ColorTransform instance.
		 */
		public function toColorTransform():ColorTransform
		{
			var c:ColorTransform = new ColorTransform();
			c.redMultiplier = c.greenMultiplier = c.blueMultiplier = a;
			c.redOffset = r;
			c.greenOffset = g;
			c.blueOffset = b;
			return (c);
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Public static methods
		//
		//--------------------------------------------------------------------------
		/**
		 * Transforms an hex color into an ARGB color.
		 * @param	an hex color value.
		 * @return	a ColorUtils instance containg a,r,g,b properties.
		 */
		static public function hexToARGB(color:uint):ColorUtils
		{
			var c:ColorUtils = new ColorUtils();
			c.a = color >> 24 & 0xFF;
			c.r = color >> 16 & 0xFF;
			c.g = color >> 8 & 0xFF;
			c.b = color & 0xFF;
			c.hex = color
			return c;
		}
		
		/**
		 * Transforms an ARGB color into an hex color.
		 * @param	a	alpha value of the color.
		 * @param	r	red value of the color.
		 * @param	g	green value of the color.
		 * @param	b	blue value of the color.
		 * @return	an hex color value as an uint.
		 */
		static public function ARGBToHex(a:uint, r:uint, g:uint, b:uint):uint
		{
			return a << 24 ^ r << 16 ^ g << 8 ^ b;
		}
		
		/**
		 * Transforms an RGB color into an hex color.
		 * @param	r	red value of the color.
		 * @param	g	green value of the color.
		 * @param	b	blue value of the color.
		 * @return	an hex color value as an uint.
		 */
		static public function RGBToHex(r:uint, g:uint, b:uint):uint
		{
			return r << 16 ^ g << 8 ^ b;
		}
		
		
		/**
		 * Transforms an hex color into an RGB color.
		 * @param	an hex color value.
		 * @return	a ColorUtils instances containg r,g,b properties (alpha=255).
		 */
		static public function hexToRGB(color:uint):ColorUtils
		{
			var c:ColorUtils = new ColorUtils();
			c.a = 255;
			c.r = color >> 16 & 0xFF;
			c.g = color >> 8 & 0xFF;
			c.b = color & 0xFF;
			c.hex = color;
			return c;
		}
		
		/**
		 * Adds an alpha value to an RGB hex color (RGB->ARGB).
		 * @param	color	the color to add alpha value to.
		 * @param	alpha	alpha value to add.
		 * @return	an ARGB hax color.
		 */
		static public function hexToHex32(color:uint, alpha:Number = 255):uint
		{
			var c:ColorUtils = hexToRGB(color);
			return ARGBToHex(alpha,c.r,c.g,c.b);
		}
		
		/**
		 * Removes an alpha value from an ARGB hex color (ARGB->RGB).
		 * @param	color the color to remove alpha value from.
		 * @return	a ColorUtils instance containg r,g,b properties.
		 */
		static public function hex32ToHex(color:uint):ColorUtils
		{
			var c:ColorUtils = hexToARGB(color);
			c.hex = RGBToHex(c.r,c.g,c.b);
			return c;
		}
		
		
		/**
		 * Transforms the color of the current instance to the specified color
		 * @param	dis		the DisplayObject inctance to apply transformation to
		 * @param	color	the color to transform to
		 */
		static public function setColor(dis:DisplayObject, color:uint):void
		{
			var newColorTransform:ColorTransform = dis.transform.colorTransform;
			newColorTransform.color = color;
			dis.transform.colorTransform = newColorTransform;
		}
		
		/**
		 * Resets the color properties to the default ones by applying a default ColorTransform instance
		 * @param	dis		the DisplayObject inctance to apply transformation to
		 */
		static public function resetColor(dis:DisplayObject):void
		{
			dis.transform.colorTransform = new ColorTransform();
		}
		
		/**
		 * Set the brightness of the instance. This is analogous to Flash's old "Brightness" color option on the object property panel.
		 * @param	dis		the DisplayObject inctance to apply transformation to
		 * @param	val		brightness value to set (range -1 -> [0] -> +1)
		 */
		static public function setTintBrightness(dis:DisplayObject, val:Number):void
		{
			var multiplier:int = 1 - Math.abs(val);
			var offset:int = val > 0 ? Math.round(val * 255) : 0;
			dis.transform.colorTransform = new ColorTransform(multiplier, multiplier, multiplier, 1, offset, offset, offset, 0);
		}
		
		/**
		 * Set the brightness of the instance. This value is analogous to the brightness value used in Photoshop, or Flash's new "Adjust color" filte
		 * @param	dis		the DisplayObject inctance to apply transformation to
		 * @param	val		brightness value to set (range -1 -> [0] -> +1)
		 */
		static public function setBrightness(dis:DisplayObject, val:Number):void
		{
			var offset:Number = Math.round(val * 100);
			dis.transform.colorTransform = new ColorTransform(1, 1, 1, 1, offset, offset, offset, 0);
		}
		
		/**
		 * Set the brightness of the instance with a "burn" effect.
		 * @param	dis		the DisplayObject inctance to apply transformation to
		 * @param	val		brightness value to set (range -1 -> [0] -> +1)
		 */
		static public function setBrightOffset(dis:DisplayObject, val:Number):void
		{
			var offset:int =  Math.round(val * 255);
			dis.transform.colorTransform = new ColorTransform(1, 1, 1, 1, offset, offset, offset, 0);
		}
		
		/**
		 * Returns a ColorMatrixFilter which sets the luminance (desaturation) based on a given ratio (range [0-1])
		 * @param	ratio		The amount of luminance (0 -> [1], 0=normal, 1=B and W)
		 */
		public static function getLuminanceFilter(ratio:Number = 1):ColorMatrixFilter
		{
			var r1:Number = 1 + (RWGT - 1) * ratio;
			var r2:Number = RWGT * ratio;
			var g1:Number = 1 + (GWGT - 1) * ratio;
			var g2:Number = GWGT * ratio;
			var b1:Number = 1 + (BWGT - 1) * ratio;
			var b2:Number = BWGT * ratio;
			return new ColorMatrixFilter(new Array(
				r1,	g2,	b2,	0,	0,
				r2,	g1,	b2,	0,	0,
				r2,	g2,	b1,	0,	0,
				0,	0,	0,	1,	0));
		}
		
		/**
		 * Returns a ColorMatrixFilter which sets the bright offset based on a given ratio (range -225 -> [0] -> 255])
		 * @param	ratio		The amount of bright offset (-1 -> [0] -> 1)
		 */
		public static function getBrightOffsetFilter(ratio:Number = 0):ColorMatrixFilter
		{
			ratio = Math.max(-255, Math.min(255, 255 * ratio));
			return new ColorMatrixFilter(new Array(
				1,	0,	0,	0,   ratio,
				0,	1,	0,	0,   ratio,
				0,	0,	1,	0,   ratio,
				0,	0,	0,	1,   0));
		}
		
		/**
		 * Returns a ColorMatrixFilter which sets the saturation based on a given ratio (range 0 -> [1] -> 2])
		 * @param	ratio		The amount of saturation (0 -> [1] -> 2)
		 */
		public static function getSaturationFilter(ratio:Number = 1):ColorMatrixFilter
		{
			var r1:Number = RWGT * (1 - ratio);
			var g1:Number = GWGT * (1 - ratio);
			var b1:Number = BWGT * (1 - ratio);
			
			return new ColorMatrixFilter(new Array(
				r1 + ratio,	g1,		b1,		0,	0,
				r1,		g1 + ratio,	b1,		0,	0,
				r1,		g1,		b1 + ratio,	0,	0,
				0,		0,		0, 		1,	0));
		}
		
		/**
		 * Returns a colormatric filter to tint an object to the specified color
		 * @param	rgb		an RGB hex color value
		 * @param	alpha	an alpha value [0-1]
		 * @return	a inctance of ColorMatrixFilter
		 */
		public static function getColorMatrixFilter(rgb:uint, alpha:Number):ColorMatrixFilter
		{
			var matrix:Array = [];
			matrix = matrix.concat([((rgb & 0x00FF0000) >>> 16)/255, 0, 0, 0, 0]); // red
			matrix = matrix.concat([0, ((rgb & 0x0000FF00) >>> 8)/255, 0, 0, 0]); // green
			matrix = matrix.concat([0, 0, (rgb & 0x000000FF)/255, 0, 0]); // blue
			matrix = matrix.concat([0, 0, 0, alpha, 0]); // alpha
			
			return new ColorMatrixFilter(matrix);
		}
	}
}
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
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	* 	Class that contains static utility methods for manipulating and working
	*	with Bitmaps.
	* 	@author Alexandre Croiseaux
	*/
	public class BitmapUtils
	{
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		/**
		 * Returns a screenshot of any display object as a BitmapData
		 * @param	source		a DisplayObject to draw
		 * @param	transparent	catch DisplayObject transparency or not
		 * @param	fillColor	if transparent is false, replace transparent values by this color
		 * @param	registerPointCorrection	indicates if a matrix must be used to correct the source register point.
		 * 					Set true if the source contains display with negative coords.
		 * @param	bounds		a rectangle specifying the bounds of the object to draw; if null, source.getBounds() is used.
		 * @return	A BitmapData instance
		 */
		public static function getBitmapData(source:DisplayObject, transparent:Boolean = false, fillColor:uint = 0x00FFFFFF, registerPointCorrection:Boolean = true, bounds:Rectangle = null):BitmapData
		{
			if (bounds == null) bounds = source.getBounds(source);
			var mat:Matrix = new Matrix();
			if (registerPointCorrection) mat.translate(-bounds.left, -bounds.top);
			var bmpData:BitmapData = new BitmapData(Math.round(bounds.width), Math.round(bounds.height), transparent, fillColor);
			bmpData.draw(source, mat);
			return bmpData;
		}
		
		/**
		 * Returns a Bitmap Instance from any display object
		 * @param	source		a DisplayObject to draw
		 * @param	smoothed	Whether or not the bitmap is smoothed when scaled.
		 * @param 	pixelSnapping	Whether or not the Bitmap object is snapped to the nearest pixel.
		 * @param	transparent	catch DisplayObject transparency or not
		 * @param	fillColor	if transparent is false, replace transparent values by this color
		 * @param	registerPointCorrection	indicates if a matrix must be used to correct the source register point.
		 * 					Set true if the source contains display with negative coords.
		 * @param	bounds		a rectangle specifying the bounds of the object to draw; if null, source.getBounds() is used.
		 * @return	A Bitmap instance
		 */
		public static function getBitmap(source:DisplayObject, smoothed:Boolean = true, pixelSnapping:String = "auto"/*PixelSnapping.AUTO*/, transparent:Boolean = false, fillColor:uint = 0x00FFFFFF, registerPointCorrection:Boolean = true, bounds:Rectangle = null):Bitmap
		{
			var bd:BitmapData = getBitmapData(source, transparent, fillColor, registerPointCorrection, bounds);
			return new Bitmap(bd, pixelSnapping, smoothed);
		}
		
		/**
		 * Rescales a BitmapData to the specified ratio.
		 * @param	bmp		The BitmapData to resize
		 * @param	ratio		The scale ratio (1 = 100%)
		 * @param	smoothing	Whether or not the bitmap is smoothed when scaled.
		 * @param	useSampling	Whether or not progressive resizing must be used.
		 * 				Flash Bilinear Filtering renders poor quality Bitmaps if ratio &lt; 0.5.
		 * 				If useSampling is true and ratio is &lt; 0.5, multiple resize operations are done
		 * 				to have better quality result.
		 * @return	A rescaled BitmapData instance
		 */
		public static function rescale(bmp:BitmapData, ratio:Number, smoothing:Boolean = true, useSampling:Boolean = true):BitmapData
		{
			if (useSampling) return getSampledResizedBitmapData(bmp, Math.round(bmp.width * ratio),  Math.round(bmp.height * ratio), smoothing);
			return getResizedBitmapData(bmp, Math.round(bmp.width * ratio),  Math.round(bmp.height * ratio), smoothing);
		}
		
		/**
		 * Returns a cropped BitmapData from a source BitmapData
		 * @param	bmpSource	the BitmapData to crop
		 * @param	rect		the cropping area
		 * @return	the newly created BitmapData instance
		 */
		public static function crop(bmpSource:BitmapData, rect:Rectangle):BitmapData
		{
			var bmp:BitmapData = new BitmapData(rect.width, rect.height, bmpSource.transparent);
			bmp.copyPixels(bmpSource, rect, new Point());
			return bmp;
		}
		
		/**
		 * Resizes a BitmapData to the specified size.
		 * @param	bmp		The BitmapData to resize
		 * @param	width		the new width expected
		 * @param	height		the new height expected
		 * @param	respectRatio	indicates if the ratio width/height must be respected.
		 * 				If true, the returned BitmapData will have a maximum width value of 'width', and a maximum height value of 'height'
		 * 				and the ratio width/height will stay the same.
		 * 				If false, the returned BitmapData will be stretched to the exact specified width &amp; height values.
		 * @param	smoothing	Whether or not the bitmap is smoothed when scaled.
		 * @param	useSampling	Whether or not progressive resizing must be used.
		 * 				Flash Bilinear Filtering renders poor quality Bitmaps if ratio &lt; 0.5.
		 * 				If useSampling is true and ratio is &lt; 0.5, multiple resize operations are done
		 * 				to have better quality result.
		 * @return	A rescaled BitmapData instance
		 */
		public static function resize(bmp:BitmapData, width:uint, height:uint, respectRatio:Boolean = true, smoothing:Boolean = true, useSampling:Boolean = false):BitmapData
		{
			if (!respectRatio)
			{
				if (useSampling) return getSampledResizedBitmapData(bmp, width, height, smoothing);
				return getResizedBitmapData(bmp, width, height, smoothing);
			}
			else
			{
				var ratio:Number = Math.min(width / bmp.width, height / bmp.height);
				if (useSampling) return getSampledResizedBitmapData(bmp, Math.round(bmp.width * ratio), Math.round(bmp.height * ratio), smoothing);
				return getResizedBitmapData(bmp, Math.round(bmp.width * ratio), Math.round(bmp.height * ratio), smoothing);
			}
		}
		
		
		/**
		 * Forces the passed BitmapData to fit a specific size by performing a resize and a crop operation.
		 * The smallest side of the BitmapData will fit the passed width or height to be sure the final image is fully filled.
		 * The width/height ratio is respected, so a alignement value must be specified to know which part of the image will be selected.
		 * @param	bmp		The BitmapData instance to resize and crop
		 * @param	width		the new width expected
		 * @param	height		the new height expected
		 * @param	align		which part of the image should be kept after the resize process.
		 * 				Must be a constant of the StageManager class. Default = StageManager.TOP_LEFT
		 * @param	smoothing	Whether or not the bitmap is smoothed when scaled.
		 * @param	useSampling	Whether or not progressive resizing must be used.
		 * 				Flash Bilinear Filtering renders poor quality Bitmaps if ratio &lt; 0.5.
		 * 				If useSampling is true and ratio is &lt; 0.5, multiple resize operations are done
		 * 				to have better quality result.
		 * @return	A resized and cropped BitmapData instance
		 * @see marcel.display.stage.StageManager
		 */
		public static function fit(bmp:BitmapData, width:uint, height:uint, align:String = "TL", smoothing:Boolean = true, useSampling:Boolean = false):BitmapData
		{
			var ratio:Number = Math.max(width / bmp.width, height / bmp.height);
			var bd:BitmapData;
			
			// resize
			if (useSampling) bd = getSampledResizedBitmapData(bmp, Math.round(bmp.width * ratio), Math.round(bmp.height * ratio), smoothing);
			else bd = getResizedBitmapData(bmp, Math.round(bmp.width * ratio), Math.round(bmp.height * ratio), smoothing);
			
			// crop
			var x:uint = 0;
			var y:uint = 0;
			switch(align.charAt(1).toLowerCase())
			{
				case "l": x = 0; break;
				case "c": x = (bd.width - width) / 2; break;
				case "r": x = bd.width - width; break;
			}
			switch(align.charAt(0).toLowerCase())
			{
				case "t": y = 0; break;
				case "m": y = (bd.height - height) / 2; break;
				case "b": y = bd.height - height; break;
			}
			
			var r:Rectangle = new Rectangle(x, y, width, height);
			return crop(bd, r);
		}
		
		/**
		 * Returns a 1x1 pixel with the specified color
		 * @param	color	the color if the pixel, in ARGB format
		 * @return	A BitmapData instance of width=1px and height=1px
		 */
		public static function getPixel(color:int) : BitmapData
		{
			return new BitmapData(1, 1, true, color);
		}
		
		
		/**
		 * Returns a screenshot of any display object as a BitmapData of the size of the specified rectangle
		 * @param	source		a DisplayObject to draw
		 * @param 	rect		the target size of the bitmap data
		 * @param	transparent	catch DisplayObject transparency or not
		 * @param	fillColor	if transparent is false, replace transparent values by this color
		 * @return	A BitmapData instance
		 */
		public static function getRectangleBitmapData(o:DisplayObject, rec:Rectangle = null, transparent:Boolean = true, fillColor:Number = 0x00FFFFFF):BitmapData
		{
			if (rec === null) return getBitmapData(o, transparent, fillColor);
			var _bmp:BitmapData = new BitmapData(rec.width, rec.height, transparent, fillColor);
			var mat:Matrix = new Matrix();
			mat.translate( -1 * rec.x, -1 * rec.y);
			_bmp.draw(o, mat, null, null, null, true);
			return _bmp;
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
		private static function getResizedBitmapData(bmp:BitmapData, width:uint, height:uint, smoothing:Boolean):BitmapData
		{
			var bmpData:BitmapData = new BitmapData(width, height, bmp.transparent, 0x00FFFFFF);
			var scaleMatrix:Matrix = new Matrix(width / bmp.width, 0, 0, height / bmp.height, 0, 0);
			bmpData.draw(bmp, scaleMatrix, new ColorTransform(), null, null, smoothing);
			
			return bmpData;
		}
		
		private static function getSampledResizedBitmapData(bmp:BitmapData, width:uint, height:uint, smoothing:Boolean):BitmapData
		{
			// on utilise une boucle pour limiter le resize à 50% par opération
			// car le filtre bilinéaire utilisé par flash a un rendu pourri en dessous de 50%
			// http://en.wikipedia.org/wiki/Bilinear_filtering
			var bmpData:BitmapData = bmp.clone();
			var wRatio:Number = width / bmp.width;
			var hRatio:Number = height / bmp.height;
			var appliedWRatio:Number = 1;
			var appliedHRatio:Number = 1;
			var w:uint;
			var h:uint;
			
			do
			{
				// width
				if (wRatio < 0.5 * appliedWRatio)
				{
					w = Math.round(bmpData.width * 0.5);
					appliedWRatio = 0.5 * appliedWRatio;
				}
				else
				{
					w = Math.floor(bmpData.width * wRatio / appliedWRatio);
					appliedWRatio = wRatio;
				}
				
				// height
				if (hRatio < 0.5 * appliedHRatio)
				{
					h = Math.round(bmpData.height * 0.5);
					appliedHRatio = 0.5 * appliedHRatio;
				}
				else
				{
					h = Math.floor(bmpData.height * hRatio / appliedHRatio);
					appliedHRatio = hRatio;
				}
				
				// draw
				bmpData = getResizedBitmapData(bmpData, w, h, smoothing);
			}
			while (appliedWRatio != wRatio || appliedHRatio != hRatio);
			
			return bmpData;
		}
	}
}

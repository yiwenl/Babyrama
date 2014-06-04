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
	import flash.geom.Rectangle;

	/**
	 * Aligner static class used to align display objects
	 * @author Alexandre Croiseaux
	 */
	public class Aligner
	{
		//--------------------------------------------------------------------------
		//
		//  Public vars
		//
		//--------------------------------------------------------------------------
		public static const LEFT:uint = 0;
		public static const CENTER:uint = 1;
		public static const RIGHT:uint = 2;
		public static const TOP:uint = 0;
		public static const MIDDLE:uint = 1;
		public static const BOTTOM:uint = 2;
		
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		/**
		 * Aligns all the display objects horizontally starting at the x value
		 * @param	displayObjects	list of display object to align
		 * @param	x		starting x coord
		 * @param	lockPoint	Indicates which part of the display object must be locked to the specified x
		 * 				=> Aligner.LEFT = the left bound of the object will be set at the specified x value
		 * 				=> Aligner.CENTER = the center bound of the object will be set at the specified x value
		 * 				=> Aligner.RIGHT = the right bound of the object will be set at the specified x value
		 * @param 	rounded		indicates if values must be rounded to integers
		 */
		public static function alignX(displayObjects:Array, x:Number, lockPoint:uint = Aligner.LEFT, rounded:Boolean = false):void
		{
			align("x", displayObjects, x, lockPoint, rounded);
		}
		
		/**
		 * Aligns all the display objects vertically starting at the y value
		 * @param	displayObjects	list of display object to align
		 * @param	y		starting y coord
		 * @param	lockPoint	Indicates which part of the display object must be locked to the specified y
		 * 				=> Aligner.TOP = the top bound of the object will be set at the specified y value
		 * 				=> Aligner.MIDDLE = the middle bound of the object will be set at the specified y value
		 * 				=> Aligner.BOTTOM = the bottom bound of the object will be set at the specified y value
		 * @param 	rounded		indicates if values must be rounded to integers
		 */
		public static function alignY(displayObjects:Array, y:Number, lockPoint:uint = Aligner.TOP, rounded:Boolean = false):void
		{
			align("y", displayObjects, y, lockPoint, rounded);
		}
		
		/**
		 * Cascades all the display objects horizontally starting at the startX value, relatively to the precedent object.
		 * @param	displayObjects	list of display object to align
		 * @param	startX		starting x coord
		 * @param	space		space between each element
		 * @param	cascadePoint	Indicates where the startX value must be used in the cascade :
		 * 				=> Aligner.LEFT = startX is the left point, so objects will be extended to the right
		 * 				=> Aligner.CENTER = startX is the center point, so objects will be extended to the left AND to the right
		 * 				=> Aligner.RIGHT = startX is the right point, so objects will be extended to the left
		 * @param 	rounded		indicates if values must be rounded to integers
		 */
		public static function cascadeX(displayObjects:Array, startX:Number, space:Number = 0, cascadePoint:uint = Aligner.LEFT, rounded:Boolean = false):void
		{
			if (cascadePoint == Aligner.CENTER) Aligner.center("width", "x", displayObjects, startX, space, rounded);
			else Aligner.cascade("width", "x", displayObjects, startX, space, cascadePoint, rounded);
		}
		
		/**
		 * Cascades all the display objects vertically starting at the startY value, relatively to the precedent object.
		 * @param	displayObjects	list of display object to align
		 * @param	startY		starting y coord
		 * @param	space		space between each element
		 * @param	cascadePoint	Indicates where the startY value must be used in the cascade :
		 * 				=> Aligner.TOP = startY is the top point, so objects will be extended to the bottom
		 * 				=> Aligner.MIDDLE = startY is the middle point, so objects will be extended to the top AND to the bottom
		 * 				=> Aligner.BOTTOM = startY is the bottom point, so objects will be extended to the top
		 * @param 	rounded		indicates if values must be rounded to integers
		 */
		public static function cascadeY(displayObjects:Array, startY:Number, space:Number = 0, cascadePoint:uint = Aligner.TOP, rounded:Boolean = false):void
		{
			if (cascadePoint == Aligner.MIDDLE) Aligner.center("height", "y", displayObjects, startY, space, rounded);
			else Aligner.cascade("height", "y", displayObjects, startY, space, cascadePoint, rounded);
		}
		
		/**
		 * Aligns all the display objects horizontally between the startX value end the endX value, using all space available
		 * @param	displayObjects	list of display object to align
		 * @param	startX		starting x coord
		 * @param	endX		ending x coord
		 * @param 	rounded		indicates if values must be rounded to integers
		 */
		public static function dispatchX(displayObjects:Array, startX:Number, endX:Number, rounded:Boolean = false):void
		{
			Aligner.dispatch("width", "x", displayObjects, startX, endX, rounded);
		}
		
		/**
		 * Aligns all the display objects vertically between the startY value end the endY value, using all space available
		 * @param	displayObjects	list of display object to align
		 * @param	startY		starting y coord
		 * @param	endY		ending y coord
		 * @param 	rounded		indicates if values must be rounded to integers
		 */
		public static function dispatchY(displayObjects:Array, startY:Number, endY:Number, rounded:Boolean = false):void
		{
			Aligner.dispatch("height", "y", displayObjects, startY, endY, rounded);
		}
		
		/**
		 * Displays the specified display objects as a grid
		 * @param	displayObjects	list of display object to align
		 * @param	nbRows			number of rows in the grid
		 * @param	nbColumns		number of columns in the grid
		 * @param	horizontalGap	the horizontal gap between all cells in the grid
		 * @param	verticalGap		the vertical gap between all cells in the grid
		 * @param 	rounded		indicates if values must be rounded to integers
		 */
		public static function displayAsGrid(displayObjects:Array, nbRows:uint, nbColumns:uint, horizontalGap:uint = 0, verticalGap:uint = 0, rounded:Boolean = false):void
		{
			if (displayObjects == null || displayObjects.length == 0) return;
			
			var x:uint;
			var y:uint;
			var d:DisplayObject;
			displayObjects = displayObjects.slice();
			
			for (var i:int = 0; i < nbRows; i++)
			{
				if (displayObjects.length == 0) return;
				
				for (var j:int = 0; j < nbColumns; j++)
				{
					d = displayObjects.shift();
					d.x = rounded ? int(x) : x;
					d.y = rounded ? int(y) : y;
					
					x += d.width + horizontalGap;
				}
				
				x = 0;
				y += d.height + verticalGap;
			}
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
		private static function align(applyProp:String, displayObjects:Array, val:Number, lockPoint:uint = 0, rounded:Boolean = false):void
		{
			var isX:Boolean = applyProp == "x";
			
			for (var i:int = 0; i < displayObjects.length; i++)
			{
				var d:DisplayObject = displayObjects[i];
				var bounds:Rectangle = d.getBounds(d);
				switch (lockPoint)
				{
					case Aligner.LEFT:
						if (isX) d.x = val - bounds.left;
						else d.y = val - bounds.top;
						break;
					case Aligner.RIGHT:
						if (isX) d.x = val - bounds.right;
						else d.y = val - bounds.bottom;
						break;
					case Aligner.CENTER:
						if (isX) d.x = val - bounds.width / 2 - bounds.left;
						else d.y = val - bounds.height / 2 - bounds.top;
						break;
					default:
						if (isX) d.x = val;
						else d.y = val;
				}
				if (rounded)
				{
					d.x = Math.round(d.x);
					d.y = Math.round(d.y);
				}
			}
		}
		
		private static function cascade(calcProp:String, applyProp:String, displayObjects:Array, start:Number, space:Number = 0, sens:Number = 0, rounded:Boolean = false):void
		{
			var w:Number = 0;
			for (var i:Number = 0; i < displayObjects.length; i++)
			{
				var mc:DisplayObject = displayObjects[i];
				var bounds:Rectangle = mc.getBounds(mc);
				mc[applyProp] = (sens == 0) ? start + w : start - (mc[calcProp] + w);
				mc[applyProp] -= bounds[applyProp];
				if (rounded) mc[applyProp] = Math.round(mc[applyProp]);
				w += mc[calcProp] + space;
			}
		}
		
		private static function center(calcProp:String, applyProp:String, displayObjects:Array, start_center:Number, space:Number, rounded:Boolean = false):void
		{
			// calcul de la place
			var nb:Number = displayObjects.length;
			var mcsSize:Number = 0;
			for (var i:Number = 0; i < nb; i++) mcsSize += displayObjects[i][calcProp] + space;
			mcsSize -= space;
			
			cascade(calcProp, applyProp, displayObjects, Math.round(start_center - (mcsSize/2)), space, 0, rounded);
		}
		
		private static function dispatch(calcProp:String, applyProp:String, displayObjects:Array, start:Number, end:Number, rounded:Boolean = false):void
		{
			// calcul de la place
			var value:Number;
			var nb:Number = displayObjects.length;
			var w:Number = end - start;
			var mcsSize:Number = 0;
			for (var i:Number = 0; i < nb; i++) mcsSize += displayObjects[i][calcProp];
			var space:Number = (w - mcsSize) / (nb - 1);
			
			// placement
			for (var j:Number = 0; j < nb; j++)
			{
				var mc:DisplayObject = displayObjects[j];
				var bounds:Rectangle = mc.getBounds(mc);
				value = start - bounds[applyProp];
				if (rounded) value = Math.round(value);
				mc[applyProp] = value;
				start += mc[calcProp] + space;
			}
		}
	}
}
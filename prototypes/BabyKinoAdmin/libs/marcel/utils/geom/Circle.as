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
package marcel.utils.geom
{
	import flash.display.Graphics;
	import flash.geom.Point;
	
	/**
	 * A simple geom circle class
	 * @author Alexandre Croiseaux
	 */
	public class Circle
	{
		//--------------------------------------------------------------------------
		//
		//  Public vars
		//
		//--------------------------------------------------------------------------
		/**
		 * Defines the radius of the circle
		 */
		public var radius:Number;
		
		/**
		 * Defines the x position of the circle
		 */
		public var x:Number;
		
		/**
		 * Defines the y position of the circle
		 */
		public var y:Number;
		
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Constructs a new Circle instance
		 * @param	iX	the x position of the circle
		 * @param	iY	the y position of the circle
		 * @param	iRadius	the radius of the circle
		 */
		public function Circle(iX:Number, iY:Number, iRadius:Number)
		{
			x = iX;
			y = iY;
			radius = iRadius;
		}
		
		/**
		 * Returns the circle diameter
		 */
		public function get diameter():Number
		{
			return 2 * radius;
		}
		
		/**
		 * Returns the circle surface
		 */
		public function get surface():Number
		{
			return Math.PI * radius * radius;
		}
		
		/**
		 * Returns the circle perimeter
		 */
		public function get perimeter():Number
		{
			return 2 * Math.PI * radius;
		}
		
		/**
		 * Check if the specified coords are in the circle
		 * @param	x	the x coord
		 * @param	y	the y coord
		 */
		public function contains(x:Number, y:Number):Boolean
		{
			var p1:Point = new Point();
			var p2:Point = new Point(x, y);
			return Point.distance(p1, p2) <= radius;
		}
		
		/**
		 * Draws the circle into a Grahics instance, lineStyle and beginFill must be call before the function
		 * @param	targetGraphics	the graphics to draw the circle into
		 */
		public function draw(targetGraphics:Graphics):void
		{
			targetGraphics.drawCircle(x, y, radius);
		}
	}
}
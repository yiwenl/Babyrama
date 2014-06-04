/**
 * Licensed under the MIT License
 *
 * Copyright (c) 2010 Robert Penner
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
	import flash.geom.Point;
	import flash.display.Graphics;
	
	/**
	 * Defines a bezier Quad curve (1 control point)
	 * @author Robert Penner
	 */
	public class QuadCurve
	{
		//--------------------------------------------------------------------------
		//
		//  Private vars
		//
		//--------------------------------------------------------------------------
		private var _p1:Point;
		private var _p2:Point;
		private var _p3:Point;
		
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Constructs a new QuadCurve
		 * @param	p1	start point
		 * @param	p2	control point
		 * @param	p3	end point
		 */
		public function QuadCurve(p1:Point, p2:Point, p3:Point)
		{
			_p1 = p1;
			_p2 = p2;
			_p3 = p3;
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		/**
		 * Draws the line into a Grahics instance, lineStyle and beginFill must be call before the function
		 * @param	targetGraphics	the graphics to draw the circle into
		 */
		public function draw(targetGraphics:Graphics):void
		{
			targetGraphics.moveTo(_p1.x, _p1.y);
			targetGraphics.curveTo(_p2.x, _p2.y, _p3.x, _p3.y);
		}
		
		/**
		 * Updates points values
		 * @param	p1	start point
		 * @param	p2	control point
		 * @param	p3	end point
		 */
		public function updatePoints(p1:Point, p2:Point, p3:Point):void
		{
			_p1 = p1;
			_p2 = p2;
			_p3 = p3;
		}
	}
}
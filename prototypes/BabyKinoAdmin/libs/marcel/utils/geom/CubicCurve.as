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
	 * Defines a bezier Cubic curve (2 control points)
	 * @author Robert Penner
	 */
	public class CubicCurve
	{
		//--------------------------------------------------------------------------
		//
		//  Private vars
		//
		//--------------------------------------------------------------------------
		private var _p1:Point;
		private var _p2:Point;
		private var _p3:Point;
		private var _p4:Point;
		private var _xpen:Number;
		private var _ypen:Number;
		private var _drawGraphics:Graphics;
		
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Constructs a new CubicCurve instance
		 * @param	p1	start point
		 * @param	p2	control point 1
		 * @param	p3	control point 2
		 * @param	p4	end point
		 */
		public function CubicCurve(p1:Point, p2:Point, p3:Point, p4:Point)
		{
			_p1 = p1;
			_p2 = p2;
			_p3 = p3;
			_p4 = p4;
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
			_drawGraphics = targetGraphics;
			drawBezierPts();
		}
		
		/**
		 * Updates points values
		 * @param	p1	start point
		 * @param	p2	control point
		 * @param	p3	end point
		 */
		public function updatePoints(p1:Point, p2:Point, p3:Point, p4:Point):void
		{
			_p1 = p1;
			_p2 = p2;
			_p3 = p3;
			_p4 = p4;
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
		private function midLine(a:Point, b:Point):Point
		{		
			return new Point((a.x + b.x)/2, (a.y + b.y)/2);
		}
		
		private function bezierSplit(p0:Point, p1:Point, p2:Point, p3:Point):Object
		{		
			var m:Function = this.midLine;
			var p01:Point = m(p0, p1);
			var p12:Point = m(p1, p2);
			var p23:Point = m(p2, p3);
			var p02:Point = m(p01, p12);
			var p13:Point = m(p12, p23);
			var p03:Point = m(p02, p13);
			return {
				b0:{a:p0,  b:p01, c:p02, d:p03},
				b1:{a:p03, b:p13, c:p23, d:p3 }  
			};
		}

		private function calculateBezier(a:Point, b:Point, c:Point, d:Point, k:Number):void
		{		
			
			var s:Point = intersect2Lines (a, b, c, d);
			if (s == null) return;
			var dx:Number = (a.x + d.x + s.x * 4 - (b.x + c.x) * 3) * .125;
			var dy:Number = (a.y + d.y + s.y * 4 - (b.y + c.y) * 3) * .125;
			
			if (dx*dx + dy*dy > k)
			{
				var halves:Object = this.bezierSplit (a, b, c, d);
				var b0:Object = halves.b0;
				var b1:Object = halves.b1;
				calculateBezier(a, b0.b, b0.c, b0.d, k);
				calculateBezier(b1.a,  b1.b, b1.c, d, k);
			}
			else
			{
				_drawGraphics.curveTo (s.x, s.y, d.x, d.y);
				_xpen = d.x;
				_ypen = d.y;
			}
		}
		
		private function intersect2Lines(p1:Point, p2:Point, p3:Point, p4:Point):Point
		{		
			var x1:Number = p1.x; 
			var y1:Number = p1.y;
			var x4:Number = p4.x; 
			var y4:Number = p4.y;
			
			var dx1:Number = p2.x - x1;
			var dx2:Number = p3.x - x4;
			if (!(dx1 || dx2)) return null;
			
			var m1:Number = (p2.y - y1) / dx1;
			var m2:Number = (p3.y - y4) / dx2;
			
			if (!dx1) return new Point(x1, m2 * (x1 - x4) + y4);
			else if (!dx2) return new Point(x4, m1 * (x4 - x1) + y1);
			
			var xInt:Number = (-m2 * x4 + y4 + m1 * x1 - y1) / (m1 - m2);
			var yInt:Number = m1 * (xInt - x1) + y1;
			return new Point(xInt, yInt);
		}
		
		private function drawBezierPts():void
		{		
			_drawGraphics.moveTo (_p1.x, _p1.y);
			_xpen = _p1.x;
			_ypen = _p1.y;
			
			var tolerance:Number = 1;
			calculateBezier(_p1, _p2, _p3, _p4, tolerance * tolerance);
		}
	}
}
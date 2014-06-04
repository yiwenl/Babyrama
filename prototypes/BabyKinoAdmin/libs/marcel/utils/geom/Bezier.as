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
	
	/**
	 * Bezier class to get any point along a bezier quad curve or cubic curve
	 * @author Robert Penner
	 */
	public class Bezier
	{
		/**
		 * Returns the point placed along the specified bezier quad curve
		 * @param	t	the percent of the searched point (range [0-100])
		 * @param	p1	curve start point
		 * @param	p2	curve control point
		 * @param	p3	curve end point
		 * @return	a Point instance
		 */
		static public function getQuadCurvePoints(t:Number, p1:Point, p2:Point, p3:Point):Point
		{
			var v:Number = t / 100;
			var ix:Number = p1.x + v * (2*(1-v)*(p2.x-p1.x) + v*(p3.x - p1.x));
			var iy:Number = p1.y + v * (2*(1-v)*(p2.y-p1.y) + v*(p3.y - p1.y));
			return new Point(ix, iy);
		}
		
		/**
		 * Returns the point placed along the specified bezier cubic curve
		 * @param	t	the percent of the searched point (range [0-100])
		 * @param	p1	curve start point
		 * @param	p2	curve control point 1
		 * @param	p3	curve control point 2
		 * @param	p4	curve end point
		 * @return	a Point instance
		 */
		static public function getCubicCurvePoints(t:Number, p1:Point, p2:Point, p3:Point, p4:Point):Point
		{
			var a:Number,b:Number,c:Number;
			var v:Number = t / 100;	
			a = 1 - v;
			b = a * a * a;
			c = v * v * v;
			var ix:Number = b * p1.x + 3 * v * a * a * p2.x + 3 * v * v * a * p3.x + c * p4.x;
			var iy:Number = b * p1.y + 3 * v * a * a * p2.y + 3 * v * v * a * p3.y + c * p4.y;
			return new Point(ix, iy);
		}
	}
}
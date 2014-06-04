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
	import flash.geom.Point;
	/**
	* 	Class that contains static utility methods for manipulating and working
	*	with Numbers.
	* @author Alexandre Croiseaux
	* @author Laurent Berthelot
	*/
	public class MathUtils
	{
		/**
		 * Performs a number translation from one range to another
		 * @param	value		number to transform
		 * @param	fromRange	the array representing the start range (ex : [min, max])
		 * @param	toRange		the array representing the destinatino range (ex : [min, max])
		 * @param	clamp		an optionnal value spcecifying if the number must be clamped into the destination range
		 * @return	a number translated from one range to another
		 */
		static public function rescale(value:Number, fromRange:Array, toRange:Array, clamp:Boolean = false):Number
		{
			if (clamp)
			{
				var min:Number = Math.min(fromRange[0], fromRange[1]);
				var max:Number = Math.max(fromRange[0], fromRange[1]);				
				if (value < min) value = min;
				if (value > max) value = max;
			}
			
			return ((value - fromRange[0]) * (toRange[1] - toRange[0])) / (fromRange[1] - fromRange[0]) + toRange[0];
		}
		
		/**
		 * Limits a number value to a range
		 * @param	value	value to limit
		 * @param	min	minimum value
		 * @param	max	maximum value
		 * @param	loop	indicates if the value must loop to max when inferior to min and vice versa
		 * 			ex: min=5, max=10, val=3 -> result=8
		 * @return	the clamped number
		 */
		static public function clamp(value:Number, min:Number, max:Number, loop:Boolean = false):Number
		{
			if (loop)
			{
				if (value < min) return max - ((min - value) % (max - min));
				if (value > max) return min + ((value - max) % (max - min));
			}
			return Math.max(Math.min(value, max), min) ;
		}
		
		/**
		 * Rounds a number with a specified value float count
		 * @param	value		the value to round
		 * @param	floatCount	float count
		 * @return
		 */
		static public function round(value:Number, floatCount:Number):Number
		{
			var r:Number = 1;
			var i:Number = -1;
			while (++i < floatCount) r *= 10;
			return Math.round(value*r) / r;
		}
		
		/**
		 * Tests if a number is positive or negative
		 * @param	value	the number to test
		 * @return	1 if the number is positive, -1 if its negative
		 */
		static public function sign(value:Number):int
		{
			return value < 0 ? -1 : 1;
		}
		
		/**
		 * Returns the percent of a number in the [0-max] range
		 * @param	value
		 * @param	max
		 * @param	round
		 * @return
		 */
		static public function percent(value:Number, max:Number, round:Boolean = false):Number
		{
			var n:Number = (value / max) * 100;
			return round ? Math.round(n) : n;
		}
		
		static public function percentOf(percent:Number, value:Number):Number {
			return percent * value / 100;
		}
		
		/**
		 * Returns a ramdom int between min &amp; max included
		 * @param	min	minimum random value (included)
		 * @param	max	maximum random value (included)
		 * @return	a random number
		 */
		static public function random(min:int, max:int):Number { return Math.round(Math.random() * (max - min)) + min; }
		
		/**
		 * Returns the sinus value of an angle in degrees
		 * @param	angle	the angle in degrees
		 * @return	the sinus value
		 */
		static public function sinD(angle:Number):Number { return Math.sin(angle * (Math.PI / 180)); }
		
		/**
		 * Returns the cosinus value of an angle in degrees
		 * @param	angle	the angle in degrees
		 * @return	the cosinus value
		 */
		static public function cosD(angle:Number):Number { return Math.cos(angle * (Math.PI / 180)); }
		
		/**
		 * Returns the acosinus value of an angle in degrees
		 * @param	angle	the angle in degrees
		 * @return	the acosinus value
		 */
		static public function acosD(angle:Number):Number { return Math.acos(angle) * (180 / Math.PI); }
		
		/**
		 * Returns the atan value of an angle in degrees
		 * @param	angle	the angle in degrees
		 * @return	the atan value
		 */
		static public function atanD(angle:Number):Number { return Math.atan(angle) * (180 / Math.PI); }
		
		/**
		 * Returns the atan2 value of an angle in degrees
		 * @param	angle	the angle in degrees
		 * @return	the atan2 value
		 */
		static public function atan2D(x:Number, y:Number):Number { return Math.atan2(y, x) * (180 / Math.PI); }
		
		/**
		 * 
		 * @param	radian
		 * @return
		 */
		public static function radianToDegree(rad:Number):Number { return 180 * rad / Math.PI; }
		
		/**
		 * 
		 * @param	degree
		 * @return
		 */
		public static function degreeToRadian(degree:Number):Number { return Math.PI * degree / 180; }
		
		/**
		 * 
		 * @param	p1
		 * @param	p2
		 * @return
		 */
		public static function getAngle(p1:Point, p2:Point):Number {
			var _angle:Number = Math.acos((p2.x - p1.x) / Point.distance(p1, p2));
			return (p1.y > p2.y)? -1 * _angle : _angle;
		}
		
		/**
		 * 
		 * @param	p1
		 * @param	p2
		 * @return
		 */
		public static function getAbsDelta(p1:Point, p2:Point):Point {
			return new Point(Math.abs(p2.x - p1.x), Math.abs(p2.y - p1.y));
		}
		
		/**
		 * Returns the shortest rotation value between 2 angles
		 * @param	angle1	start angle in degrees.
		 * @param	angle2	end angle in degrees
		 * @return	the short rotation
		 */
		public static function getShortRotation(angle1:Number, angle2:Number):Number
		{
			return ((angle1 - angle2 + 540) % 360) - 180;
		}
		 
	}
}
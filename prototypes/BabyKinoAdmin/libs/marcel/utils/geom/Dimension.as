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
	/**
	 * The Dimension object represents a dimension in a two-dimensional coordinate system.
	 * @author Alexandre Croiseaux
	 */
	public class Dimension
	{
		/**
		 * The width of the dimension. The default value is 0.
		 */
		public var width:Number;
		
		/**
		 * The height of the dimension. The default value is 0.
		 */
		public var height:Number;
		
		/**
		 * Creates a new Dimension Object with the specified width and height.
		 * @param	width
		 * @param	height
		 */
		public function Dimension(width:Number = 0, height:Number = 0)
		{
			this.width = width;
			this.height = height;
		}
		
		/**
		 * Scale the current dimension by multiplying the width and the height by the specified value.
		 * @param	n	The scale factor.
		 */
		public function scale(n:Number):void
		{
			width *= n;
			height *= n;
		}
		
		/**
		 * Creates a copy of this Dimension object.
		 * @return	The new Dimension object.
		 */
		public function clone():Dimension
		{
			return new Dimension(width, height);
		}		
	}
}
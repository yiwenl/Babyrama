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
	* Class that contains static utility methods for manipulating and working with Arrays
	* @author Alexandre Croiseaux
	*/
	public class ArrayUtils
	{
		/**
		 * Checks whether an array contains a specific item.
		 *
		 * @param ar 		array to check
		 * @param item 		item to check
		 * @return true if the array contains the element, false otherwise
		 */
		public static function contains(ar:Array, item:*):Boolean
		{
			for (var i:int = 0; i < ar.length; i++)
			{
				if (ar[i] == item) return true;
			}
			return false;
		}

		/**
		 * Removes duplicate elements from the given array and returns a new Array.
		 * @param 	array to process
		 * @return	a new Array instance with removed duplicates
		 */
		public static function removeDuplicates(ar:Array):Array
		{
			var result:Array = ar.slice();
			var a1:int;
			var a2:int;
			var t:*;
			for (a1 = 0; a1 < result.length; a1++)
			{
				t = ar[a1];
				for (a2 = 0; a2 < result.length; a2++)
				{
					if (result[a2] == result[a1])
					{
						if (a2 != a1)
						{
							result.splice(a2, 1);
						}
					}
				}
			}
			return result;
		}

		/**
		 * Shuffles a given array and returns a new Array.
		 *
		 * @param ar array to be shuffled
		 * @return a new shuffled array
		 */
		public static function shuffle(ar:Array):Array
		{
			var result:Array = ar.slice();
			var n:int;
			var tmp:*;
			var len:int = result.length;
			for (var i:int = 0;i < len; i++)
			{
				n = Math.floor(Math.random() * len);
				tmp = result[i];
				result[i] = result[n];
				result[n] = tmp;
			}
			return result;
		}

		/**
		 * Removes an item from an array
		 * @param ar the array to remove the item from
		 * @param item the item to remove
		 * @return true if the item has been found, false otherwise.
		 */
		public static function remove(ar:Array, item:*):Boolean
		{
			for (var i:int = 0; i < ar.length; i++)
			{
				if (ar[i] == item)
				{
					ar.splice(i, 1);
					return true;
				}
			}
			return false;
		}
		
		/**
		 * Merges 2 arrays without duplicates.
		 * @param	ar1	first array to merge
		 * @param	ar2	first array to merge
		 * @return	the merged array
		 */
		public static function merge(ar1:Array, ar2:Array):Array
		{
			return ArrayUtils.removeDuplicates(ar1.concat(ar2));
		}
		
		/**
		 * Returns an array containing values that are NOT in both ar1 and ar2 arrays, but only in one of them;
		 * @param	ar1	first array to check
		 * @param	ar2	second array to check
		 * @return	an Array instance
		 */
		public static function diff(ar1:Array, ar2:Array):Array
		{
			var res:Array = [];
			var test:Array = ar1.concat(ar2);
			var len:uint = test.length;
			for (var i:uint = 0; i < len; i++)
			{
				if (!ArrayUtils.contains(ar1, test[i]) || !ArrayUtils.contains(ar2, test[i])) res.push(test[i]);
			}
			return res;
		}
		
		/**
		 * Returns an array containing values that are in both ar1 and ar2 arrays.
		 * @param	ar1	first array to check
		 * @param	ar2	second array to check
		 * @return	an Array instance
		 */
		public static function intersect(ar1:Array, ar2:Array):Array
		{
			var ar3:Array = new Array();
			
			for (var i:uint = 0; i < ar1.length; i++)
			{
				for (var j:uint = 0; j < ar2.length; j++)
				{
					if (ar1[i] == ar2[j]) ar3.push(ar1[i]);
				}
			}
			return ar3;
		}
		
		
		public static function getShift(position : Number, p : Point, factor : Point = null) : Point {
			var _factor : Point = (factor !== null) ? factor : new Point(1, 1);
			return new Point((position % p.x) * _factor.x, Math.floor(position / p.x) * _factor.y);
		}
		
		public static function getShiftReserve(position : Number, p : Point, factor : Point = null) : Point {
			var _factor : Point = (factor !== null) ? factor : new Point(1, 1);
			return new Point(_factor.x * Math.floor(position / p.y), _factor.y * Math.floor(position % p.y));
		}
		public static function getIndex(position : Point, dimension : Point) : Number {
			return position.y * dimension.x + position.x;
		}
		
		public static function getOnLeftIndex(position : Point, dimension : Point) : Number {
			if (position.x === 0) return -1;
			return getIndex(new Point(position.x - 1, position.y), dimension);
		}
		
		public static function getOnRightIndex(position : Point, dimension : Point) : Number {
			if (position.x === dimension.x - 1) return -1;
			return getIndex(new Point(position.x + 1, position.y), dimension);
		}
		
		public static function getOnTopIndex(position : Point, dimension : Point) : Number {
			if (position.y === 0) return -1;
			return getIndex(new Point(position.x, position.y - 1), dimension);
		}
		
		public static function getOnBottomIndex(position : Point, dimension : Point) : Number {
			if (position.y === dimension.y - 1) return -1;
			return getIndex(new Point(position.x, position.y + 1), dimension);
		}
	}
}
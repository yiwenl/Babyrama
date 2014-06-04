/**
 * Licensed under the MIT License
 *
 * Copyright (c) 2010 Laurent Berthelot
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

	/**
	 * Organize a number of elements per page.
	 * Ex : Show X elements by page among N elements.
	 * @author Laurent Berthelot
	 */
	public class Pagination
	{
		//--------------------------------------------------------------------------
		//
		//  Public vars
		//
		//--------------------------------------------------------------------------
		/**
		 * Total number of elements to organize.
		 */
		public var nTotalElement : int = 0;
		/**
		 * Pointer to the first element of the current page.
		 */
		public var currentIndex : Number = 0;
		
		//--------------------------------------------------------------------------
		//
		//  Protected vars
		//
		//--------------------------------------------------------------------------
		/**
		 * @private
		 */	
		protected var _nElementByPage : int = 1;
		/**
		 * @private
		 */	
		protected var _loop : Boolean = false;
		/**
		 * @private
		 */	
		protected var _concat : Boolean = false;
		
		//--------------------------------------------------------------------------
		//
		//  Private vars
		//
		//--------------------------------------------------------------------------
		/**
		 * @private
		 */
		private var _nextIndex : Number = 0;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Create a new Pagination instance.
		 * @param	nElement		Number of elements.	
		 * @param	nElementByPage	Number of elements per page.
		 * @param	loop			Indicates if loop throw pages is activated (true) or not (false). 
		 * @param	concat			Indicates if a page must contains exactly nElementByPage (true) or not (false). 
		 */
		public function Pagination(nTotalElement:int = 0, nElementByPage:int = 1, loop:Boolean = false, concat:Boolean = false) {
			super();
			this.nTotalElement = nTotalElement;
			_nElementByPage = nElementByPage;
			_loop = loop;
			_concat = concat;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		/**
		 * Move the currentIndex pointer to the first item of next page.
		 */
		public function next() : void {
			if (currentIndex + _nElementByPage <= nTotalElement - 1) currentIndex += _nElementByPage;
				else if (_loop) currentIndex = _concat ? currentIndex + _nElementByPage - nTotalElement : 0;
		}
		
		/**
		 * Move the currentIndex pointer to the first item of the previous page.
		 */
		public function prev() : void {
			if (currentIndex - _nElementByPage >= 0) currentIndex -= _nElementByPage;
				else if (_loop) currentIndex = nTotalElement - (_concat ? _nElementByPage - currentIndex : nTotalElement % _nElementByPage);
		}
		
		/**
		 * Jump directly to a specific page.
		 */		
		public function goToPage(i:int):void {
			currentIndex = i * _nElementByPage;
		}
		
		/**
		 * Get the list elements' index belonging to the current page.
		 */
		public function get currentElements():Array {
			var _a:Array = new Array();
			for (var i:int = currentIndex; i < Math.min(currentIndex + _nElementByPage, nTotalElement); i++) _a.push(i);	
			var _l:int = _nElementByPage - _a.length;
			for (i = 0; i < _l && _concat && _a.length < _nElementByPage; i++) _a.push(i);
			return _a;
		}
		
		/**
		 *	Get the current page index.
		 */
		public function get currentPage():int {
			return Math.ceil(currentIndex / _nElementByPage);
		}
		
	}
}
/**
 * Licensed under the MIT License
 *
 * Copyright (c) 2006 Laurent BERTHELOT
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
	import flash.display.PixelSnapping;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextLineMetrics;
	
	/**
	 * @author Laurent BERTHELOT
	 */
	
	public class TextFieldUtils extends Object
	{
		
		public function TextFieldUtils() { }
		
		/**
		 * 
		 * @param	tf
		 * @param	search
		 * @param	startIndex
		 * @return
		 */
		public static function getInlineStringBoundaries(tf:TextField, search:String, startIndex:Number = 0):Rectangle {
			var _o:* = _getStringBoudaries(tf, search, startIndex);
			if (_o is Rectangle) return _o as Rectangle;
			return new Rectangle();
		}
		
		/**
		 * 
		 * @param	tf
		 * @param	search
		 * @param	startIndex
		 */
		public static function getMultilineStringBoundaries(tf:TextField, search:String, startIndex:Number = 0):/*Rectangle*/Array {
			var _o:* = _getStringBoudaries(tf, search, startIndex);
			if (_o is Array) return _o as Array;
			return [_o];
		}
		
		/**
		 * 
		 * @param	tf
		 * @param	lineIndex
		 * @return
		 */
		public static function getLineBoundaries(tf:TextField, lineIndex:Number = 0):Rectangle {
			var tlm:TextLineMetrics	= tf.getLineMetrics(lineIndex);
			var _recFirstChar:Rectangle = tf.getCharBoundaries(tf.getLineOffset(lineIndex));
			return new Rectangle(_recFirstChar.x, _recFirstChar.y, tlm.width, tlm.height);
		}
		
		/**
		 * 
		 * @param	tf
		 * @param	search
		 * @param	startIndex
		 * @return
		 */
		private static function _getStringBoudaries(tf:TextField, search:String, startIndex:Number = 0):* {
			if (search === null || search.length === 0) return new Rectangle();
			var text:String = StringUtils.trim(tf.text);
			if (search.length === 1) return tf.getCharBoundaries(text.indexOf(search, startIndex));
			var _indexStart:Number = text.indexOf(search, startIndex);
			if (_indexStart === -1) return new Rectangle();
			var _indexEnd:Number = _indexStart + search.length -1;
			var _lineStartIndex:int = tf.getLineIndexOfChar(_indexStart);
			var _lineEndIndex:int = tf.getLineIndexOfChar(_indexEnd);
			var _recStart:Rectangle = tf.getCharBoundaries(_indexStart);	
			var _recEnd:Rectangle = tf.getCharBoundaries(_indexEnd);
			if (_lineStartIndex === _lineEndIndex) {
				_recStart.width = _recEnd.x - _recStart.x + _recEnd.width;
				return _recStart;
			}
			var _aRec:/*Rectangle*/Array = new Array();
			for (var i:int = _lineStartIndex; i <= _lineEndIndex; i++) {
				switch (i) {
					case _lineStartIndex : _aRec.push(getInlineStringBoundaries(tf, search.substr(0, tf.getLineOffset(i) + tf.getLineLength(i) - _indexStart), _indexStart)); break;
					case _lineEndIndex : _aRec.push(getInlineStringBoundaries(tf, search.substr(tf.getLineOffset(i) - _indexEnd - 1), tf.getLineOffset(i))); break;
					default : _aRec.push(getLineBoundaries(tf, i)); break;
				}				
			}
			return _aRec;
		}
		
		/**
		 * 
		 * @param	tf
		 */
		public static function getAllWordsBoundaries(tf:TextField):/*Rectangle*/Array {
			var _sep:String = " ";
			var _aWords:Array = StringUtils.trim(tf.text).split(_sep);
			var _nbWord:Number = _aWords.length;
			var _startIndex:Number = 0;
			var _aWordsBoundaries:Array = new Array();
			for (var i:int = 0; i < _nbWord; i++) {
				var _word:String = _aWords[i];
				_aWordsBoundaries.push(getInlineStringBoundaries(tf, _word, _startIndex));
				_startIndex += _word.length + _sep.length;
			}
			return _aWordsBoundaries;
		}
		
		/**
		 * 
		 * @param	tf
		 */
		public static function getAllWordsBitmap(tf:TextField):/*Bitmap*/Array {
			var _aWordsBoundaries:Array = getAllWordsBoundaries(tf);
			var _nbWords:Number = _aWordsBoundaries.length;
			var _aWordsBitmap:Array = new Array();
			for (var i:int = 0; i < _nbWords; i++) {
				var _rec:Rectangle = _aWordsBoundaries[i];
				var _bitmap:Bitmap = new Bitmap(BitmapUtils.getRectangleBitmapData(tf, _rec), PixelSnapping.AUTO, true);
				_bitmap.x = _rec.x;
				_bitmap.y = _rec.y;
				_aWordsBitmap.push(_bitmap);
			}
			return _aWordsBitmap;
		}
		
	}
}

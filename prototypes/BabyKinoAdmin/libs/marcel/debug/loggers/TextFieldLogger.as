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
package marcel.debug.loggers
{
	import flash.text.TextField;
	import marcel.debug.loggers.ILogger;
	
	/**
	 * Class used to log messages to the a simple textfield instance.
	 * @author Alexandre Croiseaux
	 */
	public class TextFieldLogger implements ILogger
	{
		//--------------------------------------------------------------------------
		//
		//  Private vars
		//
		//--------------------------------------------------------------------------
		private var _debug:TextField;
		
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Constructs a new TextFieldLogger instance.
		 * @param	txt 	The textfield instance to write message in.
		 */
		public function TextFieldLogger(txt:TextField)
		{
			_debug = txt;
			_debug.multiline = true;
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		/**
		 * Logs a message
		 * @param	val		the object to log
		 * @param	callFunction	the classname of the caller object
		 * @param	level		the message level
		 */
		public function log(val:*, callFunction:String, level:int):void
		{
			_debug.multiline = true;
			
			var str:String = val;
			str = str.replace(/</g, "&lt;");
			str = str.replace(/\>/g, "&gt;");
			
			var colors:Array = [0, 0, 0x339900, 0xFF9900, 0xCC0000];
			if (level > 2) str = "<b>" + str + "</b>";
			str = "<font color=\"#" + colors[level].toString(16) + "\" face=\"Verdana\" size=\"10\">[" + callFunction + "] " + str + "</font><br>";
			
			_debug.htmlText = _debug.htmlText + str;
			_debug.scrollV = _debug.maxScrollV;
		}
		
		/**
		 * Check if the logger has its own dumper, or if the default dumper must be used
		 * @return	true if the logger has its own dumper, false otherwise
		 */
		public function hasDumper():Boolean { return false; }
	}
}
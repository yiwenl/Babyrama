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
	import marcel.debug.loggers.ILogger;
	
	/**
	 * Class used to log messages to the flash output panel.
	 * @author Alexandre Croiseaux
	 */
	public class TraceLogger implements ILogger
	{
		/**
		 * Logs a message
		 * @param	val		the object to log
		 * @param	callFunction	the classname of the caller object
		 * @param	level		the message level
		 */
		public function log(val:*, callFunction:String, level:int):void
		{
			// flashdeveleop output window colors
			var levels:Array = [1, 1, 1, 2, 3];
			trace(levels[level] + ":[" + callFunction + "] " + val);
		}
		
		/**
		 * Check if the logger has its own dumper, or if the default dumper must be used
		 * @return	true if the logger has its own dumper, false otherwise
		 */
		public function hasDumper():Boolean { return false; }
	}
}

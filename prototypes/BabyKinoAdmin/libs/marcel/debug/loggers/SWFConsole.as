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
	import flash.events.StatusEvent;
	import flash.net.LocalConnection;
	import marcel.debug.Logger;
	import marcel.debug.loggers.ILogger;
	
	/**
	 * Class used to log messages to the SWFConsole app.
	 * @author Alexandre Croiseaux
	 */
	public class SWFConsole implements ILogger
	{
		//--------------------------------------------------------------------------
		//
		//  Private vars
		//
		//--------------------------------------------------------------------------
		private var _available:Boolean;
		private var _lc:LocalConnection;
		private var _lcName:String;
		private var _lcMethod:String;
		private var _firstMsg:Boolean;
		
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Constructs a new SWFConsole instance.
		 */
		public function SWFConsole()
		{
			_available = true;
			_lcName = "_SWFConsole";
			_lcMethod = "addText";
			_lc = new LocalConnection();
			_lc.addEventListener(StatusEvent.STATUS, onStatus);
			_lc.send(_lcName, _lcMethod, "$$client$$New client connected : " + Logger.clientUri, 0, true, true, 12);
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		/**
		 * Check if the logger has its own dumper, or if the default dumper must be used
		 * @return	true if the logger has its own dumper, false otherwise
		 */
		public function hasDumper():Boolean { return false; }
		
		/**
		 * Logs a message
		 * @param	val		the object to log
		 * @param	callFunction	the classname of the caller object
		 * @param	level		the message level
		 */
		public function log(val:*, callFunction:String, level:int):void
		{
			print(val, level, callFunction);
		}
		
		/**
		 * Logs a message
		 * @param	val		the object to log
		 * @param	level	the message level
		 * @param	callFunction	the classname of the caller object
		 * @param	bold	should the message appear in bold
		 * @param	italic	should the message appear in italic
		 * @param	size	message text size
		 */
		public function print(val:*, level:int = 0, callFunction:String = "", bold:Boolean = false, italic:Boolean = false, size:uint = 12):void
		{
			// lc receiver function :
			// public function addText(str:String, color:uint = 0, bold:Boolean = false, italic:Boolean = false, size:uint = 12):void
			
			if (_available)
			{
				var colors:Array = [0, 0, 0x339900, 0xFF9900, 0xCC0000, 0x3366CC, 0x3366CC, 0x3366CC, 0x3366CC, 0];
				if (level == 3 || level == 4 || level == 7 || level == 8) bold = true;
				var str:String;
				if (callFunction != "") str = "[" + callFunction + "] " + val.toString();
				else str = val.toString();
				
				// LocalConnection messages limited to 40ko, so split str if too long. (keep security offset and using 30ko)
				while (str.length > 0)
				{
					var s:String = str.slice(0, 30000);
					str = str.slice(30000);
					_lc.send(_lcName, _lcMethod, s, colors[level], bold, italic, size);
				}
			}
		}
		
		/**
		 * Clears the SWFConsole from any message.
		 */
		public function clear():void { _lc.send(_lcName, _lcMethod, "$$clear$$"); }
		
		/**
		 * Indicates if the current swf file is connected to the SWFConsole
		 * @return	True if it's connected, false otherwise
		 */
		public function isAvailable():Boolean { return _available; }
		
		
		//--------------------------------------------------------------------------
		//
		//  Events
		//
		//--------------------------------------------------------------------------
		private function onStatus(evt:StatusEvent):void
		{
			_available = (evt.level == "status");
		}
	}
}

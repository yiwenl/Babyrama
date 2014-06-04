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
package marcel.debug
{
	import marcel.debug.dumpers.DefaultDumper;
	import marcel.debug.dumpers.IDumper;
	import marcel.debug.loggers.ILogger;
	import marcel.debug.LogLevel;
	import marcel.utils.ClassUtils;
	
	/**
	 * Entry point class for dispatching error messages to all connected ILoggers
	 * @author Alexandre Croiseaux
	 */
	public class Logger
	{
		//--------------------------------------------------------------------------
		//
		//  Public static vars
		//
		//--------------------------------------------------------------------------
		/**
		 * Indicates the URI of the flash client to send to loggers
		 */
		public static var clientUri:String = "-- default --";
		
		
		//--------------------------------------------------------------------------
		//
		//  Private static vars
		//
		//--------------------------------------------------------------------------
		private static var _loggers:Array = new Array();
		private static var _dumper:IDumper = new DefaultDumper();
		private static var _minLevel:int = 0;
		private static var _maxLevel:int = 10;
		
		
		//--------------------------------------------------------------------------
		//
		//  Public static methods
		//
		//--------------------------------------------------------------------------
		/**
		 * Indicates the minimum et maximum levels of messages to send to loggers.
		 * These values are specified by the Config class, using the levels specified in the site config XML
		 * @param	minLevel	minimum level of debugging messages
		 * @param	maxLevel	minimum level of debugging messages
		 */
		public static function setLevels(minLevel:int, maxLevel:int):void
		{
			_minLevel = minLevel;
			_maxLevel = maxLevel;
		}
		
		/**
		 * Send a message to all connected loggers
		 * @param	caller	the object sending the message (used to display class name)
		 * @param	val	value tu debug, parsed by the current IDumper
		 * @param	level	level of the message, a constant of the LogLevel class
		 */
		public static function log(caller:*, val:*, level:int = 1):void
		{
			var callFunction:String = (caller is String)?caller:ClassUtils.getClassName(caller);
			if (level >= _minLevel && level <= _maxLevel) sendToLoggers(val, callFunction, level);
		}
		
		/**
		 * Send a message to all connected loggers with level LogLevel.DEBUG
		 * @param	caller	the object sending the message (used to display class name)
		 * @param	val	value tu debug, parsed by the current IDumper
		 */
		public static function logd(caller:*, val:*):void { log (caller, val, LogLevel.DEBUG); }
		
		/**
		 * Send a message to all connected loggers with level LogLevel.INFO
		 * @param	caller	the object sending the message (used to display class name)
		 * @param	val	value tu debug, parsed by the current IDumper
		 */
		public static function logi(caller:*, val:*):void { log (caller, val, LogLevel.INFO); }
		
		/**
		 * Send a message to all connected loggers with level LogLevel.WARNING
		 * @param	caller	the object sending the message (used to display class name)
		 * @param	val	value tu debug, parsed by the current IDumper
		 */
		public static function logw(caller:*, val:*):void { log (caller, val, LogLevel.WARNING); }
		
		/**
		 * Send a message to all connected loggers with level LogLevel.ERROR
		 * @param	caller	the object sending the message (used to display class name)
		 * @param	val	value tu debug, parsed by the current IDumper
		 */
		public static function loge(caller:*, val:*):void { log (caller, val, LogLevel.ERROR); }
		
		
		/**
		 * Add a logger to the list of debug messages recievers.
		 * Loggers can be added by the Config class, by specifying them in the site config XML
		 * @param	ilog	a logger implementing the ILogger interface
		 */
		public static function addLogger(ilog:ILogger):void { _loggers.push(ilog); }
		
		/**
		 * Remove all connected loggers
		 */
		public static function clearLoggers():void { _loggers = new Array(); }
		
		/**
		 * Indicates the IDumper to use to represent object as string message.
		 * A DefaultDumper instance is used by default.
		 * This IDumper is only used if one of the connected loggers has no inner dumper
		 * @param	idump
		 */
		public static function setDumper(idump:IDumper):void { _dumper = idump; }
		
		/**
		 * Returns the current IDumper used to serialize objects as strings
		 * @return	an IDumper instance
		 */
		public static function getDumper():IDumper { return _dumper; }
		
		
		//--------------------------------------------------------------------------
		//
		//  Private static methods
		//
		//--------------------------------------------------------------------------
		public static function sendToLoggers(val:*, callFunction:String = "", level:int = 1):void
		{
			for each (var ilogger:ILogger in _loggers)
			{
				ilogger.log(ilogger.hasDumper() ? val : _dumper.dump(val), callFunction, level);
			}
		}
	}
}

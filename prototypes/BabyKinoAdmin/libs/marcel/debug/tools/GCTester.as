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
package marcel.debug.tools
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.net.LocalConnection;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	import marcel.debug.Logger;

	/**
	* @eventType flash.events.Event
	*/
	[Event(name = "onGarbageCollected", type = "flash.events.Event")]
	
	/**
	 * Tests an object for it's garbage collection
	 * @author Alexandre Croiseaux
	 */
	public final class GCTester extends EventDispatcher
	{
		//--------------------------------------------------------------------------
		//
		//  Private vars
		//
		//--------------------------------------------------------------------------
		private var _dict:Dictionary = new Dictionary(true);
		private var _timer:Timer = new Timer(checkTime);
		private var _lastTrace:String;
		
		private static var _testers:Dictionary = new Dictionary(true);
		
		
		//--------------------------------------------------------------------------
		//
		//  Public vars
		//
		//--------------------------------------------------------------------------
		/**
		 * Indicates if a debug message must be displayed each time an object is checked.
		 */
		public static var verbose:Boolean = false;
		/**
		 * Interval in milliseconds between objects checks.
		 */
		public static var checkTime:uint = 1000;
		
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Constructs a new GCTester instance and watch the collection of the argument object
		 * Use static method 'watch' for easier use.
		 * @param	obj	the object to watch
		 */
		public function GCTester(obj:Object):void
		{
			_dict[obj] = 1;
			_timer.addEventListener(TimerEvent.TIMER, onTimer);
			_timer.start();
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		/**
		 * Starts watching the specified object for garbage collection.
		 * @param	obj	the object to watch
		 * @return	the created GCTester instance
		 */
		public static function watch(obj:Object):GCTester
		{
			var gc:GCTester = new GCTester(obj);
			_testers[gc] = 1;
			return gc;
		}
		
		
		/**
		 * Forces the Garbage Collector to perform a full mark/sweep.
		 * !!! Uses the LocalConnection Hack, use only for debug purposes !!!
		 */
		public static function forceGC():void
		{
			// http://gskinner.com/blog/archives/2006/08/as3_resource_ma_2.html
			try {
			   new LocalConnection().connect("FORCE_GC");
			   new LocalConnection().connect("FORCE_GC");
			} catch (e:*) {}
			// the GC will perform a full mark/sweep on the second call.
			
			Logger.logw("GCTester", "Garbage Collector forced! ");
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Events
		//
		//--------------------------------------------------------------------------
		private function onTimer(event:TimerEvent):void
		{
			for (var i:Object in _dict)
			{
				_lastTrace = i.toString();
				if (verbose) Logger.logw(this, _lastTrace);
				return;
			}
			
			_timer.removeEventListener(TimerEvent.TIMER, onTimer);
			_timer.stop();
			dispatchEvent(new Event("onGarbageCollected"));
			delete(_testers[this]);
			
			Logger.logi(this, _lastTrace + " has been garbage collected.");
		}
	}
}

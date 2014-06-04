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
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import flash.display.Shape;
	
	/**
	 * Framer class used to repeat function calls at a specified framerate
	 * @author Alexandre Croiseaux
	 */
	public final class Framer
	{
		//--------------------------------------------------------------------------
		//
		//  Private vars
		//
		//--------------------------------------------------------------------------
		private var _callback:Function;
		private var _currentCount:uint;
		private var _repeatCount:uint;
		private var _frameDelay:uint;
		private var _running:Boolean;
		private var _enterFrameCount:uint;
		static private const _shape:Shape = new Shape();
		
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 * Constructs a new Framer object with the specified delay and repeatCount states.
		 * @param	callback	function to execute at each delay
		 * @param	frameDelay	The delay, in frames, between callback execution. (1 => one call per frame, 5 => one call each 5 frames)
		 * @param	repeatCount	The total number of times the framer is set to run.
		 */
		public function Framer(callback:Function, frameDelay:uint = 1, repeatCount:uint = 0)
		{
			_callback = callback;
			_running = false;
			_frameDelay = frameDelay;
			_repeatCount = repeatCount;
			reset();
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		/**
		 * Starts the framer, if it is not already running.
		 */
		public function start():void
		{
			if (!running)
			{
				_shape.addEventListener(Event.ENTER_FRAME, onEnterFrame, false, 0, true);
				_running = true;
			}
		}
		
		/**
		 * Stops the timer if running
		 */
		public function stop():void
		{
			if (running)
			{
				_shape.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				_running = false;
			}
		}
		
		/**
		 * Stops the timer, if it is running, and sets the currentCount property back to 0, like the reset button of a stopwatch.
		 */
		public function reset():void
		{
			stop();
			_currentCount = 0;
			_enterFrameCount = 0;
		}
		
		/**
		 * Modify the callback function immediately
		 * @param	func	function to execute at each delay
		 */
		public function setCallback(func:Function):void
		{
			_callback = func;
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Getters / setters
		//
		//--------------------------------------------------------------------------
		/**
		 * The total number of times the framer has fired since it started at zero.
		 */
		public function get currentCount():uint { return _currentCount; }
		
		/**
		 * The delay, in frames, between callback execution
		 */
		public function get frameDelay():uint { return _frameDelay; }
		
		/**
		 * Set the delay, in frames, between callback execution
		 * @param	delay	new delay in frames
		 */
		public function set frameDelay(delay:uint):void { _frameDelay = delay; }
		
		/**
		 * The timer's current state; true if the timer is running, otherwise false.
		 */
		public function get running():Boolean { return _running; }
		
		/**
		 * The total number of times the framer is set to run.
		 */
		public function get repeatCount():uint { return _repeatCount; }
		public function set repeatCount(repeat:uint):void { _repeatCount = repeat; }
		
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
		private function onEnterFrame(evt:Event):void
		{
			_enterFrameCount++;
			if (_enterFrameCount >= _frameDelay)
			{
				if (_callback != null) _callback.call(null);
				if (_currentCount >= _repeatCount && _repeatCount > 0) stop();
				else if (_enterFrameCount > 0) // in case reset & start were called in the callback, do not increment the _currentCount
				{
					_currentCount++;
				}
				_enterFrameCount = 0;
			}
		}
	}
}
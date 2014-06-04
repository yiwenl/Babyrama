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
	import flash.utils.Dictionary;
	
	/**
	 * DelayManager class used to call function or change object property with a delay
	 * @author Alexandre Croiseaux
	 */
	public final class DelayManager
	{
		static private var _ID_:uint = uint.MIN_VALUE;
		static private var _delayObjects:Dictionary = new Dictionary(true);
		
		/**
		 * Calls func(args) with frame delay
		 * @param	func	function to call
		 * @param	delay	waiting delay in frames
		 * @param	...args	arguments passed when calling the function
		 * @return	id of the created delay object, cancelable by calling DelayManager.clear(id)
		 */
		static public function create(func:Function, delay:uint, ...args:Array):uint
		{
			var counterId:uint = _ID_++;
			var o:DelayObject = new DelayObject(counterId, delay, func, args);
			_delayObjects["delayObject_" + counterId] = o;
			if (delay <= 0) o.execute();
			return counterId;
		}
		
		/**
		 * Change the property of an object with a frame delay
		 * @param	target object to change the property of
		 * @param	strProp	property to change
		 * @param	delay	waiting delay in frames
		 * @param	propVal	value to set property to
		 * @return	id of the created delay object, cancelable by calling DelayManager.clear(id)
		 */
		static public function createProp(target:*, prop:String, delay:uint, propValue:*):uint
		{
			var func:Function = function():void {target[prop] = propValue;};
			return create(func, delay);
		}
		
		/**
		 * Clears an active delay object with its id
		 * @param	idToClear id returned by DelayManager.create or DelayManager.createProp
		 * @return	true if removed successfully, false otherwise
		 */
		static public function clear(idToClear:uint):Boolean
		{
			var o:DelayObject = _delayObjects["delayObject_" + idToClear];
			if (o == null)
			{
				delete _delayObjects["delayObject_" + idToClear];
				return false;
			}
			o.kill();
			delete _delayObjects["delayObject_" + idToClear];
			return true;
		}
		
		/**
		 * Clear all active delay objects
		 */
		static public function clearAll():void
		{
			for(var key:String in _delayObjects)
			{
				_delayObjects[key].kill();
				delete _delayObjects[key];
			}
		}
	}
}

// Private class
import marcel.core.*;
import marcel.utils.*;
internal final class DelayObject
{
	private var _id:uint;
	private var _callback:Function;
	private var _args:Array;
	private var _framer:Framer;
	
	public function DelayObject(id:uint, delay:uint, callBack:Function, args:Array)
	{
		_id = id;
		_callback = callBack;
		_args = args;
		_framer = new Framer(execute, delay, 1);
		_framer.start();
	}
	
	public function execute():void
	{
		if (_callback != null) _callback.apply(null, _args);
		DelayManager.clear(_id);
		kill();
	}
	
	public function kill():void
	{
		_framer.stop();
	}
}
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
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.system.Capabilities;
	import flash.system.System;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.getTimer;
	import marcel.debug.Logger;
	import marcel.debug.loggers.TextFieldLogger;
	
	/**
	 * Class used to display FPS, Memory and FP version
	 * @author Alexandre Croiseaux
	 */
	public class DebugInfos extends Sprite
	{
		//--------------------------------------------------------------------------
		//
		//  Private vars
		//
		//--------------------------------------------------------------------------
		private var _text:TextField;
		private var _mem:Number = 0;
		private var _maxMem:Number = 0;
		private var _time:uint;
		private var _fps:uint;
		private var _small:Boolean;
		private var _log:TextField;
		
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		public function DebugInfos()
		{
			_text = new TextField();
			_text.height = 17;
			_text.autoSize = "left";
			var tf:TextFormat = new TextFormat("Verdana", "10", 0xFFFFFF);
			_text.defaultTextFormat = tf;
			_text.selectable = false;
			_text.y = -1;
			addChild(_text);
			
			_log = new TextField();
			_log.width = 800;
			_log.height = 500;
			_log.background = true;
			_log.backgroundColor = 0xEEEEEE;
			_log.y = 15;
			_log.visible = false;
			addChild(_log);
			Logger.addLogger(new TextFieldLogger(_log));
			
			addEventListener(Event.ENTER_FRAME, update);
			_text.addEventListener(MouseEvent.CLICK, onClick);
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
		private function onClick(e:MouseEvent):void
		{
			if (!_small && !_log.visible) _log.visible = true;
			else if (!_small && _log.visible)
			{
				_small = true;
				_log.visible = false;
				removeEventListener(Event.ENTER_FRAME, update);
				update(null, true);
			}
			else
			{
				_small = false;
				addEventListener(Event.ENTER_FRAME, update);
				update(null, true);
			}
		}
		
		private function update(e:Event, force:Boolean = false):void
		{
			var t:uint = getTimer();
			if (t > _time + 1000 || force)
			{
				_mem = Number(System.totalMemory / 1024 / 1024);
				if (_mem > _maxMem) _maxMem = _mem;
				
				var str:String = " + ";
				if (!_small)
				{
					str = "FPS: " + _fps;
					if (stage) str += "/" + stage.frameRate;
					str += "  MEM: " + _mem.toFixed(2);
					str += "/" + _maxMem.toFixed(2) + "mb";
					str += "  " + Capabilities.version + (Capabilities.isDebugger ? " DEBUG" : "");
					str += "  X ";
				}
					
				_text.htmlText = str;
				graphics.clear();
				graphics.beginFill(0x575757);
				graphics.drawRect(0, 0, _text.width, 15);
				
				if (!_small)
				{
					_time = t;
					_fps = 0;
				}
				
				x = stage.stageWidth - _text.width;
				_log.x = -(_log.width - _text.width);
			}
			else _fps++;
		}
	}
}
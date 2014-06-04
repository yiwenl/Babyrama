/*
 * Author: Richard Lord
 * Copyright (c) Big Room Ventures Ltd. 2007
 * Version: 1.0.3
 *
 * Licence Agreement
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

package marcel.utils
{
	import flash.events.KeyboardEvent;
	import flash.events.Event;
	import flash.display.DisplayObject;
	import flash.ui.Keyboard;
	import flash.utils.ByteArray;
	
	/**
	 * <p>Games often need to get the current state of various keys in order to respond to user input.
	 * This is not the same as responding to key down and key up events, but is rather a case of discovering
	 * if a particular key is currently pressed.</p>
	 *
	 * <p>In Actionscript 2 this was a simple matter of calling Key.isDown() with the appropriate key code.
	 * But in Actionscript 3 Key.isDown no longer exists and the only intrinsic way to react to the keyboard
	 * is via the keyUp and keyDown events.</p>
	 *
	 * <p>The KeyPoll class rectifies this. It has isDown and isUp methods, each taking a key code as a
	 * parameter and returning a Boolean.</p>
	 */
	public class Key
	{

		private var states:ByteArray;
		private var dispObj:DisplayObject;
		
		/**
		 * Constructor
		 *
		 * @param displayObj a display object on which to test listen for keyboard events. To catch all key events use the stage.
		 */
		public function Key( displayObj:DisplayObject )
		{
			states = new ByteArray();
			states.writeUnsignedInt( 0 );
			states.writeUnsignedInt( 0 );
			states.writeUnsignedInt( 0 );
			states.writeUnsignedInt( 0 );
			states.writeUnsignedInt( 0 );
			states.writeUnsignedInt( 0 );
			states.writeUnsignedInt( 0 );
			states.writeUnsignedInt( 0 );
			dispObj = displayObj;
			dispObj.addEventListener( KeyboardEvent.KEY_DOWN, keyDownListener, false, 0, true );
			dispObj.addEventListener( KeyboardEvent.KEY_UP, keyUpListener, false, 0, true );
			dispObj.addEventListener( Event.ACTIVATE, activateListener, false, 0, true );
			dispObj.addEventListener( Event.DEACTIVATE, deactivateListener, false, 0, true );
		}
		
		private function keyDownListener( ev:KeyboardEvent ):void
		{
			states[ ev.keyCode >>> 3 ] |= 1 << (ev.keyCode & 7);
		}
		
		private function keyUpListener( ev:KeyboardEvent ):void
		{
			states[ ev.keyCode >>> 3 ] &= ~(1 << (ev.keyCode & 7));
		}
		
		private function activateListener( ev:Event ):void
		{
			for( var i:int = 0; i < 32; ++i )
			{
				states[ i ] = 0;
			}
		}

		private function deactivateListener( ev:Event ):void
		{
			for( var i:int = 0; i < 32; ++i )
			{
				states[ i ] = 0;
			}
		}
		
		/**
		 * To test whether a key is down.
		 *
		 * @param keyCode code for the key to test.
		 *
		 * @return true if the key is down, false otherwise.
		 *
		 * @see isUp
		 */
		public function isDown( keyCode:uint ):Boolean
		{
			return ( states[ keyCode >>> 3 ] & (1 << (keyCode & 7)) ) != 0;
		}
		
		/**
		 * To test whether a key is up.
		 *
		 * @param keyCode code for the key to test.
		 *
		 * @return true if the key is up, false otherwise.
		 *
		 * @see isDown
		 */
		public function isUp( keyCode:uint ):Boolean
		{
			return ( states[ keyCode >>> 3 ] & (1 << (keyCode & 7)) ) == 0;
		}
		
		
		public static const BACKSPACE:uint = Keyboard.BACKSPACE;
		public static const TAB:uint = Keyboard.TAB;
		public static const MIDDLE:uint = 12;
		public static const ENTER:uint = Keyboard.ENTER;
		public static const SHIFT:uint = Keyboard.SHIFT;
		public static const CONTROL:uint = Keyboard.CONTROL;
		public static const PAUSE:uint = 19;
		public static const BREAK:uint = 19;
		public static const CAPS_LOCK:uint = Keyboard.CAPS_LOCK;
		public static const ESCAPE:uint = Keyboard.ESCAPE;
		public static const SPACEBAR:uint = Keyboard.SPACE;
		public static const PAGE_UP:uint = Keyboard.PAGE_UP;
		public static const PAGE_DOWN:uint = Keyboard.PAGE_DOWN;
		public static const END:uint = Keyboard.END;
		public static const HOME:uint = Keyboard.HOME;
		public static const LEFT_ARROW:uint = Keyboard.LEFT;
		public static const UP_ARROW:uint = Keyboard.UP;
		public static const RIGHT_ARROW:uint = Keyboard.RIGHT;
		public static const DOWN_ARROW:uint = Keyboard.DOWN;
		public static const INSERT:uint = Keyboard.INSERT;
		public static const DELETE:uint = Keyboard.DELETE;
		public static const NUM_0:uint = 48;
		public static const NUM_1:uint = 49;
		public static const NUM_2:uint = 50;
		public static const NUM_3:uint = 51;
		public static const NUM_4:uint = 52;
		public static const NUM_5:uint = 53;
		public static const NUM_6:uint = 54;
		public static const NUM_7:uint = 55;
		public static const NUM_8:uint = 56;
		public static const NUM_9:uint = 57;
		public static const A:uint = 65;
		public static const B:uint = 66;
		public static const C:uint = 67;
		public static const D:uint = 68;
		public static const E:uint = 69;
		public static const F:uint = 70;
		public static const G:uint = 71;
		public static const H:uint = 72;
		public static const I:uint = 73;
		public static const J:uint = 74;
		public static const K:uint = 75;
		public static const L:uint = 76;
		public static const M:uint = 77;
		public static const N:uint = 78;
		public static const O:uint = 79;
		public static const P:uint = 80;
		public static const Q:uint = 81;
		public static const R:uint = 82;
		public static const S:uint = 83;
		public static const T:uint = 84;
		public static const U:uint = 85;
		public static const V:uint = 86;
		public static const W:uint = 87;
		public static const X:uint = 88;
		public static const Y:uint = 89;
		public static const Z:uint = 90;
		public static const LEFT_WINDOWS:uint = 91;
		public static const RIGHT_WINDOWS:uint = 92;
		public static const MENU:uint = 93;
		public static const NUMPAD_0:uint = Keyboard.NUMPAD_0;
		public static const NUMPAD_1:uint = Keyboard.NUMPAD_1;
		public static const NUMPAD_2:uint = Keyboard.NUMPAD_2;
		public static const NUMPAD_3:uint = Keyboard.NUMPAD_3;
		public static const NUMPAD_4:uint = Keyboard.NUMPAD_4;
		public static const NUMPAD_5:uint = Keyboard.NUMPAD_5;
		public static const NUMPAD_6:uint = Keyboard.NUMPAD_6;
		public static const NUMPAD_7:uint = Keyboard.NUMPAD_7;
		public static const NUMPAD_8:uint = Keyboard.NUMPAD_8;
		public static const NUMPAD_9:uint = Keyboard.NUMPAD_9;
		public static const NUMPAD_MULTIPLY:uint = Keyboard.NUMPAD_MULTIPLY;
		public static const NUMPAD_ADD:uint = Keyboard.NUMPAD_ADD;
		public static const NUMPAD_SUBTRACT:uint = Keyboard.NUMPAD_SUBTRACT;
		public static const NUMPAD_DECIMAL:uint = Keyboard.NUMPAD_DECIMAL;
		public static const NUMPAD_DIVIDE:uint = Keyboard.NUMPAD_DIVIDE;
		public static const F1:uint = Keyboard.F1;
		public static const F2:uint = Keyboard.F2;
		public static const F3:uint = Keyboard.F3;
		public static const F4:uint = Keyboard.F4;
		public static const F5:uint = Keyboard.F5;
		public static const F6:uint = Keyboard.F6;
		public static const F7:uint = Keyboard.F7;
		public static const F8:uint = Keyboard.F8;
		public static const F9:uint = Keyboard.F9;
		public static const F10:uint = Keyboard.F10;
		public static const F11:uint = Keyboard.F11;
		public static const F12:uint = Keyboard.F12;
		public static const F13:uint = Keyboard.F13;
		public static const F14:uint = Keyboard.F14;
		public static const F15:uint = Keyboard.F15;
		public static const NUM_LOCK:uint = 144;
		public static const SCROLL_LOCK:uint = 145;
		public static const SEMICOLON:uint = 186;
		public static const COLON:uint = 186;
		public static const EQUALS:uint = 187;
		public static const PLUS:uint = 187;
		public static const COMMA:uint = 188;
		public static const LEFT_ANGLE:uint = 188;
		public static const MINUS:uint = 189;
		public static const UNDERSCORE:uint = 189;
		public static const PERIOD:uint = 190;
		public static const RIGHT_ANGLE:uint = 190;
		public static const FORWARD_SLASH:uint = 191;
		public static const QUESTION_MARK:uint = 191;
		public static const BACKQUOTE:uint = 192;
		public static const TILDE:uint = 192;
		public static const LEFT_BRACKET:uint = 219;
		public static const BACKSLASH:uint = 220;
		public static const BAR:uint = 220;
		public static const RIGHT_BRACKET:uint = 221;
		public static const QUOTE:uint = 222;
	}
}
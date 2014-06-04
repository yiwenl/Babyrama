/**
 * Licensed under the MIT License
 *
 * Copyright (c) 2007 Roger Braunstein | Your Majesty
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
	import flash.system.Capabilities;
	
	/**
	 * Utilities for inspecting the stack at a given moment in the virtual machine's execution.
	 * If you use this code, please retain this author tag:
	 * @author Roger Braunstein | Your Majesty | 2007
	 */
	public class Stack
	{
		/**
		 * Get the entire stack trace as a single string.
		 */
		public static function getRawStackTrace():String
		{
			var e:Error = new Error();
			return e.getStackTrace();
		}
		
		/**
		 * Returns the entire stack trace as an array.
		 * @param ignoreLevels	ignore the top N entries in the stack trace. For utilities that use this method,
		 * 						you can trim off both the call to this method, and any intermediary calls which
		 * 						aren't part of your target code.
		 */
		public static function getStackEntries(ignoreLevels:int = 0):Array
		{
			var stackTrace:String = getRawStackTrace();
			var stack:Array = stackTrace.split(/^\s*at\s+/m);
			stack.splice(0, ignoreLevels + 1);
			return stack;
		}
		
		/**
		 * Parse a String stack entry into an object with lots of parameters (listed in the regexp with angular brackets).
		 */
		public static function getPartsFromStackTraceEntry(stackEntry:String):Object
		{
			return stackEntry.match(/(?P<package>[\w\d\.]+)::(?P<classname>[\w\d\.\:]*?)(?P<isStatic>\$?)\/((?P<scope>[\w\d\.\:]+)::)?(?P<method>[\w\d]+\(\))(\[(?P<filename>[\w\d\\\/\.]+):(?P<line>\d+)\])?/);
		}
		
		/**
		 * Reformat a long stack trace entry into a simplified one with only the package, classname, and method (if possible).
		 */
		public static function getSimplifiedStackTraceEntry(stackEntry:String):String
		{
			var o:Object = getPartsFromStackTraceEntry(stackEntry);
			return (o)?(o['package'] + '.' + o['classname'] + '::' + o['method']):stackEntry;
		}
		
		/**
		 * Retrieve informations about the debug method caller object 
		 */
		public static function getDebugCaller():String
		{
			if (!Capabilities.isDebugger) return "";
			
			var stackLine:String = Stack.getStackEntries(4).shift().split("()").shift();
			stackLine = stackLine.split("::").pop();
			
			var result:Array = stackLine.split("/");
			result[0] = result[0].replace("$", "");
			if (result != null) return (result.length == 1)?result[0] + ".constructor()":result[0] + "." + result[1] + "()";
			return null;
		}
	}
}
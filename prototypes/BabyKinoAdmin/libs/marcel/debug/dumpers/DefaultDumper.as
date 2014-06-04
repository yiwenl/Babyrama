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
package marcel.debug.dumpers
{
	import marcel.utils.ClassUtils;
	
	/**
	 * Default dumper class used to serialize any object into a string depending on its type.
	 * This class is used as default dumper by the Logger class
	 * @author Alexandre Croiseaux
	 * @see marcel.debug.Logger
	 */
	public class DefaultDumper implements IDumper
	{		
		//--------------------------------------------------------------------------
		//
		//  Private vars
		//
		//--------------------------------------------------------------------------
		/**
		 * Sets the maximum deep depth of the serializer
		 */
		public static var MAX_DEPTH:Number = 5;
		
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		/**
		 * Serialize any object into a string depending on its type. This method is recursive.
		 * @param	obj	Object to dump
		 * @param	depth	Recursive depth
		 * @return	obj as a string readable representation
		 */
		public function dump(obj:*, depth:uint = 0):String
		{
			if (obj == undefined) return "undefined";
			if (obj == null) return "null";
			if (isPrimitive(obj)) return obj.toString();
			
			var strResult:String = "";
			var type:String = getType(obj);
			
			if (depth <= MAX_DEPTH)
			{
				var indent:String = getIndent(depth + 1);
				strResult += type;
				switch(type)
				{
					case "Array": for (var i:uint = 0; i < obj.length; i++) strResult += "\n" + indent + "[" + i + "] " + dump( obj[i], (depth+1) ); break;
					case "Dictionary": for (var dictKey:Object in obj) strResult += "\n" + indent + "[" + dictKey + "] " + dump( obj[dictKey], (depth+1) ); break;
					case "XML":
					case "XMLNode":
					case "XMLList":
						strResult += "\n" + indent +  obj.toXMLString(); break;
					case "Object":
						for (var key:String in obj) strResult += "\n" + indent + "{" + key + "} " + dump( obj[key], (depth+1) );
						break;
					default: strResult = getInstanceWithProps(obj, indent, (depth+1));
				}
			}
			return strResult;
		}
		
		/**
		 * Test if an object is of type String, Boolean, Number, int, uint
		 * @param	o	the object to test
		 * @return	True if the object has a primitive type, false otherwise
		 */
		public function isPrimitive(o:*):Boolean
		{
			return (o is String || o is Boolean || o is Number || o is int || o is uint);
		}
		
		/**
		 * Returns the class name of the object's type
		 * @param	o	the object to get classname from
		 * @return	the classname of the object
		 */
		public function getType(o:*):String
		{
			return ClassUtils.getClassName(o);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
		private function getIndent(n:uint):String
		{
			var result:String = "";
			for (var i:uint = 0; i < n; i++) result += "      ";
			return result;
		}
		
		private function getInstanceWithProps(obj:*, indent:String, depth:uint):String
		{
			var props:Array = ClassUtils.getPublicProperties(obj);
			var str:String = obj.toString();
			for (var i:uint = 0; i < props.length; i++) 
			{
				str += "\n" + indent + "{" + props[i] + "} " + dump(obj[props[i]], depth);
			}
			
			return str;
		}
	}
}
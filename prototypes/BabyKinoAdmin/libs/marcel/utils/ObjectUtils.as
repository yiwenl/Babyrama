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
	import flash.utils.ByteArray;
	
	/**
	* 	Class that contains static utility methods for manipulating and working
	*	with Objects.
	* @author Alexandre Croiseaux
	*/
	public class ObjectUtils
	{
		/**
		 * Performs a deep copy of an object, using a ByteArray
		 * @param	sourceObj	the object to duplicate
		 * @return	the duplicated object
		 */
		public static function duplicate(sourceObj:*):*
		{
			var copier:ByteArray = new ByteArray();
			copier.writeObject(sourceObj);
			copier.position = 0;
			return copier.readObject();
		}
		
		/**
		 * Merge 2 objects in a single one; if the same key is found in the 2 objects, the valur of the second object will overwrite the first
		 * @param	obj1	the first object to merge
		 * @param	obj2	the second object to merge
		 * @return	a object with obj1 and obj2 merged
		 */
		public static function merge(obj1:Object, obj2:Object):Object
		{
			var key:String;
			var oResult:Object = {};
			
			for (key in obj1) oResult[key] = obj1[key];
			for (key in obj2) oResult[key] = obj2[key];
			
			return oResult;
		}
		
		/**
		 * Copy the attributes of a given XML node as object's properties
		 * @param	obj			the object on which to copy the properties
		 * @param	xml			the XML containing the attributes to copy
		 * @return	the object passed as first argument
		 */
		public static function copyAttributes(obj:*, xml:XML, checkTypes:Boolean = false):Object
		{
			if (checkTypes) var aPublicProps:Array = ClassUtils.getPublicProperties(obj, true, true);
			for each (var attr:XML in xml.attributes())
			{
				var attrName:String = attr.name().toString();
				if (checkTypes && ArrayUtils.contains(aPublicProps, attrName))
				{
					var ClassProp:Class = ClassUtils.getPropertyType(obj, attrName);
					obj[attrName] = ClassProp(attr.toString());
				}
				else obj[attrName] = attr.toString();
			}
			return obj;
		}
		
		/**
		 * Indicates if an object contains data
		 * @param	o	the object to test
		 * @return	true if the object is empty, false otherwise
		 */
		public static function isEmpty(o:Object):Boolean
		{
			for (var prop:String in o) return false;
			return true;
		}
		
		/**
		 * Returns the value if not null, or the defaultvalue otherwise
		 * @param	value			The value to test and return if not null
		 * @param	defaultValue	the value that is returned if the first parameter is null
		 * @return	the value if not null, or the defaultvalue otherwise
		 */
		public static function getValueWithDefault(value:*, defaultValue:* = ""):*
		{
			if (value) return value;
			return defaultValue;
		}
	}
}

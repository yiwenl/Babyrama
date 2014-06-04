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
package marcel.utils {
	import flash.utils.*;

	/**
	 * 	Class that contains static utility methods for manipulating and working
	*	with Classes.
	* @author Alexandre Croiseaux
	* @see	flash.utils.getDefinitionByName
	* @see	flash.utils.getQualifiedClassName
	* @see	flash.utils.getQualifiedSuperclassName
	* @see	flash.utils.describeType
	*/
	public class ClassUtils
	{
		/**
		 * Returns the class name of any object
		 * @param	instance	the object to get the classname from
		 * @return	the object class name
		 */
		public static function getClassName(instance:*):String
		{
			var fullClassName:String = getQualifiedClassName(instance);
			var ar:Array = fullClassName.split("::");
			return ar.length > 1 ? ar[1] : ar[0];
		}
		
		/**
		 * Returns the package name of any object
		 * @param	instance	the object to get the classname from
		 * @return	the object package name
		 */
		public static function getPackageName(instance:*):String
		{
			var fullClassName:String = getQualifiedClassName(instance);
			var ar:Array = fullClassName.split("::");
			return ar.length > 1 ? ar[0] : "";
		}
		
		/**
		 * Returns the Class of any object
		 * @param	instance	the object to get the Class from
		 * @return	a Class instance corresponding to the class of the object
		 */
		public static function getClass(instance:*):Class
		{
			return getDefinitionByName(getQualifiedClassName(instance)) as Class;
		}
		
		/**
		 * Returns the names of the public properties of an instance.
		 * @param	instance		the instance to get properties from.
		 * @param	includeAccessors	indicates if the instance accessors (getters/setters) must be included.
		 * @param	includeParentAccessors	indicates if the instance's parent classes accessors (getters/setters) must be included.
		 * @param	includeWriteOnlyAccessors	indicates if the instance's classes accessors (getters/setters) with write acess only must be included.
		 * @return	an Array containing property names.
		 */
		public static function getPublicProperties(instance:*, includeAccessors:Boolean = true, includeParentAccessors:Boolean = false, includeWriteOnlyAccessors:Boolean = false):Array
		{
			var i:uint;
			var fullClassName:String = getQualifiedClassName(instance);
			var xml:XML = describeType(instance);
			
			// variables
			var variables:Array = [];
			for each(var node:XML in xml.variable)
			{
				variables.push(node.@name.toString());
			}
			
			// accessors
			var accessors:Array = [];
			if (includeAccessors)
			{
				var nodes:XMLList = includeParentAccessors ? xml.accessor : xml.accessor.(@declaredBy == fullClassName);
				for (i = 0; i < nodes.length(); i++)
				{
					if(!includeWriteOnlyAccessors && nodes[i].attribute("access").toString() != "writeonly") accessors.push(nodes[i].attribute("name").toString());
				}
			}
			
			// return
			return variables.concat(accessors);
		}
		
		/**
		 * Returns the type of a object's property, as a Class instance.
		 * @param	obj	the object to get the property from.
		 * @param	propertyName	the name of the property to get the Class from
		 * @return	a Class instance corresponding to the class of the object's property
		 */
		public static function getPropertyType(obj:*, propertyName:String):Class
		{
			var desc:XML = describeType((obj is Class)? obj : ClassUtils.getClass(obj));
			
			var prop_xml:XMLList = desc.factory.variable.(@name == propertyName);
			if (prop_xml.length() == 0)
			{
				prop_xml = desc.factory.accessor.(@name == propertyName);
			}
			
			return getDefinitionByName(prop_xml.@type.toString()) as Class;
		}
		
		/**
		 * Returns whether the passed in Class object implements
		 * the given interface.
		 *
		 * @param clazz the class to check for an implemented interface
		 * @param interfaze the interface that the clazz argument should implement
		 *
		 * @return true if the clazz object implements the given interface; false if not
		 */
		public static function isImplementationOf(clazz : Class, interfaze : Class) : Boolean {
			var result : Boolean;
			if (clazz == null) {
				result = false;
			} else {
				var classDescription : XML = describeType(clazz);
				result = (classDescription.factory.implementsInterface.(@type == getQualifiedClassName(interfaze)).length() != 0);
			}
			return result;
		}

		/**
		 * Constructs a instance of the specified class, using the specified array as contructor parameters.
		 * @param	classRef	The Class to instanciate.
		 * @param	args		An array representing the constructor parameters.
		 * @return	a instance of the specified class.
		 */
		public static function buildInstance(classRef:Class, args:Array = null):*
		{
			if (args == null) return new classRef();
			switch (args.length)
			{
				case 0:		return new classRef();
				case 1:		return new classRef(args[0]);
				case 2:		return new classRef(args[0], args[1]);
				case 3:		return new classRef(args[0], args[1], args[2]);
				case 4:		return new classRef(args[0], args[1], args[2], args[3]);
				case 5:		return new classRef(args[0], args[1], args[2], args[3], args[4]);
				case 6:		return new classRef(args[0], args[1], args[2], args[3], args[4], args[5]);
				case 7:		return new classRef(args[0], args[1], args[2], args[3], args[4], args[5], args[6]);
				case 8:		return new classRef(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7]);
				case 9:		return new classRef(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8]);
				case 10:	return new classRef(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9]);
				default:	throw "Arguments count exceeds acceptable value.";
			}
		}
	}
}

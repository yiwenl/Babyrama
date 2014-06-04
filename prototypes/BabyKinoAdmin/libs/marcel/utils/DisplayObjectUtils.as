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
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Transform;
	import flash.utils.*;

	/**
	* 	Class that contains static utility methods for manipulating and working with DisplayObjects
	* @author Alexandre Croiseaux
	*/
	public class DisplayObjectUtils
	{
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		/**
		 * Lets the user drag the specified sprite. The sprite remains draggable until mouse
		 *  is released in the sprite.stage scope, or until
		 *  another sprite is made draggable. Only one sprite is draggable at a time.
		 *
		 * @param sprite	The sprite to turn into a draggable object
		 * @param lockCenter	Specifies whether the draggable sprite is locked to the center of
		 *                            the mouse position (true), or locked to the point where the user first clicked the
		 *                            sprite (false).
		 * @param bounds	Value relative to the coordinates of the Sprite's parent that specify a constraint
		 *                            rectangle for the Sprite.
		 * @param moveHandler	The function called when the object is moved
		 * @param stopDragHandler	The function called when the object is not being drag anymore
		 */
		public static function setDraggable(sprite:Sprite, lockCenter:Boolean = false, bounds:Rectangle = null, moveHandler:Function = null, stopDragHandler:Function = null):Function
		{
			var stopDragFunction:Function = function():void
			{
				sprite.stopDrag();
				sprite.stage.removeEventListener(MouseEvent.MOUSE_UP, stopDragFunction);
				if (stopDragHandler != null) stopDragHandler();
				if (moveHandler != null) sprite.stage.removeEventListener(MouseEvent.MOUSE_MOVE, moveHandler);
			}
			var dragFunction:Function = function():void
			{
				sprite.startDrag(lockCenter, bounds);
				sprite.stage.addEventListener(MouseEvent.MOUSE_UP, stopDragFunction);
				if (moveHandler != null) sprite.stage.addEventListener(MouseEvent.MOUSE_MOVE, moveHandler);
			}
			
			if (sprite.stage) sprite.addEventListener(MouseEvent.MOUSE_DOWN, dragFunction);
			else sprite.addEventListener(Event.ADDED_TO_STAGE, function():void { sprite.addEventListener(MouseEvent.MOUSE_DOWN, dragFunction); } );
			
			return dragFunction;
		}
		
		/**
		 * Returns a array of all display object children of a DisplayObjectContainer
		 * @param	displayObj	the source container to parse
		 * @param	recursiveMode	use recursive mode if one of the children is a DisplayObjectContainer
		 * @return	an array containing children display objects
		 */
		public static function getChildren(displayObj:DisplayObjectContainer, recursiveMode:Boolean = false, type:Class = null):Array
		{
			var children:Array = new Array();
			var nb:int = displayObj.numChildren;
			for (var i:int = 0; i < nb; i++)
			{
				try
				{
					var d:DisplayObject = displayObj.getChildAt(i);
					if (type == null || d is type) children.push(d);
					if (recursiveMode && d is DisplayObjectContainer)
					{
						var dChildren:Array = getChildren(d as DisplayObjectContainer, recursiveMode, type);
						children = children.concat(dChildren);
					}
				}
				catch (e:Error) { /*security error*/ }
			}
			return children;
		}
		
		/**
		 * Returns a XML tree representation of all display object children of a DisplayObjectContainer
		 * @param	displayObj	the source container to parse
		 * @param	recursiveMode	use recursive mode if one of the children is a DisplayObjectContainer
		 * @return	an XML tree representation of children display objects
		 */
		public static function getChildrenTree(displayObj:DisplayObjectContainer, recursiveMode:Boolean = false):XML
		{
			var x:XML = getDisplayObjectNode(displayObj);
			var nb:int = displayObj.numChildren;
			for (var i:int = 0; i < nb; i++)
			{
				var d:DisplayObject = displayObj.getChildAt(i);
				if (recursiveMode && d is DisplayObjectContainer)
				{
					x.appendChild(getChildrenTree(d as DisplayObjectContainer, recursiveMode));
				}
				else x.appendChild(getDisplayObjectNode(d));
			}
			return x;
		}
		
		/**
		 * Adds a DisplayObject to the specified DisplayObjectContainer, and applies the initProps to the DisplayObject.
		 * @param	container	the DisplayObjectContainer
		 * @param	child		the DisplayObject to add
		 * @param	initProps	An object with key/values which will be applied the specified child
		 * @return	the added DisplayObject instance.
		 */
		public static function addChildTo(container:DisplayObjectContainer, child:DisplayObject, initProps:Object = null):DisplayObject
		{
			if (initProps)
			{
				for (var prop:String in initProps) child[prop] = initProps[prop];
			}
			return container.addChild(child);
		}
		
		/**
		 * Converts a point object from one display object coordinates to another one display object coordinates.
		 * @param	containerFrom	The container to convert coordinates from.
		 * @param	containerTo	The container to convert coordinates to.
		 * @param	origin		On optional offset to apply in the source container coordinates.
		 * @return	a converted Point instance
		 */
		public static function localToLocal(containerFrom:DisplayObject, containerTo:DisplayObject, origin:Point = null):Point
		{
			var point:Point = origin ? origin : new Point();
			point = containerFrom.localToGlobal(point);
			point = containerTo.globalToLocal(point);
			return point;
		}
		
		/**
		 * Order depth of multiple Displayobject by swap
		 * @param	parent DisplayObjectContainer where are clips
		 * @param	clips array of DisplayObject
		 */
		public static function orderDepths(parent:DisplayObjectContainer, clips:Array):void
		{
			for (var i:int = 1; i < clips.length; i++)
			{
				var c1:DisplayObject = clips[i - 1];
				var c2:DisplayObject = clips[i];
				if (parent.getChildIndex(c1) > parent.getChildIndex(c2))
				{
					parent.swapChildren(c1, c2);
					i = 0;
				}
			}
		}
		
		/**
		 * Brings the target to the front of the displayList
		 * @param : target
		 */
		public static function bringToFront(target:DisplayObject):void {
			target.parent.setChildIndex(target, target.parent.numChildren -1);
		}
		
		/**
		 * Send the target to the bottom of the displayList
		 * @param : target
		 */
		public static function sendToBack(target:DisplayObject):void {
			target.parent.setChildIndex(target, 0);
		}
		
		/**
		 * Checks if a DisplayObjectContainer contains a specified child.
		 * @param	container	the container to search into.
		 * @param	child		the child displayObject to search.
		 * @param	recursiveMode	use recursive mode if one of the children is a DisplayObjectContainer.
		 * @return	true if the container contains the child, false otherwise.
		 */
		public static function containsChild(container:DisplayObjectContainer, child:DisplayObject, recursiveMode:Boolean = false):Boolean
		{
			var children:Array = getChildren(container, recursiveMode);
			for (var i:int = 0; i < children.length; i++)
			{
				if (children[i] == child) return true;
			}
			return false;
		}
		
		/**
		 * Creates a rectangle mask and applies it to the specified displayObject
		 * @param	maskedTarget	The display Object to mask
		 * @param	rect			The Size of the mask
		 * @return
		 */
		public static function mask(maskedTarget:DisplayObject, rect:Rectangle):Shape
		{
			var s:Shape = new Shape();
			s.graphics.beginFill(0x00FF00, 1);
			s.graphics.drawRect(0, 0, rect.width, rect.height);
			s.x = rect.x;
			s.y = rect.y;
			maskedTarget.mask = s;
			return s;
		}
		
		/**
		 * Creates a 2D Matrix with the specified DisplayObject translation and rotation, and applies it to its transform property
		 * when you want to cancel the visual effect produced by a 3D projection
		 * @param	target	The DisplayObject on which the projection should be canceled
		 */
		public static function cancelPerspectiveProjection(target : DisplayObject) : void {
			var t : Transform = target.transform;
			var m : Matrix = new Matrix();
			m.translate(target.x, target.y);
			m.rotate(target.rotation);
			t.matrix = m;
			target.transform = t;
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
		private static function getDisplayObjectNode(displayObj:DisplayObject):XML
		{
			var x:XML = <displayobject/>;
			x.@type = getQualifiedClassName(displayObj);
			x.@extendsClass = getQualifiedSuperclassName(displayObj);
			x.@name = displayObj.name;
			return x;
		}
	}
}
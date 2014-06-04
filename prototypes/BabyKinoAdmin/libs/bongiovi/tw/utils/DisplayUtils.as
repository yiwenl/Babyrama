//AS3///////////////////////////////////////////////////////////////////////////
// 
// Copyright 2009 
// 
////////////////////////////////////////////////////////////////////////////////

package bongiovi.tw.utils {

	/**
	 *	Class description.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author LIN Yi-Wen
	 *	@since  2009-08-21
	 */
	import bongiovi.tw.tracer.TraceCenter;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class DisplayUtils {
		
		public static function createShape(width:Number, height:Number, color:Number=0x000000, alpha:Number=1) : Shape {
			var shape:Shape	= new Shape();
			shape.graphics.beginFill(color, alpha);
			shape.graphics.drawRect(0, 0, width, height);
			shape.graphics.endFill();
			return shape;
		}
		
		
		public static function createSprite(width:Number, height:Number, color:Number=0x000000, alpha:Number=1, registerPoint:String="tl") : Sprite {
			var xRegister:Number	= 0;
			var yRegister:Number	= 0;
			if(registerPoint.indexOf("l")>-1)	xRegister	= 0;
			if(registerPoint.indexOf("c")>-1)	xRegister	= width/2;
			if(registerPoint.indexOf("r")>-1)	xRegister	= width;
			if(registerPoint.indexOf("t")>-1)	yRegister	= 0;
			if(registerPoint.indexOf("m")>-1)	yRegister	= height/2;
			if(registerPoint.indexOf("b")>-1)	yRegister	= height;
			
			var sprite:Sprite	= new Sprite();
			sprite.graphics.beginFill(color, alpha);
			sprite.graphics.drawRect(xRegister, yRegister, width, height);
			sprite.graphics.endFill();
			return sprite;
		}
		
		
		public static function setScale(mc:DisplayObject, scale:Number) : void {
			mc.scaleX	= mc.scaleY	= scale;
		}
		
		
		public static function setPosition(target:DisplayObject, tx:*, ty:Number=0) : void {
			if(tx is Point) {
				target.x = tx.x;
				target.y = tx.y;
			}else {
				target.x = Number(tx);
				target.y = ty;
			}
		}
		
		
		public static function debugPos(target:DisplayObject) : void {
			target.addEventListener(MouseEvent.MOUSE_DOWN, __onMouseDownHandler);
			target.addEventListener(MouseEvent.MOUSE_UP, __onMouseUpHandler);
		}
		
		
		private static function __onMouseUpHandler(e:MouseEvent) : void {
			var spTarget:Sprite = (e.currentTarget as Sprite);
			spTarget.stopDrag();
			tracethis(spTarget.x + "/" + spTarget.y);
		}
		
		
		private static function __onMouseDownHandler(e:MouseEvent) : void {
			var spTarget:Sprite = (e.currentTarget as Sprite);
			spTarget.startDrag();
		}
		
		
		//--------------------------------------
		//  TRACER
		//--------------------------------------

		private static function tracethis(str:*, level:int=0) : void {
			TraceCenter.addChannel("DisplayUtils");
			TraceCenter.tracethis("DisplayUtils_"+level+"_"+str);
			//trace("# TestUI		#  " + str);
		}
	}

}
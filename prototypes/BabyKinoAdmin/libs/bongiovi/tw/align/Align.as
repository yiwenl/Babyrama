//AS3///////////////////////////////////////////////////////////////////////////
// 
// Copyright 2010 
// 
////////////////////////////////////////////////////////////////////////////////

package bongiovi.tw.align {

	/**
	 *	Class description.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 10.0
	 *
	 *	@author bongiovi
	 *	@since  2010-09-07
	 */

	import bongiovi.tw.tracer.TraceCenter;
	
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class Align {
	
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
	
		/**
		 *	@constructor
		 */
		public function Align(){}
		
		
		public static function matchTo(doObject:DisplayObject, doTarget:DisplayObject, type:String, autoPosition:Boolean=true) : Rectangle {
			var rect:Rectangle;
			
			if(doTarget is Stage) {
				var stage:Stage = doTarget as Stage;
				rect = new Rectangle(0, 0, stage.stageWidth, stage.stageHeight);
			}else {
				rect = new Rectangle(doTarget.x, doTarget.y, doTarget.width, doTarget.height);
			}
			
			return matchToRect(doObject, rect, type, autoPosition);
		}
		
		
		public static function matchToRect(doObject:DisplayObject, rectTarget:Rectangle, type:String, autoPosition:Boolean=true) : Rectangle {
			var rectReturn:Rectangle = new Rectangle(doObject.x, doObject.y, doObject.width, doObject.height);
			
			if(type.indexOf("w")>-1){
				rectReturn.x = rectTarget.x;
				rectReturn.width = rectTarget.width;
				if(autoPosition) {
					doObject.x = rectTarget.x;
					doObject.width = rectTarget.width;
				}
			} 
			
			if(type.indexOf("h")>-1){
				rectReturn.y = rectTarget.y;
				rectReturn.height = rectTarget.height;
				if(autoPosition) {
					doObject.y = rectTarget.y;
					doObject.height = rectTarget.height;
				}
			}
			
			return rectReturn;
		}
		
		
		public static function distributeTo(aObjects:Array, doTarget:DisplayObject, type:String) : void {
			var rect:Rectangle;
			if(doTarget is Stage) {
				var stage:Stage = doTarget as Stage;
				rect = new Rectangle(0, 0, stage.stageWidth, stage.stageHeight);
			}else {
				rect = new Rectangle(doTarget.x, doTarget.y, doTarget.width, doTarget.height);
			}
			
			distributeToRectangle(aObjects, rect, type);
		}
		
		
		public static function distributeToRectangle(aObjects:Array, rectTarget:Rectangle, type:String) : void {
			var i : int = 0;
			var doObject : DisplayObject;
			var totalItems : int = aObjects.length;
			var totalWidth : Number = 0;
			var totalHeight : Number = 0;
			for each( doObject in aObjects) {
				totalWidth += doObject.width;
				totalHeight += doObject.height;
			}
			var intervalx : Number = (rectTarget.width - totalWidth) / (totalItems - 1);
			var intervaly : Number = (rectTarget.height - totalHeight) / (totalItems - 1);
			var offset:Point = new Point(rectTarget.x, rectTarget.y);
			if(type.indexOf("x") > -1) distribute(aObjects, intervalx, "x", offset);
			if(type.indexOf("y") > -1) distribute(aObjects, intervaly, "y", offset);
		}
		
		
		public static function distribute(aObjects:Array, interval:Number, type:String, offset:Point=null) : void {
			var i : int = 0;
			var doObject : DisplayObject;
			var temp : Number = 0;
			
			if(type.indexOf("x")>-1) {
				do {
					doObject = aObjects[i];
					doObject.x = temp;
					if(offset!=null) doObject.x += offset.x;
					temp = temp + doObject.width + interval;
					i++;
				}while(aObjects[i] !=null);
			}
			
			temp = 0;
			i = 0;
			if(type.indexOf("y")>-1) {
				do {
					doObject = aObjects[i];
					doObject.y = temp;
					if(offset!=null) doObject.y += offset.y;
					temp = temp + doObject.height + interval;
					i++;
				}while(aObjects[i] !=null);
			}
		}
		
		
		public static function alignTo(doSource:DisplayObject, doTarget:DisplayObject, type:String, offset:Point=null, autoPosition:Boolean=true) : Point {
			var w:Number = (doTarget is Stage) ? (doTarget as Stage).stageWidth : doTarget.width;
			var h:Number = (doTarget is Stage) ? (doTarget as Stage).stageHeight : doTarget.height;
			var p:Point = alignToRectangle(doSource, new Rectangle(doTarget.x, doTarget.y, w, h), type, offset, autoPosition);
			return p;
		}
		
		
		public static function alignToRectangle(doSource:DisplayObject, rectTarget:Rectangle, type:String, offset:Point=null, autoPosition:Boolean=true) : Point {
			var rect:Rectangle = doSource.getBounds(doSource);
			var p:Point = rectAlign(rect, rectTarget, type, offset);
			if(autoPosition) {
				doSource.x = p.x;
				doSource.y = p.y;
			}
			return p;
		}
		
		
		public static function rectAlign(rectSource:Rectangle, rectTarget:Rectangle, type:String, offset:Point=null) : Point {
			var p:Point = new Point;
			
			if(type.indexOf("l")>-1)	p.x = 0;
			if(type.indexOf("c")>-1)	p.x = (rectTarget.width - rectSource.width) * .5;
			if(type.indexOf("r")>-1)	p.x = rectTarget.width - rectSource.width;
			if(type.indexOf("t")>-1) 	p.y = 0;
			if(type.indexOf("m")>-1) 	p.y = (rectTarget.height - rectSource.height) * .5;
			if(type.indexOf("b")>-1)	p.y = rectTarget.height - rectSource.height;
			
			p.x += rectTarget.x;
			p.y += rectTarget.y;
			if(offset!=null) {
				p.x += offset.x;
				p.y += offset.y;
			}
			
			return p;
		}
		
		

		//--------------------------------------
		//  TRACER
		//--------------------------------------

		private function tracethis(str:*, level:int=0) : void {
			TraceCenter.addChannel("Align");
			TraceCenter.tracethis("Align_"+level+"_"+str);
			//trace("# Align		#  " + str);
		}
		
	}

}
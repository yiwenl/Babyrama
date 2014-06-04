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
	 *	@since  2009-09-18
	 */
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.geom.Rectangle;	

	public class BitmapUtils {
	
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
	
		/**
		 *	@constructor
		 */
		public function BitmapUtils(){
		}

		
		public static function getMinRectFromDisplayObject(doTarget:DisplayObject, color:uint=0x00000000) : Rectangle {
			var bmpd:BitmapData = new BitmapData(doTarget.width, doTarget.height, true, 0x00000000);
			bmpd.draw(doTarget);
			var rect:Rectangle = bmpd.getColorBoundsRect(0xFFFFFFFF, color, false);
			return rect;
		}
		
		
		public static function getBitmapFromDisplayObject(doTarget:DisplayObject, isTransparent:Boolean=true, defaultColor:uint=0x00000000) : BitmapData {
			var bmpd:BitmapData = new BitmapData(doTarget.width+2, doTarget.height+2, isTransparent, defaultColor);
			bmpd.draw(doTarget, null, null, null, null, true);
			return bmpd;
		}
	}

}
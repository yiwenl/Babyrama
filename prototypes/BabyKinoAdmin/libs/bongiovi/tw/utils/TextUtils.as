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
	 *	@author bongiovi
	 *	@since  2009-03-23
	 */
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;	

	public class TextUtils {
	
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
	
		/**
		 *	@constructor
		 */
		public function TextUtils(){

		}


		static public function formatText(target:TextField, e:Object, beginIndex:Number=-1, endIndex:Number=-1) : void {
			var tf:TextFormat		= target.getTextFormat();
			for (var p:String in e){
				if(p in tf){
					tf[p]		 = e[p];
				}		
			}
			
			target.setTextFormat(tf, beginIndex, endIndex);
		}
		
		
		static public function createTextField(width:Number, e:Object, embedFonts:Boolean=true, selectable:Boolean=false) : TextField {
			var tf:TextField			= new TextField();
			var tformat:TextFormat		= new TextFormat();
			
			tf.width					= width;
			
			for (var p:String in e){
				if(p in tformat){
					tformat[p]		 = e[p];
				}		
			}
			
			/*tf.setTextFormat(tformat);*/
			tf.defaultTextFormat	= tformat;
			tf.embedFonts	= embedFonts;
			tf.selectable	= selectable;
			tf.autoSize		= "left";
			tf.multiline	= true;
			tf.wordWrap		= true;
			
			return tf;
		}
		
		
		public static function getWordsArray(tf:TextField) : Array {
			var rnAry:Array	= [];
			
			for (var i:int = 0; i < tf.text.length; i++){
				rnAry.push(tf.text.substring(i, i+1));
			}
			
			return rnAry;
		}
		
		
		public static function getWordsBoundaries(tf:TextField) : Array {
			var rnAry:Array	= [];
			
			for (var i:int = 0; i < tf.text.length; i++){
				rnAry.push(tf.getCharBoundaries(i));
			}
			
			return rnAry;
		}
		
		
		public static function getAllWordsBourdaries(tf:TextField) : Array {
			var aWordsBoundaries:Array	= getWordsBoundaries(tf);
			var nTotalWords:Number	= aWordsBoundaries.length;
			var rnAry:Array = [];
			
			for (var i:int = 0; i < nTotalWords; i++){
				var rect:Rectangle	= aWordsBoundaries[i];
				var bmpd:BitmapData	= BitmapUtils.displayObjectRectangleToBitmapData(tf, rect, true )
				rnAry.push({rect:rect, bmpd:bmpd});
			}
			
			return rnAry;
		}
		
		//--------------------------------------
		//  TRACER
		//--------------------------------------

		private static function tracethis(str:*, level:int=0) : void {
			trace("# TextUtils		#  " + str);
		}
		
	}

}
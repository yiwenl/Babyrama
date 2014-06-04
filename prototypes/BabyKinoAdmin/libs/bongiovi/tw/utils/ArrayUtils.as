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
	 *	@since  2009-08-26
	 */

	
	
	public class ArrayUtils {
	
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
	
		/**
		 *	@constructor
		 */
		public function ArrayUtils(){}
		
		public static function shuffle(ary:Array) : Array {
			var resultArray:Array	= ary.concat();
			
			for (var i:int = 0; i < resultArray.length; i++){
				var tmp:* = resultArray[i];
				var randomNum:Number	= Math.floor(Math.random() * resultArray.length);
				resultArray[i]	= resultArray[randomNum];
				resultArray[randomNum] = tmp;
			}
			
			return resultArray;
		}
		
		
		public static function removeDuplicateItems(ary:Array) : Array {
			var returnArray:Array	= [];
			
			for (var i:int = 0; i < ary.length; i++){
				if(returnArray.indexOf(ary[i]) == -1)	returnArray.push(ary[i]);
			}
			
			return returnArray;
		}
	}

}

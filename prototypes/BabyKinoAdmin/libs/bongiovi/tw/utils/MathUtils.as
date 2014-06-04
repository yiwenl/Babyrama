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
	 *	@since  2009-01-05
	 */
	
	public class MathUtils  {
	
		static public function getRandom(start:Number, end:Number, isInt:Boolean=false) : Number {
			var n:Number	= start + Math.random()*(end-start);
			if(isInt)	n	= Math.floor(n);
			
			return n;
		}
		
		
		static public function getDirection() : Number {
			var n:Number	= Math.floor(Math.random()*2)*2-1;
			return n;
		}
		
	}

}

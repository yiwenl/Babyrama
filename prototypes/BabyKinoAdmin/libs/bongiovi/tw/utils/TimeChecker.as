//AS3///////////////////////////////////////////////////////////////////////////
// 
// Copyright 2010 
// 
////////////////////////////////////////////////////////////////////////////////

package bongiovi.tw.utils {

	/**
	 *	Class description.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 10.0
	 *
	 *	@author bongiovi
	 *	@since  2010-10-05
	 */

	import bongiovi.tw.tracer.TraceCenter;
	
	import flash.utils.getTimer;
	
	public class TimeChecker {
	
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		private static var __startTime 			: Number=0;
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
	
		/**
		 *	@constructor
		 */
		public function TimeChecker(){}
		
		
		public static function start() : void {
			__startTime = getTimer();
		}
		
		
		public static function check(isReset:Boolean=false) : Number {
			var duration:Number = getTimer() - __startTime;
			if(isReset) __startTime = getTimer();
			return duration;
		}
		
		
		public static function checkFunction(f:Function, param:Array, times:int=1000) : Number {
			var duration:Number = getTimer();
			var i : int=0;
			
			for(i=0; i<times; i++ ) {
				f.apply(f, param);
			}
			
			duration = (getTimer() - duration) / times;
			
			return duration; 
		}

		//--------------------------------------
		//  TRACER
		//--------------------------------------

		private static function tracethis(str:*, level:int=0) : void {
			TraceCenter.addChannel("TimeChecker");
			TraceCenter.tracethis("TimeChecker_"+level+"_"+str);
			//trace("# TimeChecker		#  " + str);
		}
		
	}

}

//AS3///////////////////////////////////////////////////////////////////////////
// 
// Copyright 2011 
// 
////////////////////////////////////////////////////////////////////////////////

package bongiovi.tw.scheduler {

	/**
	 *	Class description.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 10.0
	 *
	 *	@author bongiovi
	 *	@since  2011-01-03
	 */

	import bongiovi.tw.tracer.TraceCenter;
	
	import flash.events.EventDispatcher;
	import flash.utils.getTimer;
	
	public class SchedulerTask extends EventDispatcher {
	
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		public var scope 						: *;
		public var id 							: String = "";
		public var func 						: Function;
		public var params 						: Array = [];
		public var delay 						: Number;
		public var startTime 					: Number;
		public var currTime 					: Number;
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
	
		/**
		 *	@constructor
		 */
		public function SchedulerTask(id:String, scope:*, func:Function, para:Array=null, delay:Number=0){
			TraceCenter.addChannel("SchedulerTask");
			this.id = id;
			this.scope = scope;
			this.func = func;
			this.params = para == null ? [] : para;
			this.delay = delay*1000;
			
			startTime = getTimer();
		}
		
		
		public function update() : Number {
			currTime = getTimer();
			return currTime;
		}


		//--------------------------------------
		//  TRACER
		//--------------------------------------

		private function tracethis(str:*, level:int=0) : void {
			TraceCenter.tracethis("SchedulerTask_"+level+"_"+str);
			//trace("# SchedulerTask		#  " + str);
		}
		
	}

}

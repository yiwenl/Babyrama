//AS3///////////////////////////////////////////////////////////////////////////
// 
// Copyright 2010 
// 
////////////////////////////////////////////////////////////////////////////////

package bongiovi.tw.kuler  {

	/**
	 *	Event subclass description.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author bongiovi
	 *	@since  2010-10-03
	 */

	import flash.events.Event;

	public class KulerEvent extends Event {
	
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		public static const ON_COLOR 			: String = "onColor";
		
		private var __colors 					: Array;
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
	
		/**
		 *	@constructor
		 */
		public function KulerEvent(sType:String, colors:Array){
			super(sType);
			__colors = colors;
		}
		
		
		public function getColors() : Array {	return __colors;	}
	}
}

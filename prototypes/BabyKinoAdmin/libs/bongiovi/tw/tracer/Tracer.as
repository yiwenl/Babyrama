//AS3///////////////////////////////////////////////////////////////////////////
// 
// Copyright 2008 
// 
////////////////////////////////////////////////////////////////////////////////

package bongiovi.tw.tracer {

	/**
	 *	Class description.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author bongiovi
	 *	@since  2008-12-20
	 */

	public class Tracer {
	
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
	
		/**
		 *	@constructor
		 */
		public function Tracer(){

		}

		
		static public function warn(str:*) : void {
			Logger.tracethis(str, TracerEvent.WARN);
		}
		
		
		static public function info(str:*) : void {
			Logger.tracethis(str, TracerEvent.INFO);
		}
		
		
		static public function fatal(str:*) : void {
			Logger.tracethis(str, TracerEvent.FATAL);
		}
		
		
		static public function debug(str:*) : void {
			Logger.tracethis(str, TracerEvent.DEBUG);
		}
		
		
		static public function error(str:*) : void {
			Logger.tracethis(str, TracerEvent.ERROR);
		}
		
	}

}

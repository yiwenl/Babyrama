//AS3///////////////////////////////////////////////////////////////////////////
// 
// Copyright 2009 
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
	 *	@since  2009-01-08
	 */
	import bongiovi.tw.tracer.Tracer;
	
	import flash.utils.getTimer;	

	public class TraceCenter {
	
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		static private var __channels 					: Array = new Array();
		static public var isDebug 						: Boolean = true;
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
	

		static public function addChannel(channel:String) : void {
			__channels.push(channel);
		}
		
		
		static public function removeChannel(channel:String) : void {
			if(__channels.indexOf(channel)< 0)			return;		//	Error, no such channel
			__channels.splice(__channels.indexOf(channel), 1);
		}
		
		
		static public function tracethis(str:String ) : void {
			if(!isDebug)	return;
			var msg:Array		= str.split("_");
			
			if(__checkChannel(msg[0])){
				var time:String	= __getDate().toString();
				var message:String = time + " " + msg[0] + "	: ";
				for( var i:int=2; i<msg.length; i++){
					message += msg[i];
					message += "_";
				}
				
				message	= message.substring(0, message.length-1);
				switch (msg[1]){
					default :
					case "0" :
						Tracer.debug( message);
					break;
					case "1" :
						Tracer.warn( message);
					break;
					case "2" :
						Tracer.fatal( message);
					break;
					case "3" :
						Tracer.info( message);
					break;
				}
			}
		}
		
		
		static private function __getDate() : String {
			var subT:uint = getTimer();
			var subMs:String = ("000").substr(0, 3-String(subT%1000).length)+String(subT%1000);
			var subS:String = ("00").substr(0, 2-String(Math.floor(subT/1000)%60).length)+String(Math.floor(subT/1000)%60);
			var subM:String = ("000").substr(0, 3-String(Math.floor(subT/60000)).length)+String(Math.floor(subT/60000));
			return subM+"'"+subS+"'"+subMs;
		}
 
		
		static private function __checkChannel(channel:String) : Boolean {
			if(__channels.indexOf(channel)<0){
				return false;
			}else{
				return true;
			}
		}

	}

}

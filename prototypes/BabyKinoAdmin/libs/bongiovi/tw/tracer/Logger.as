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
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.XMLSocket;	

	public class Logger {
	
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		private static const _hostname 			: String = "localhost";
		private static const _port 				: Number = 4445;
		
		static private var _socket 				: XMLSocket;
		static private var _instance			: Logger;
		static private var _xmlMessage 			: String = "<showMessage key=\"{MSG_TYPE}\"/> ";
		
		private var _isOn 						: Boolean;
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
	
		/**
		 *	@constructor
		 */
		public function Logger(){
			init();
		}

		/**
		 *	@private
		 *	
		 *	Initialize
		 *	
		 */
		private function init() : void {
			_socket = new XMLSocket();
			_isOn	= true;
			
			builtListeners();
			_socket.connect( _hostname , _port );
			_socket.send( "<clear/>\n" );
		}
		

		/**
		 *	@private
		 *	
		 *	Built Listeners
		 *	
		 */
		private function builtListeners() : void {
			_socket.addEventListener( Event.CONNECT , onConnect );
			_socket.addEventListener( IOErrorEvent.IO_ERROR , onError );
			_socket.addEventListener( SecurityErrorEvent.SECURITY_ERROR , onError );
		}
		
		
		/**
		 *	@public
		 *	
		 *	Send Message to socket
		 *	
		 */
		public function sendToSocket(str:String) : void {
			if(!_isOn)		return;
			_socket.send( str +  "\n");
		}
		
		
		/**
		 *	@public
		 *	
		 *	Trace Message
		 *	
		 */
		static public function tracethis(str:*, type:String) : void {
			var exp:RegExp		= /{MSG_TYPE}/;
			var msg:String		= _xmlMessage.replace(exp, type);
			msg += str;
			
			Logger.getInstance().sendToSocket(msg);
		}
		
		
		/**
		 *	@public
		 *	
		 *	Singleton
		 *	
		 */
		static public function getInstance() : Logger{
			if(_instance == null)	_instance = new Logger();
			
			return _instance;
		}
		
		
		private function onConnect(e:Event) : void {
			_isOn	= true;
			
		}
		
		
		private function onError(e:Event) : void {
			_isOn	= false;
		}
		
	}

}

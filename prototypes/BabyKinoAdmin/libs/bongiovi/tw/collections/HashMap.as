//AS3///////////////////////////////////////////////////////////////////////////
// 
// Copyright 2008 
// 
////////////////////////////////////////////////////////////////////////////////

package bongiovi.tw.collections {

	/**
	 *	Class description.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author bongiovi
	 *	@since  2008-12-25
	 */
	import flash.utils.Dictionary;				

	public class HashMap {
	
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		protected var _dKey 					: Dictionary;
		protected var _dValue 					: Dictionary;
		protected var _count 					: Number;
		private var __toTrace 					: Boolean;
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
	
		/**
		 *	@constructor
		 */
		public function HashMap(toTrace:Boolean=false){
			__toTrace	= toTrace;
			
			tracethis("Activated");
			
			__init();
		}


		/**
		 *	@private
		 *	Initialize
		 */
		private function __init() : void {
			_dKey		= new Dictionary(true);
			_dValue		= new Dictionary(true);
			_count		= 0;
		}

		
		/**
		 *	@private
		 *	@para key
		 *	@para value
		 *	
		 *	Insert a new node
		 */
		public function put(key:*, value:*) : void {
			if(key == null){
				tracethis("Error: Key is null");
				return;
			}
			
			if(_haveKey(key))	remove(key);
			
			_count++;
			_dKey[key]		= value;
			
			var count:Number	= _dValue[value] > 0 ? _dValue[value] +1 : 1;
			_dValue[value]		= count;
		}
		
		
		public function get(key:*) : * {
			return _dKey[key];
		}
		
		
		protected function _haveKey(key:*) : Boolean {
			return _dKey[ key ] != null;
		}
		
		
		public function remove(key:*) : void {
			if(!_haveKey(key))		return;
			
			var value:*		= _dKey[key];
			
			if(_dValue[value] > 1){
				_dValue[value] = _dValue[value]--;
			}else {
				delete _dValue[value];
			}
			
			delete _dKey[key];
			_count--;
		}
		
		
		public function size() : Number {
			return _count;
		}
		
		
		public function getKeys() : Array {
			var a : Array = new Array();
			for ( var key : * in _dKey ) a.push( key );
			return a;
		}


		public function getValues() : Array {
			var a : Array = new Array();
			for each ( var value : * in _dKey ) a.push( value );
			return a;
		}
		
		
		//--------------------------------------
		//  TRACER
		//--------------------------------------

		private function tracethis(str:*) : void {
			if(!__toTrace)		return;
			
			trace("# Hashmap			#  "+str);
		}
		
	}

}

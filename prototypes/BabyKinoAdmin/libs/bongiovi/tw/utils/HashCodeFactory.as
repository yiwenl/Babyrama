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
	 *	@since  2009-08-21
	 */
	import flash.utils.Dictionary;				

	public class HashCodeFactory {
	
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		private static var __nKey 				: Number = 0;
		protected static const _oHashTable 		: Dictionary = new Dictionary( true );
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
		
		
		static public function getKey ( o : * ) : String {
			if( !hasKey ( o ) )
				_oHashTable[ o ] = getNextKey ();
			
			return _oHashTable[ o ] as String;
		}
		
		
		static public function hasKey ( o : * ) : Boolean {
			return _oHashTable[ o ] != null;
		}
		
		
		static public function getNextKey () : String {
			return "KEY" + __nKey++;
		}
		
		
		static public function previewNextKey () : String {
			return "KEY" + __nKey;
		}
	}

}

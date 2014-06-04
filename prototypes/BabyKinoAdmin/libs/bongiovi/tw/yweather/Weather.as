//AS3///////////////////////////////////////////////////////////////////////////
// 
// Copyright 2010 
// 
////////////////////////////////////////////////////////////////////////////////

package bongiovi.tw.yweather  {

	/**
	 *	Class description.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 10.0
	 *
	 *	@author bongiovi
	 *	@since  2010-10-18
	 */
	
	
	public class Weather {
	
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		public var city 						: String;
		public var country 						: String;
		public var tempature					: Number;
		
		public var units_temperature 			: String;
		public var units_distance 				: String;
		public var units_pressure 				: String;
		public var units_speed 					: String;
		
		public var wind_chill 					: Number;
		public var wind_direction 				: Number;
		public var wind_speed 					: Number;
		
		public var atmosphere_humid 			: Number;
		public var atmosphere_visiblity 		: Number;
		public var atmosphere_pressure 			: Number;
		public var atmosphere_rising 			: Number;
		
		public var astronomy_sunrise 			: String;
		public var astronomy_sunset 			: String;
		
		public var condition					: String;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
	
		/**
		 *	@constructor
		 */
		public function Weather(){}
		
	}

}

//AS3///////////////////////////////////////////////////////////////////////////
// 
// Copyright 2010 
// 
////////////////////////////////////////////////////////////////////////////////

package bongiovi.tw.yweather  {

	/**
	 *	Event subclass description.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author bongiovi
	 *	@since  2010-10-18
	 */

	import flash.events.Event;

	public class YahooWeatherEvent extends Event {
	
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		public static const ON_WEATHER 			: String = "onWeather";
		
		private var __weather					: Weather;
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
	
		/**
		 *	@constructor
		 */
		public function YahooWeatherEvent(sType:String, weather:Weather){
			super(sType);
			__weather = weather;
		}
		
		public function getWeather() : Weather {	return __weather;	}
	}
}

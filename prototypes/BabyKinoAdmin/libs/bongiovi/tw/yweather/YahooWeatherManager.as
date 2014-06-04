//AS3///////////////////////////////////////////////////////////////////////////
// 
// Copyright 2010 
// 
////////////////////////////////////////////////////////////////////////////////

package bongiovi.tw.yweather  {

	/**
	 *	Singleton description.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author bongiovi
	 *	@since  2010-10-18
	 */
	
	import bongiovi.tw.tracer.TraceCenter;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	public class YahooWeatherManager extends EventDispatcher{
	
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		private static var _instance			: YahooWeatherManager;
		public static const NAMESPACE_YAHOO		: String = "http://where.yahooapis.com/v1/schema.rng";
		public static const NAMESPACE_YAHOO_WEATHER		: String = "http://xml.weather.yahoo.com/ns/rss/1.0";
		
		public static const WOEID_QRY_STR		: String = "http://query.yahooapis.com/v1/public/yql?q=select * from geo.places where text=\"";
		public static const GEOMOJO_QRY_STR		: String = "http://www.geomojo.org/cgi-bin/reversegeocoder.cgi?";
		public static const WEATHER_QRY_STR		: String = "http://weather.yahooapis.com/forecastrss?w=";
		
		public static const FLICKR_API			: String = "84434a6eba291355874007d8c35dbff4";
		public static const FLICKR_QRY_STR		: String = "http://api.flickr.com/services/rest/?method=flickr.places.findByLatLon&accuracy=6&api_key=";
		
		public var yahoo						: Namespace = new Namespace(NAMESPACE_YAHOO);
		public var yweather						: Namespace = new Namespace(NAMESPACE_YAHOO_WEATHER);
		//--------------------------------------
		//  SINGLETON CONSTRUCTION
		//--------------------------------------
	
		public function YahooWeatherManager(access:ConstructorAccess) : void {	TraceCenter.addChannel("YahooWeatherManager");	}
	
		public static function getInstance() : YahooWeatherManager {
			if(_instance == null)	_instance = new YahooWeatherManager(new ConstructorAccess());
			
			return _instance;
		}
		
		
		public function getWeatherByCity(cityName:String) : void {
			var url:String = WOEID_QRY_STR + cityName + '"&format=xml';
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, __onGetIDByCity);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, __onError);
			urlLoader.load(new URLRequest(url));
		}
		
		
		private function __onGetIDByCity(e:Event) : void {
			var xml:XML = XML(e.currentTarget.data);
			getWeatherByID(Number(xml.results.yahoo::place[0].yahoo::woeid));
		}
		
		
		public function getWeatherByLatLong(lat:Number, long:Number) : void {
			var url:String = FLICKR_QRY_STR + FLICKR_API + "&lat="+lat + "&lon="+long;
//			tracethis("lat:" + lat + ", long:" + long);
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, __onGetIDByLatLong);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, __onError);
			urlLoader.load(new URLRequest(url));
		}

		
		private function __onGetIDByLatLong(e:Event) : void {
			getWeatherByID(Number(XML(e.currentTarget.data).places.place[0].@woeid));
		}
		
		
		public function getWeatherByID(id:int) : void {
			var url:String = WEATHER_QRY_STR + id + "&u=c";
			tracethis("URL:" + url);
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, __onWeatherHandler);
			urlLoader.load(new URLRequest(url));
		}
		
		
		private function __onWeatherHandler(e:Event) : void {
			var xml:XML = XML(e.currentTarget.data);
			var weather:Weather = new Weather;
			weather.city = xml.channel.yweather::location.@city;
			weather.country = xml.channel.yweather::location.@country;
			weather.condition = xml.channel.item.yweather::condition.@text;
			weather.tempature = Number(xml.channel.item.yweather::condition.@temp);
			
			weather.units_temperature = xml.channel.yweather::units.@temperature;
			weather.units_distance = xml.channel.yweather::units.@distance;
			weather.units_pressure = xml.channel.yweather::units.@pressure;
			weather.units_speed = xml.channel.yweather::units.@speed;
			
			weather.wind_chill = Number(xml.channel.yweather::wind.@chill);
			weather.wind_direction = Number(xml.channel.yweather::wind.@direction);
			weather.wind_speed = Number(xml.channel.yweather::wind.@speed);
			
			weather.atmosphere_humid = Number(xml.channel.yweather::atmosphere.@humidity);
			weather.atmosphere_visiblity = Number(xml.channel.yweather::atmosphere.@visibility);
			weather.atmosphere_pressure = Number(xml.channel.yweather::atmosphere.@pressure);
			weather.atmosphere_rising = Number(xml.channel.yweather::atmosphere.@rising);
			
			weather.astronomy_sunrise = xml.channel.yweather::astronomy.@sunrise;
			weather.astronomy_sunset = xml.channel.yweather::astronomy.@sunset;
			
			dispatchEvent(new YahooWeatherEvent(YahooWeatherEvent.ON_WEATHER, weather));
		}
		
		
		private function __onError(e:IOErrorEvent) : void {	trace("ERROR:" + e);	}
		
		//--------------------------------------
		//  TRACER
		//--------------------------------------
		
		private function tracethis(str:*, level:int=0) : void {
			TraceCenter.tracethis("YahooWeatherManager_"+level+"_"+str);
			//trace("# WeatherDisplayer		#  " + str);
		}
		
	}

}

internal class ConstructorAccess{}
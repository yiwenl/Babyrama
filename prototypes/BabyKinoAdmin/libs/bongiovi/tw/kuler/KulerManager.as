//AS3///////////////////////////////////////////////////////////////////////////
// 
// Copyright 2010 
// 
////////////////////////////////////////////////////////////////////////////////

package bongiovi.tw.kuler  {
	/**
	 *	Singleton description.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 9.0
	 *
	 *	@author bongiovi
	 *	@since  2010-10-03
	 */
	import bongiovi.tw.tracer.TraceCenter;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	public class KulerManager extends EventDispatcher{
	
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		private static var _instance			: KulerManager;
		
		public static const NAMESPACE_KULER		: String = "http://kuler.adobe.com/kuler/API/rss/";
		private static const APIKEY				: String = "4A297340291400B78BF1DFFE0E8E1678";
		
		public var kuler						: Namespace = new Namespace(NAMESPACE_KULER);
		private var __loader 					: URLLoader;
		
		//--------------------------------------
		//  SINGLETON CONSTRUCTION
		//--------------------------------------
	
		public function KulerManager(access:ConstructorAccess) : void {
//			TraceCenter.addChannel("KulerManager");
		}
	
		public static function getInstance() : KulerManager {
			if(_instance == null)	_instance = new KulerManager(new ConstructorAccess());
			
			return _instance;
		}
		
		
		public function getRandomColors() : void {
			if(__loader==null) {
				__loader = new URLLoader();
				__loader.addEventListener(Event.COMPLETE, __onKulerLoadedHandler);
			}
			
			__loader.load(new URLRequest("http://kuler-api.adobe.com/rss/get.cfm?listType=rating&startIndex=0&itemsPerPage=20&key=" + APIKEY));
		}
		
		
		private function __onKulerLoadedHandler(e:Event) : void {
			var xml:XML = XML(__loader.data);
			
			var list:XMLList = new XMLList(xml.channel.item);
			var index : int = int(Math.random() * list.length());
			var theme:XML = list[index];
			var swatchList:XMLList = new XMLList(theme.kuler::themeItem.kuler::themeSwatches.kuler::swatch);
			var i : int = 0;
			var colors:Array = [];
			var sColor:String;
			var color:uint
			for(i=0; i<swatchList.length(); i++) {
				sColor = swatchList[i].kuler::swatchHexColor;
				color = parseInt("0x"+sColor);
				colors.push(color);
			}
			
			dispatchEvent(new KulerEvent(KulerEvent.ON_COLOR, colors));
		}
		
		
		//--------------------------------------
		//  TRACER
		//--------------------------------------
		
		private function tracethis(str:*, level:int=0) : void {
			TraceCenter.tracethis("KulerManager_"+level+"_"+str);
			//trace("# Test		#  " + str);
		}
	}

}

internal class ConstructorAccess{}
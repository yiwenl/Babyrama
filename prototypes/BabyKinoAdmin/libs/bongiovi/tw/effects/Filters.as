/**
 *  Filter Effects
 *	
 * 	@langversion ActionScript 3
 *	@playerversion Flash 9.0.0
 *
 *	@author Lin bongiovi
 *	@since  22.05.2008
 */
package bongiovi.tw.effects {
	import flash.display.DisplayObject;
	import flash.events.EventDispatcher;
	import flash.filters.BitmapFilter;	

	public class Filters extends EventDispatcher{
		
		/**
		 * Creating and Applying Filters
		 * 
		 * @param  type   
		 * @param  tmc    
		 * @param  paras  
		 * @param  append 
		 * @return 
		 */
		
		public static function createFilter(type:String, tmc:DisplayObject, paras:Object, append:Boolean=false):BitmapFilter{
			
			var filter:BitmapFilter = FilterFactory.createFilter(type);
			
			for(var i:String in paras){
				if(i in filter)		filter[i] = paras[i];
			}
			
			if("filters" in tmc){
				if(append){
					var fils:Array  = tmc.filters;
					fils.push(filter);
					tmc.filters = fils;
				}else {
					tmc.filters = [filter];
				}
			}
			
			return filter;
			
		}
		
		
		public static function createTweenFilter(tmc:DisplayObject, paras:Object, append:Boolean=false) : BitmapFilter {
			if(! ("filterType" in paras))		return null;
			
			var filter:BitmapFilter	= FilterFactory.createFilter(paras.filterType);
			
			for(var i:String in paras){
				if(i in filter)	{
					filter[i] = paras[i];
				}
			}
			
			
			if("filters" in tmc){
				if(append){
					var fils:Array  = tmc.filters;
					fils.push(filter);
					tmc.filters = fils;
				}else {
					tmc.filters = [filter];
				}
			}
			
			return filter;
		}
		
		
		/**
		 * Clear Filters
		 * 
		 * @param  tmc  
		 * @param  type 
		 * @return 
		 */
		
		public static function clearFilter(tmc:DisplayObject, type:String="all"):void{
			if(type == "all"){
				tmc.filters = [];
			}else {
				var tmpfilter:Array = tmc.filters;
				for(var i:Number=0; i<tmpfilter.length;i++){
					if(tmpfilter[i] is FilterFactory[type + "Constructor"]) {
						tmpfilter.splice(i,1);
					}
				}
				
				tmc.filters = tmpfilter;
			}
		}
		
	}
}
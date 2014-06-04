//AS3///////////////////////////////////////////////////////////////////////////
// 
// Copyright 2010 
// 
////////////////////////////////////////////////////////////////////////////////

package bongiovi.tw.align {

	/**
	 *	Class description.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 10.0
	 *
	 *	@author bongiovi
	 *	@since  2010-12-15
	 */

	import bongiovi.tw.tracer.TraceCenter;
	
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.geom.Point;
	
	public class Aligner {
	
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		protected static var _aList	 			: Array = [];
		
		public static var stage					: Stage;
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
	
		/**
		 *	@constructor
		 */
		public function Aligner(){}
		
		public static function add(source:DisplayObject, target:*, type:String, offset:Point=null, equation:Function=null, duration:Number=0, reset:Boolean=false) : void {
			if(stage == null && source.stage != null) stage = source.stage;
			if(!checkRegister(source)) {
				if(reset) getItem(source).reset(target, type, offset, equation, duration);
				else return;
			} 
			
			var item:AlignItem = new AlignItem(source, target, type, offset, equation, duration);
			_aList.push(item);
			
			startEngine();
			updateAll();
		}
		
		
		public static function updateAll(e:Event=null) : void {
			for each ( var item:AlignItem in _aList) {
				if(item.getSource() == null || item.getSource().parent == null) { 
					_aList.splice(_aList.indexOf(item), 1);
					if(_aList.length == 0 ) stopEngine();
				}else 
					item.update();
			}
		}
		
		
		public static function stopEngine() : void {
			if(stage == null) {
				tracethis("STAGE NOT DETECTED", 2);
				return;
			}
			updateAll();
			stage.removeEventListener(Event.RESIZE, updateAll);
		}
		
		
		public static function startEngine() : void {
			if(stage == null) {
				tracethis("STAGE NOT DETECTED", 2);
				return;
			}
			updateAll();
			stage.addEventListener(Event.RESIZE, updateAll);
		}
		
		
		public static function checkRegister(target:DisplayObject) : Boolean {
			for each ( var ref:AlignItem in _aList) if( ref.getSource() === target ) return false;
			return true;
		}
		
		
		public static function getItem(target:DisplayObject) : AlignItem {
			for each(var ref:AlignItem in _aList) if( ref.getSource() === target ) return ref;
			return null;
		}
		
		
		public static function removeItem(target:DisplayObject) : void {
			for each ( var item:AlignItem in _aList) {
				if(item.getSource() === target) _aList.splice(_aList.indexOf(item), 1);
			}
		}

		//--------------------------------------
		//  TRACER
		//--------------------------------------

		private static function tracethis(str:*, level:int=0) : void {
			TraceCenter.addChannel("Aligner");
			TraceCenter.tracethis("Aligner_"+level+"_"+str);
			//trace("# Aligner		#  " + str);
		}
		
	}

}

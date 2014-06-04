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
	
	import caurina.transitions.Tweener;
	
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class AlignItem {
	
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		protected var _source 					: DisplayObject;
		protected var _target 					: *; 	//	DISPLAY OBJECT / RECT
		protected var _type 					: String;
		protected var _offset 					: Point;
		protected var _equation 				: Function;
		protected var _duration 				: Number;
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
	
		/**
		 *	@constructor
		 */
		public function AlignItem(source:DisplayObject, target:*, type:String, offset:Point=null, equation:Function=null, duration:Number=0){
			TraceCenter.addChannel("AlignItem");
			_source = source;
			_target = target;
			_type = type;
			_offset = offset;
			_equation = equation;
			_duration = duration;
		}
		
		
		public function update() : void {
			if(_equation == null) {
				if(_target is Rectangle) Align.alignToRectangle(_source, Rectangle(_target), _type, _offset);
				else Align.alignTo(_source, _target, _type, _offset); 
			} else {
				var p : Point;
				if(_target is Rectangle) p = Align.alignToRectangle(_source, Rectangle(_target), _type, _offset, false);
				else p = Align.alignTo(_source, _target, _type, _offset, false);
				
				Tweener.addTween(_source, {x:p.x, y:p.y, transition:_equation, time:_duration});
			}
		}
		
		
		public function reset(target:*, type:String, offset:Point=null, equation:Function=null, duration:Number=0) : void {
			_target = target;
			_type = type;
			_offset = offset;
			_equation = equation;
			_duration = duration;
		}
		
		
		public function getSource() : DisplayObject	{ return _source;	}

		//--------------------------------------
		//  TRACER
		//--------------------------------------

		private function tracethis(str:*, level:int=0) : void {
			TraceCenter.tracethis("AlignItem_"+level+"_"+str);
			//trace("# AlignItem		#  " + str);
		}
		
	}

}

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
	 *	@since  2009-09-18
	 */
	import bongiovi.tw.tracer.TraceCenter;
	
	import flash.geom.Matrix;
	import flash.geom.Point;	

	public class MatrixUtils {
	
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
	
		/**
		 *	@constructor
		 */
		public function MatrixUtils(){
		}
		
		
		public static function getTranslateMatrix(p:Point):Matrix {
			var _m:Matrix = new Matrix();
			_m.translate(p.x, p.y);
			return _m;
		}

		//--------------------------------------
		//  TRACER
		//--------------------------------------

		private static function tracethis(str:*, level:int=0) : void {
			TraceCenter.tracethis("MatrixUtils_"+level+"_"+str);
			trace("# MatrixUtils		#  " + str);
		}
		
	}

}
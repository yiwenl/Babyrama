//AS3///////////////////////////////////////////////////////////////////////////
// 
// Copyright 2011 
// 
////////////////////////////////////////////////////////////////////////////////

package bongiovi.tw.scheduler {

	/**
	 *	Class description.
	 *
	 *	@langversion ActionScript 3.0
	 *	@playerversion Flash 10.0
	 *
	 *	@author bongiovi
	 *	@since  2011-01-03
	 */

	import bongiovi.tw.collections.HashMap;
	import bongiovi.tw.tracer.TraceCenter;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.getTimer;

	public class Scheduler extends EventDispatcher {
	
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		public static const TASK_NAME_PREFIX 	: String = "SchedulerTask";
		public static const FRAME_RATE			: int = 30;
		protected static var _idTable 			: uint = 0;
		
		protected static var _tasks 			: HashMap = new HashMap();
		protected static var _delayTasks 		: HashMap = new HashMap();
		protected static var _highTasks			: Array = [];
		protected static var _nextTasks			: Array = [];
		protected static var _aDeferTasks 		: Array = [];
		protected static var _engine 			: Sprite = new Sprite;
		protected static var _isRunning 		: Boolean = false;
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
	
		/**
		 *	@constructor
		 */
		public function Scheduler(){	}
		
		
		public static function start() : void {
			if(_isRunning) return ;
			_isRunning = true;
			_engine.addEventListener( Event.ENTER_FRAME, _process );
		}
		
		
		public static function stop() : void {
			if(!_isRunning)	return ;
			_isRunning = false;
			_engine.removeEventListener( Event.ENTER_FRAME, _process );
		}
		
		
		public static function removeTask(id:*) : int {
			var taskID:String;
			var task:SchedulerTask;
			if(id is String) taskID = id.toString();
			else taskID = TASK_NAME_PREFIX + Number(id);
			
			_tasks.remove(taskID);
			_delayTasks.remove(taskID);
			
			for each ( task in _aDeferTasks) {
				if(task.id == taskID) _aDeferTasks.splice(_aDeferTasks.indexOf(task), 1);
			}
			
			for each ( task in _nextTasks) {
				if(task.id == taskID) _nextTasks.splice(_nextTasks.indexOf(task), 1);
			}
			
			for each ( task in _highTasks) {
				if(task.id == taskID) _highTasks.splice(_highTasks.indexOf(task), 1);
			}
			
			
			return -1;
		}
		
		
		public static function removeAllTasks() : void {
			_tasks = new HashMap();
			_delayTasks = new HashMap();
			_aDeferTasks = [];
			_highTasks = [];
			_nextTasks = [];
		}
		
		
		public static function addEF(scope:*, func:Function, params:Array=null, interval:Number=0) : int {
			start();
			_idTable++;
			var id : String = TASK_NAME_PREFIX + _idTable;
			var task:SchedulerTask = new SchedulerTask(id, scope, func, params, interval);
			_tasks.put(id, task);
			return _idTable;
		}
		
		
		public static function delay(scope:*, func:Function, params:Array=null, interval:Number=0) : int {
			start();
			_idTable++;
			var id : String = TASK_NAME_PREFIX + _idTable;
			var task:SchedulerTask = new SchedulerTask(id, scope, func, params, interval);
			_delayTasks.put(id, task);
			return _idTable;
		}
		
		
		public static function next(scope:*, func:Function, params:Array=null) : int {
			start();
			_idTable++;
			var id : String = TASK_NAME_PREFIX + _idTable;
			var task:SchedulerTask = new SchedulerTask(id, scope, func, params);
			_nextTasks.push(task);
			return _idTable;
		}
		
		
		public static function defer(scope:*, func:Function, params:Array=null) : int {
			start();
			_idTable++;
			var id : String = TASK_NAME_PREFIX + _idTable;
			var task:SchedulerTask = new SchedulerTask(id, scope, func, params);
			_aDeferTasks.push(task);
			return _idTable;
		}
		
		
		protected static function _process(e:Event) : void {
			var ary:Array = [];
			var task:SchedulerTask;
			
			ary = _tasks.getValues();
			for each( task in ary) {
				if(task.update() - task.startTime > task.delay ) {
					task.func.apply(task.scope, task.params);
					task.startTime = task.currTime;
				}
			}
			
			ary = _delayTasks.getValues();
			for each( task in ary) {
				if(task.update() - task.startTime > task.delay ) {
					task.func.apply(task.scope, task.params);
					removeTask(task.id);
				}
			}
			
			while(_highTasks.length > 0 ) {
				task = _highTasks.pop();
				task.func.apply(task.scope, task.params);
			}
			
			
			var startTime : Number = getTimer()
			var interval:Number = int(1000 / FRAME_RATE);
			
			while(_aDeferTasks.length > 0) {
				task = _aDeferTasks.pop();
				if(task.update() - startTime < interval ) {
					task.func.apply(task.scope, task.params);
					removeTask(task.id);
				}else {
					break;
				}
			}
			
			_highTasks = _highTasks.concat(_nextTasks);
			_nextTasks = [];
			
			
			if(_checkTasksSum() == 0) stop();
		}
		
		
		protected static function _checkTasksSum() : int {
			return _tasks.getValues().length + _delayTasks.getValues().length + _highTasks.length + _nextTasks.length;
		}

		//--------------------------------------
		//  TRACER
		//--------------------------------------

		private static function tracethis(str:*, level:int=0) : void {
			TraceCenter.addChannel("Scheduler");
			TraceCenter.tracethis("Scheduler_"+level+"_"+str);
			//trace("# Scheduler		#  " + str);
		}
		
	}

}
/**
 *  Remote Handle
 *	
 *	@usage <pre><code> 
 * 		var RH:RemoteHandle = new RemoteHande(gatewayUrl, AMFencoding);
 *		RH.remote(serviceName:String, Arguments:Array)
 *		RH.addEventListener(eventName, handlingFunction)
 *
 *		P.S. 	eventName = "on"+serviceName,with first word Upper case
 *		E.X. 	service: "board.getInfo" => eventName : "onGetInfo"
 *
 *	
 * 	@langversion ActionScript 3
 *	@playerversion Flash 9.0.0
 *
 *	@author Lin bongiovi
 *	@since  22.05.2008
 */

package bongiovi.tw.remote{
	import flash.events.*;
	import flash.net.*;
	
	public class RemoteHandle extends EventDispatcher{
		private var _gateway										:String;
		private var _encoding										:String;
		private var _workquene										:Array = new Array();		
		private var _calling										:RemoteCalling;
		private var _nc												:NetConnection;
		private var onProcessing									:Boolean;		
		private var _toTrace										:Boolean;
		private var responder										:Responder;
		
		public function RemoteHandle(gateway:String, enc:String="AMF3", toTrace:Boolean=false){
			_toTrace = toTrace;
			tracethis("Remote Handle Activated, Encoding : " +enc);
			
			init(gateway,enc);
		}
		
		
		/**
		 * Initialize, Setting the Encoding and Built Up the Connection 
		 *  初 始 化 ， 設 定 連 線 編 碼(AMF0、AMF3) 以 及 建 立 連 線。
		 * 
		 * @param  gateway 	AMFPHP 之 閘 道 位 置。
		 * @param  enc     	AMFPHP 使 用 的 ObjecetEncoding 編 碼 ， 預 設 值 為AMF0。
		 * @return 
		 */
		
		private function init(gateway:String, enc:String):void{			
			_gateway 				= gateway;			
			_encoding 				= enc;
			_workquene 				= [];
			_nc						= new NetConnection();
			onProcessing 			= false;
			responder				= new Responder(onRemoteResult, onRemoteFault);
			
			if(enc == "AMF3"){
				_nc.objectEncoding 	= ObjectEncoding.AMF3;
			}else {
				_nc.objectEncoding 	= ObjectEncoding.AMF0;
			}
			
			_nc.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			_nc.objectEncoding 	= ObjectEncoding.AMF3;
			_nc.connect(_gateway);
		}
		
		
		/**
		 * Net Status Monitoring
		 *	網 路 狀 況 監 看
		 * 
		 * @return 
		 */
		private function netStatusHandler(e:NetStatusEvent):void {
			tracethis("Info:"+e.info) ;
		}
		
		
		/**
		 * Proccessing the Remote Process
		 *  處 理 遠 端 呼 叫。
		 * 
		 * @return 
		 */
		
		private function process(calling:RemoteCalling):void{						
			onProcessing		= true;
			_calling				= calling;
			
			var para:Array = new Array();
			para.push(calling.name);
			para.push(responder);
			
			for(var i:int=0; i <calling.args.length; i++){
				para.push(calling.args[i]);
			}
			
			_nc.call.apply(_nc, para);
		}
		
		
		/**
		 * Adding Request of Remote Call to Work Quene
		 *  新 增 遠 端 呼 叫 ， 若 是 忙 錄 中 則 堆 壘 至 工 作 流 程 中(_workquene)，否 則 則 直 接 執 行。
		 * 
		 * @param  serv  呼 叫 之 服 務 名 稱。
		 * @param  args  要 傳 的 參 數。
		 * @return 
		 */
		
		public function remote(serv:String, args:Array):void{
			var _call:RemoteCalling = new RemoteCalling();
			_call.name 	= serv;
			_call.args 	= args;
			
			if(onProcessing){
				_workquene.push(_call);
			}else {
				process(_call);
			}
		}
		
		
		/**
		 * Retrieve Results, Data Transfer Successfully !
		 *  結 果 接 收 ，dispatch  新 事 件 名 稱 之 事 件。
		 * 
		 * @param  result 
		 * @return 
		 */
		
		private function onRemoteResult(result:Object):void{
			onProcessing = false;
			
			var e:RemoteEvent = new RemoteEvent(eventName());
			e.result = result;
			dispatchEvent(e);
			
			if(_workquene.length > 0){
				process(_workquene.shift());
			}
		}
		
		
		/**
		 * Error On Remote Process
		 *  錯 誤 接 收，dispatch 新 事 件 名 稱 + "Fault" 事 件。
		 * 
		 * @param  fault 
		 * @return 
		 */
		
		private function onRemoteFault(fault:Object):void{
			onProcessing = false;			
			
			var e:RemoteEvent = new RemoteEvent(eventName()+"Fault");
			e.result = fault;
			this.dispatchEvent(e);
			
			if(_workquene.length > 0){
				process(_workquene.shift());
			}
		}
		
		
		/**
		 * Get Event Name
		 *  由 服 務 名 稱 取 得 新 事 件 名 稱，
		 *	ex board.getAll => onGetAll, board.addMsg => onAddMsg。
		 * 
		 * @return 新事件名稱。
		 */
		
		private function eventName():String{
			var strIndex:Number = _calling.name.indexOf(".")+1;
			var eName:String = "on"+_calling.name.substring(strIndex, strIndex+1).toUpperCase()+_calling.name.substring(strIndex+1, _calling.name.length);
			return eName;
		}
		
		
		/**
		 * 	Setting the Encoding; 
		 * 	 設 定 連 線 編 碼。
		 */		 
		public function set encoding(enc:String):void{
			_encoding = enc;
		}
		
		public function get encoding():String{
			return _encoding;
		}
		
		/**
		 * 	Setting Service Gateway
		 * 	 設 定 閘 道。
		 */
		public function set gate(gat:String):void{
			_gateway = gat;
		}
		
		public function get gate():String{
			return _gateway;
		}
		
		
		/**
		 * Tracer
		 * 
		 * @param  str 
		 * @return 
		 */
		
		private function tracethis(str:*):void{
			if(_toTrace)				trace("# Remote Handle		#  "+str);
		}
	}
}
package killClass
{
	import com.smartfoxserver.v2.SmartFox;
	import com.smartfoxserver.v2.core.SFSEvent;
	import com.smartfoxserver.v2.entities.data.SFSDataWrapper;
	import com.smartfoxserver.v2.entities.data.SFSObject;
	import com.smartfoxserver.v2.requests.ExtensionRequest;
	import com.smartfoxserver.v2.requests.JoinRoomRequest;
	import com.smartfoxserver.v2.requests.LoginRequest;
	import com.tg.Tools.StringToolsLib;
	import com.tg.Tools.TimeTools;
	import com.tools.DebugTools;
	import com.tools.JSONTools;
	
	import flash.display.Sprite;
	import flash.events.NetStatusEvent;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import killClass.data.BasicInfos;
	import killClass.tools.CmdData;

	public class KillClient
	{
		public var connection:SmartFox;
		public function KillClient()
		{
			collector=new MessageCollector();
			this.connection = new SmartFox();
			this.connection.useBlueBox = false;
			this.connection.addEventListener(SFSEvent.CONNECTION,onConnection);
			this.connection.addEventListener(SFSEvent.CONNECTION_LOST, onConnectionLost);
			this.connection.addEventListener(SFSEvent.CONNECTION_RESUME, onConnectionLost);
			this.connection.addEventListener(SFSEvent.LOGIN_ERROR, onLoginError);
			this.connection.addEventListener(SFSEvent.LOGIN, onLogin);
			this.connection.addEventListener(SFSEvent.ROOM_JOIN_ERROR, onRoomJoinError);
			this.connection.addEventListener(SFSEvent.ROOM_JOIN, onRoomJoin);
			this.connection.addEventListener(SFSEvent.EXTENSION_RESPONSE, onExtensionResponse);
		}
		
		private static var instance:KillClient;
		public static function get me():KillClient
		{
			if(!instance)
			{
				instance=new KillClient();
			}
			return instance;
		}
		
		
		
		public function login() : void
		{
			if (this.connection.isConnected)
			{
				this.connection.killConnection();
				this.connection.disconnect();
			}
			
			
			//		erver:ft2.ss911.cn:8005,ft2.ss911.cn:443
			this.connection.connect(BasicInfos.severAdd,BasicInfos.port);
			return;
		}// end function
		
		public function trylogin() : void
		{
			login();
			return;
		}// end function
		
		private function sfslogin() : void
		{
			this.connection.send(BasicInfos.getLoginData());
			return;
		}// end function
		
		private function joinRoom(room:String) : void
		{
			var data:* = new JoinRoomRequest(room);
			this.connection.send(data);
			return;
		}// end function
		
		private function onDisconnectBtClick() : void
		{
			this.connection.disconnect();
			return;
		}// end function
		
		private function onConfigLoadFailure(event:SFSEvent) : void
		{
			return;
		}// end function
		
		private function onConnection(event:SFSEvent) : void
		{
			
			DebugTools.traceObj(event.params,"onConnection");
			sfslogin();
			return;
		}// end function
		
		private var waitTime:int=60*1000;
//		waitTime=60*1000;
		
		private function updateState():void
		{
			if(timeConnect>0)
			{
				clearTimeout(timeConnect);
				timeConnect=-1;
				DebugTools.debugTrace("清除重连","断线类型");
			}else
			{
				
			}
		}
		
		
		
		private var timeConnect:Number=-1;
		
		private function onConnectionLost(event:SFSEvent) : void
		{
			DebugTools.debugTrace(event.type,"断线类型");
			DebugTools.debugTrace("连接断开，"+waitTime+"ms后重新连接："+StringToolsLib.getTimeStamp(TimeTools.getTimeNow()),"LoseConnect");
			
			timeConnect=setTimeout(login,waitTime);
		}
		
		private function onLoginError(event:SFSEvent) : void
		{
			trace("onLoginError:");
			
			return;
		}// end function
		
		private function onLogin(event:SFSEvent) : void
		{
			//			this.joinRoom(MainData.LoginInfo.Room + MainData.LoginInfo.Id);
			trace("login");
			joinRoom("line"+BasicInfos.line);
			return;
		}// end function
		
		private function onRoomJoinError(event:SFSEvent) : void
		{
			trace("进房间失败: " + event.params.errorMessage);
			return;
		}// end function
		
		private function onRoomJoin(event:SFSEvent) : void
		{
			//			MainData.isLoginScenced = 1;
			//			sendPrivate(1549754,"hello");
//			sendPrivate(1549754,"hello:"+StringToolsLib.getTimeStamp(TimeTools.getTimeNow()));
			sendPrivate(1549754,"hello:");
			
			return;
		}// end function
		
		public function StatusHandler(event:NetStatusEvent) : void
		{
			
			trace(event.info.code.toString());
			return;
		}// end function
		
		public var collector:MessageCollector;
		public function onExtensionResponse(msgO:SFSEvent) : void
		{
			var responseParams:* = msgO.params.params;
			var cmd:*;
			cmd={};
			cmd = responseParams.toObject();
//			trace("cmd"+cmd);
//			trace("responseParams)"+responseParams);
			var type:String;
			type=msgO.params.cmd;
			DebugTools.debugTrace(type+"\n"+JSONTools.getJSONString(cmd),type,cmd);
			
			collector.dealSpeaker(cmd,type);
			updateState();
			
			return;
		}// end function
		
		public function SendCmd(data:Object) : void
		{
			
			
			var cData:* = new Object();
			cData.BinaryData = CmdData.getData(data);
			//			SFSObject.newFromBinaryData(data.BinaryData);
			var tData:* = SFSObject.newFromObject(cData);
			var sData:* = new ExtensionRequest("ClientCmd", tData, this.connection.lastJoinedRoom);
			this.connection.send(sData);
			return;
		}// end function
		
		public function sendPrivate(uid:int,msg:String):void
		{
			var msgO:* = new Object();
			msgO.cmd = "PrivateChat";
			msgO.ToUserId = uid+"";
			msgO.msg = msg;
			SendCmd( msgO);
		}

	}
}
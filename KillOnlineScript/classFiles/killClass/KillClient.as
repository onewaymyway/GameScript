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
	import killClass.so.ServerSO;
	import killClass.tools.CmdData;

	public class KillClient
	{
		public var connection:SmartFox;
		public var tSender:MessageSender;
		
		public var copyMachine:CopyMachine;
		
		public var cmdMachine:CmdMachine;
		
		public var toolActionDealer:ToolActionDealer;

		public function KillClient()
		{
			collector=new MessageCollector();
			
			roomInfoCollector=new RoomInfoCollector();
			
			tSender=new MessageSender();
			tSender.sendFun=sendPrivate;
			
			
			copyMachine=new CopyMachine();
			
			cmdMachine=new CmdMachine();
			cmdMachine.cmdOwner=this;
			
			toolActionDealer=new ToolActionDealer();
			
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
			DebugTools.debugTrace("login","login");
			var responseParams:* = event.params.user;
			
			
			DebugTools.debugTrace("user:"+"\n"+responseParams.id,"login",responseParams);
			BasicInfos.uid=responseParams.id;
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
			sendPrivate(1549754,"hello:"+StringToolsLib.getTimeStamp(TimeTools.getTimeNow()));
//			sendPrivate(1549754,"hello:");
			
			return;
		}// end function
		
		public function StatusHandler(event:NetStatusEvent) : void
		{
			
			trace(event.info.code.toString());
			return;
		}// end function
		
		public var collector:MessageCollector;
		public var roomInfoCollector:RoomInfoCollector;
		public function onExtensionResponse(msgO:SFSEvent) : void
		{
			var responseParams:* = msgO.params.params;
			var cmd:*;
			cmd={};
			cmd = responseParams.toObject();
			trace("cmd"+cmd);
			trace("responseParams)"+responseParams);
			var type:String;
			type=msgO.params.cmd;
			DebugTools.debugTrace(type+"\n"+JSONTools.getJSONString(cmd),type,cmd);
			
			if(type.indexOf("PrivateChat")>=0)
			{
				cmdMachine.dealPrivateMsg(cmd);
				return;
			}
			
			if(type.indexOf("UserInfo")>=0)
			{
				BasicInfos.uid=cmd["UserId"];
				return;
			}
			
			if(type.indexOf("ToolAction")>=0)
			{
				toolActionDealer.dealMsg(cmd);
				return;
			}
			
			if(type.indexOf("PlayerInfo")>=0)
			{
				
				dealPlayerInfo(cmd);
				return;
			}
			
			if(type.indexOf("getRoomsList")>=0)
			{
				
				roomInfoCollector.dealMsg(cmd);
				return;
			}
			
			if(type.indexOf("SO_Sync")>=0)
			{
				
				ServerSO.SOSync(cmd);
				return;
			}
			
			if(BasicInfos.collectInfo)
			{
				collector.dealSpeaker(cmd,type);
			}
			
			if(!cmd["UserId"]) 
			{
				return;
			}
			
			if(CopyMachine.isOnlyMe)
			{
				if(CmdMachine.managerList.isInList(cmd["UserId"]))
				{
					sendChat(cmd["Msg"]);
				}
				return;
			}else
			{
				
			}
			
			if(cmd["UserId"]==BasicInfos.uid)
			{
				
				return;
			}
			
			if(cmd["UserName"])
			{
				var tUserData:Object;
				tUserData={};
				tUserData["name"]=cmd["UserName"];
				tUserData["id"]=cmd["UserId"];
				DebugTools.debugTrace(cmd["UserName"],"Names",tUserData);
			}
			
			copyMachine.dealMsg(cmd);
			
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
		public function dealPlayerInfo(data:Object):void
		{
			if(CmdMachine.managerList.isInList(data["UserId"]))
			{
				joinRoomByID(data["Room"]);
			}
		}
		public function sendPrivate(uid:int,msg:String):void
		{
			var msgO:* = new Object();
			msgO.cmd = "PrivateChat";
			msgO.ToUserId = uid+"";
			msgO.msg = msg;
			SendCmd( msgO);
		}

		public function joinRoomByID(roomID:int):void
		{
			BasicInfos.tRoomID=roomID;
			var joinO:Object = {cmd:"JoinRoom", RoomId:roomID+"", Password:""};
			SendCmd(joinO);
		}
		
		public function sendChat(msg:String):void
		{
			var data:Object = new Object();
			data.Msg = msg;
			data.Color = "";
			data.cmd = "SayInRoom";
			SendCmd(data);
		}
		
		public function getUInfoData(uid:int):void
		{
			var data:Object;
			data={};
			data.UserId = uid+"";
			data.cmd = "PlayerInfo";
			SendCmd(data);
		}
		
		public function getRoomList(type:String="areaA"):void
		{
			var data:Object = new Object();
			data.AREA = "areaA";
			data.cmd = "getRoomsList";
			SendCmd(data);
		}
		public function kickPlayer(pid:int) : void
		{
			var data:Object = new Object();
			data.cmd = "KickUser";
			data.UserId = String(pid);
			SendCmd(data);
			return;
		}// end function
		public function kickBySitID(sid:int):void
		{
			RoomPlayerListGetter.me.getRoomSitDataO(BasicInfos.tRoomID,roomDataBack);
			function roomDataBack(roomData:Object):void
			{
				if(!roomData) return;
				if(!roomData[sid]) return;
				try
				{
					var tPData:Object;
					tPData=roomData[sid];
					var sID:int;
					sID=tPData["UserId"];
					kickPlayer(sID);
				}catch(e:*)
				{
					
				}
				
			}
		}
		public function addFriend(uid:int):void
		{
			var data:Object = new Object();
			data.cmd = "FriendCmd_FriendVerify";
			data.Msg = "�����Ϊ����";
			data.UserId = String(uid);
			SendCmd(data);
		}
		public function addFriendSit(sit:int):void
		{
			RoomPlayerListGetter.me.actionRoomSit(BasicInfos.tRoomID,sit,addFriend);
		}
		
		public function setRoomInfo(pwd:String="",roomName:String="算命,不准不要钱"):void
		{
			
			var data:Object = new Object();
			data.RoomName = roomName;
			data.Password = pwd;
			data.MaxPlayerNum = "20";
			data.BackGround = "bg12";
			data.LimitIp = "true";
			data.DoubleIntegral = "false";
			data.GameType = "5";
			data.cmd = "SetRoom";
			SendCmd(data);
		}
	}
}
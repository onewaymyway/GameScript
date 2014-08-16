package killClass
{
	import Core.GameEvents;
	import Core.model.NetProxy;
	
	import com.smartfoxserver.v2.core.SFSEvent;
	import com.tg.Tools.StringToolsLib;
	import com.tg.Tools.TimeTools;
	import com.tools.DebugTools;
	import com.tools.JSONTools;
	
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import org.puremvc.as3.interfaces.IFacade;
	import org.puremvc.as3.patterns.facade.Facade;

	public class KillBasic
	{
		
		public var facade:IFacade;
		
		public var netP:NetProxy;
						
		public var timeConnect:Number=-1;
		
		public var cnt;
				
		public var waitTime:int;
		
		
		public function KillBasic()
		{
			init();
		}
		
		
		public function init():void
		{
			waitTime=60*1000;
			facade=Facade.getInstance();
			trace("faced:"+facade);
			trace("NetProxy.NAME)"+NetProxy.NAME);
			
			trace(facade.retrieveProxy(NetProxy.NAME));
			netP=facade.retrieveProxy(NetProxy.NAME);
			trace("netp"+netP);
			cnt=netP.connection;
			cnt.addEventListener(SFSEvent.CONNECTION_RESUME,onConnectionLost);
			cnt.addEventListener(SFSEvent.CONNECTION_LOST, onConnectionLost);
			
			cnt.addEventListener(SFSEvent.EXTENSION_RESPONSE, onMsg);
			
		}
		
		
		public function updateState():void
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
		
		public function onMsg(msgO:*):void
		{
			trace("get message:"+msgO);
			trace(msgO.params);
			var responseParams:* = msgO.params.params;
			var cmd:*;
			cmd={};
			cmd = responseParams.toObject();
			trace("cmd"+cmd);
			trace("responseParams)"+responseParams);
			var type:String;
			type=msgO.params.cmd;
			DebugTools.debugTrace(msgO.params.cmd+"\n"+JSONTools.getJSONString(cmd),msgO.params.cmd,cmd);
			dealMsgs(type,cmd);
		}
			
		public function dealMsgs(type:String,data:Object):void
		{
			
		}
		public function onConnectionLost(event:SFSEvent) : void
		{
			DebugTools.debugTrace(event.type,"断线类型");
			DebugTools.debugTrace("连接断开，"+waitTime+"ms后重新连接："+StringToolsLib.getTimeStamp(TimeTools.getTimeNow()),"LoseConnect");
			
			timeConnect=setTimeout(tryLogin,waitTime);
		}
		public function tryLogin():void
		{
			facade.sendNotification(GameEvents.LOGINEVENT.LOGIN);
			
			DebugTools.debugTrace("重连","LoseConnect");
		}
		
		public function joinRoom(roomID:int):void
		{
			var joinO:Object = {cmd:"JoinRoom", RoomId:roomID+"", Password:""};
			facade.sendNotification(GameEvents.NETCALL, joinO);
		}
		public function sendChat(msg:String):void
		{
			var data = new Object();
			data.Msg = msg;
			data.Color = "";
			data.cmd = "SayInRoom";
			facade.sendNotification(GameEvents.NETEVENT.NETCALL, data);
			
		}
		public function sendPrivate(uid:int,msg:String):void
		{
			var msgO:* = new Object();
			msgO.cmd = "PrivateChat";
			msgO.ToUserId = uid+"";
			msgO.msg = msg;
			facade.sendNotification(GameEvents.NETCALL, msgO);
		}
		
		//checkInfo(2823053);
		public function checkInfo(uid:int):void
		{
			facade.sendNotification(GameEvents.PlUSEVENT.USERINFOBOXSHOW, uid);
		}
		//getUInfoData(2823053);
		public function getUInfoData(uid:int):void
		{
			var data:Object;
			data={};
			data.UserId = uid+"";
			data.cmd = "PlayerInfo";
			facade.sendNotification(GameEvents.NETCALL, data);
		}
	}
}
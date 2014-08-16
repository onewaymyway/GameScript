package killClass.data
{
	import com.smartfoxserver.v2.entities.data.SFSObject;
	import com.smartfoxserver.v2.requests.LoginRequest;
	import com.tg.Tools.StringToolsLib;
	import com.tools.DebugTools;
	import com.tools.JSONTools;
	
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	import killClass.KillClient;
	import killClass.tools.Base64Killer;

	public class BasicInfos
	{
		public function BasicInfos()
		{
		}
		
		public static var userValue:String="v7SeKMMm2MN8fzm/UIN5OFdY3bmQr9uA";
		public static var userIP:String="x7DhqWJinpaAOXq1NtJJRA==";
		public static var line:int=1;
		public static var room:int=0;
		public static var uid:int=0;
		public static var zone:String="killonline";
		//		erver:ft2.ss911.cn:8005,ft2.ss911.cn:443
		public static var severAdd:String="ft2.ss911.cn";
		public static var port:int=8005;
		
		public static var collectInfo:Boolean=false;
		
		public static var tRoomID:int;
		
		public static function getLoginData():LoginRequest
		{
			var data:* = new SFSObject();
			data.putUtfString("UV", userValue);
			data.putUtfString("IP", userIP);
			data.putInt("L", line);
			data.putInt("R",room);
			var loginO:LoginRequest= new LoginRequest("", "", zone, data);
			return loginO;
		}
		public static function getLoginDataS(uValue:String,uip:String,line:int=1,room:int=0,zone:String=""):LoginRequest
		{
			var data:* = new SFSObject();
			data.putUtfString("UV", uValue);
			data.putUtfString("IP", uip);
			data.putInt("L", line);
			data.putInt("R",room);
			var loginO:LoginRequest= new LoginRequest("", "", zone, data);
			return loginO;
		}
		
		public static var tIPID:int=140;
		public static function getAUserIP():String
		{
			tIPID++;
			if(tIPID>999)
			{
				tIPID=140;
			}
			return "hvZ4W"+tIPID+"IHxLhs3z4uXylQ==";
		}
		public static function loadUserInfo(uname:String):void
		{
			var urlLoader:URLLoader=new URLLoader();
			urlLoader.dataFormat=URLLoaderDataFormat.TEXT;
			
			var uv:URLVariables=new URLVariables();
			uv.uname=uname;
			uv.action="get";
			
			　　var request:URLRequest=new URLRequest();
			
			　　request.url="http://sogasoga.sinaapp.com/killOnline/getdata_name.php";
			　　request.method=URLRequestMethod.GET;
			　　request.data=uv;
			
			　　urlLoader.load(request);
			　　urlLoader.addEventListener(Event.COMPLETE,infoLoaded);
			trace("getData"+uname);	
			DebugTools.debugTrace("getData:"+uname,"loadInfo");
		}
		
		private static function infoLoaded(evt:Event):void
		{
			var dataStr:String;
			dataStr=(evt.currentTarget as URLLoader).data;
			
			
			var tO:Object;
			tO=JSONTools.getJSONObject(dataStr);
			DebugTools.debugTrace("infoLoaded:"+dataStr,"loadInfo",tO);
			
			var tUInfo:Object;
			tUInfo= JSONTools.getJSONObject(tO.datas[0].data);
			
			userValue=tUInfo.uservalues;
			userIP=tUInfo.userip+int(Math.random()*10);
			zone=tUInfo.Zone;
//			userValue="0EHBDuf%2bUYxbLyag%2fOb7r4zDs0i1jxjT";
//			userValue="0EHBDuf+UYxbLyag/Ob7r4zDs0i1jxjT";
//			userIP=Base64Killer.encode("101.39.188.121");
			userIP="hvZ4W279IHxLhs3z4uXylQ==";
			userIP="hvZ4W"+int(Math.random()*10)+"79IHxLhs3z4uXylQ==";
			
			
			DebugTools.debugTrace("uInfo:"+tUInfo.name,"loadInfo",tUInfo);
			
			KillClient.me.login();
		}
	}
}
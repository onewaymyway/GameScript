package killClass.data
{
	import com.smartfoxserver.v2.entities.data.SFSObject;
	import com.smartfoxserver.v2.requests.LoginRequest;
	import com.tools.DebugTools;
	import com.tools.JSONTools;
	
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	import killClass.KillClient;

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
			userIP=tUInfo.userip+"2";
			zone=tUInfo.Zone;
			userValue=tUInfo.uservalues;
			
			
			DebugTools.debugTrace("uInfo:"+tUInfo.name,"loadInfo",tUInfo);
			
			KillClient.me.login();
		}
	}
}
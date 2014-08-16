package killClass
{
	import com.adobe.net.URI;
	import com.tg.Tools.WebTools;
	import com.tools.DebugTools;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.utils.ByteArray;
	
	import killClass.data.BasicInfos;
	
	import org.httpclient.HttpClient;
	import org.httpclient.HttpRequest;
	import org.httpclient.events.HttpDataEvent;
	import org.httpclient.events.HttpResponseEvent;
	import org.httpclient.http.Post;

	public class LoginTool
	{
		public function LoginTool()
		{
			loader=new URLLoader();
			loader.addEventListener(Event.COMPLETE, reportResult);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,securityErro);
			loader.addEventListener(IOErrorEvent.IO_ERROR,ioErro);
		}
		private static var instance:LoginTool;
		public static function get me():LoginTool
		{
			if(!instance)
			{
				instance=new LoginTool();
			}
			return instance;
		}
		
		
//		Request URL:http://www.ss911.cn/Pages/login/login2.aspx
//		Request Method:POST	
		
//		Header
//		Accept:text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8
//			Accept-Encoding:gzip,deflate,sdch
//			Accept-Language:zh-CN,zh;q=0.8
//			Cache-Control:max-age=0
//			Connection:keep-alive
//			Content-Length:49
//			Content-Type:application/x-www-form-urlencoded
//			Cookie:lzstat_uv=36091937043487088584|264585; lzstat_ss=3853251619_0_1407446102_264585
//			Host:www.ss911.cn
//			Origin:http://www.ss911.cn
//			Referer:http://www.ss911.cn/Pages/login/login2.htm
//			User-Agent:Mozilla/5.0 (Windows NT 5.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/33.0.1750.154 Safari/537.36
		
		public static var headerTP:Object=
			{
//				"Accept":"text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8",
				"Accept-Language":"zh-CN,zh;q=0.8",
//				"Cache-Control":"max-age=0",
				"Connection":"keep-alive",
//				"Content-Type":"application/x-www-form-urlencoded",
				"Host":"www.ss911.cn",
//				"Cookie":"lzstat_uv=36091937043487088584|264585; lzstat_ss=89733932_0_1407455511_264585; ASP.NET_SessionId=m4zdse5511p0wp45wipdbk3o",
				"Origin":"http://www.ss911.cn",
				"Referer":"http://www.ss911.cn/Pages/login/login2.htm",
				"User-Agent":"Mozilla/5.0 (Windows NT 5.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/33.0.1750.154 Safari/537.36"
			}
//		data
//		user:deathnotekk
//		pass:deathnote123
//		code:
//		ckSave:1
		
		public function getRequest(id:String,pwd:String):URLRequest
		{
			var request:URLRequest;
			request=new URLRequest("http://www.ss911.cn/Pages/login/login2.aspx");
			request.method=URLRequestMethod.POST;
			var uv:URLVariables=new URLVariables();
			//			from:zh
			//			to:en
			//			query:我了个去啊
			//			transtype:trans
			uv.user=id;
			uv.pass=pwd;
			uv.code="";
			uv.ckSave=1;
			request.data=uv;
			
			WebTools.setHeaders(request,headerTP);
			return request;
		}
		
		public var loader:URLLoader;
		public function login(id:String,pwd:String):void
		{
			loader.load(getRequest(id,pwd));
		}
		
		public function securityErro(e:Event):void
		{
			DebugTools.debugTrace("模拟登录 securityErro","Report");
		}
		public function ioErro(e:Event):void
		{
			DebugTools.debugTrace("模拟登录 ioErro","Report");
		}
		public function reportResult(e:Event):void
		{
			DebugTools.debugTrace(e.target.data,"Report");
			trace(e.target.data);
			
		}
		public function httpTest(id:String,pwd:String):void
		{
			var client:HttpClient = new HttpClient();
			
			var uri:URI = new URI("http://www.ss911.cn/Pages/login/login2.aspx");
			
			var uv:Object=new Object();
			//			from:zh
			//			to:en
			//			query:我了个去啊
			//			transtype:trans
			uv.user=id;
			uv.pass=pwd;
			uv.code="";
			uv.ckSave=1;
			var kk:String;
			var paramList:Array=[];
			for(kk in uv)
			{
				paramList.push({name:kk,value:uv[kk]});
			}
//			
			var request:HttpRequest = new Post(paramList);
			var testData:ByteArray = new ByteArray();
//			for(kk in headerTP)
//			{
//				request.addHeader(kk,headerTP[kk]);
//			}
			
			
			client.listener.onComplete = comp;
				function comp(event:HttpResponseEvent):void 
				{
				
				trace(event.response.header.content);
				
				testData.position = 0;
				var responseBody:String = testData.readUTFBytes(testData.bytesAvailable);
				var cookies:Object;
				cookies=event.response.header.getCookies();
				DebugTools.traceObj(cookies,"cookies");
				trace(responseBody);
				
				if(cookies["uservalues"])
				{
					BasicInfos.userValue=cookies["uservalues"];
//					BasicInfos.userIP="x7DhqWJinpaAOXq1NtJJRA=="+Math.random();
					KillClient.me.login();
				}
				}
				client.listener.onData = function(event:HttpDataEvent):void {
					testData.writeBytes(event.bytes);
					
				};
			client.request(uri,request);
					
		}
	
		
	}
}
package killClass
{
	import com.tools.DebugTools;
	import com.tools.JSONTools;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;

	public class Translator
	{
		public function Translator()
		{
			loader=new URLLoader();
			loader.addEventListener(Event.COMPLETE, reportResult);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,securityErro);
			loader.addEventListener(IOErrorEvent.IO_ERROR,ioErro);
		}
		private static var instance:Translator;
		public static function get me():Translator
		{
			if(!instance)
			{
				instance=new Translator();
			}
			return instance;
		}
		public function setHeaders(request:URLRequest,len:int):void
		{
			request.requestHeaders=[];
			
			var requestHeadears:Object;
			requestHeadears={};
//			Accept:*/*
//				Accept-Encoding:gzip,deflate,sdch
//				Accept-Language:zh-CN,zh;q=0.8
//				Connection:keep-alive
//				Content-Length:84
//				Content-Type:application/x-www-form-urlencoded; charset=UTF-8
//				Cookie:BAIDUID=EE867D2D4BF330EE3CB3AB135FBC4FCC:FG=1; locale=zh; Hm_lvt_64ecd82404c51e03dc91cb9e8c025574=1404560055; Hm_lpvt_64ecd82404c51e03dc91cb9e8c025574=1404560055
//				Host:fanyi.baidu.com
//				Origin:http://fanyi.baidu.com
//				Referer:http://fanyi.baidu.com/translate
//				User-Agent:Mozilla/5.0 (Windows NT 5.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/33.0.1750.154 Safari/537.36
//				X-Requested-With:XMLHttpRequest
			requestHeadears=
				{
					"Accept":"*/*",
					"Accept-Encoding":"gzip,deflate,sdch",
					"Accept-Language":"zh-CN,zh;q=0.8",
					"Connection":"keep-alive",
//					"Content-Length":"84",
					"Content-Type":"application/x-www-form-urlencoded; charset=UTF-8",
					"Cookie":"AIDUID=EE867D2D4BF330EE3CB3AB135FBC4FCC:FG=1; locale=zh; Hm_lvt_64ecd82404c51e03dc91cb9e8c025574=1404560055; Hm_lpvt_64ecd82404c51e03dc91cb9e8c025574=1404560055",
					"Host":"fanyi.baidu.com",
					"Origin":"http://fanyi.baidu.com",
					"Referer":"http://fanyi.baidu.com/translate",
					"User-Agent":"Mozilla/5.0 (Windows NT 5.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/33.0.1750.154 Safari/537.36",
					"X-Requested-With":"XMLHttpRequest"
				};
			var kk:String;
			for(kk in requestHeadears)
			{
				request.requestHeaders.push(new URLRequestHeader(kk,requestHeadears[kk]));
			}
		}
		public static var dstLanguage:String="en";
		public static var lang_list:Object= {'zh': '中文','jp': '日语','th': '泰语','fra': '法语','en': '英语','spa': '西班牙语','kor': '韩语','tr': '土耳其语','vi': '越南语','ms': '马来语','de': '德语','ru': '俄语','ir': '伊朗语','ara': '阿拉伯语','et': '爱沙尼亚语','be': '白俄罗斯语','bg': '保加利亚语','hi': '印地语','is': '冰岛语','pl': '波兰语','fa': '波斯语','da': '丹麦语','tl': '菲律宾语','fi': '芬兰语','nl': '荷兰语','ca': '加泰罗尼亚语','cs': '捷克语','hr': '克罗地亚语','lv': '拉脱维亚语','lt': '立陶宛语','ro': '罗马尼亚语','af': '南非语','no': '挪威语','pt_BR': '巴西语','pt': '葡萄牙语','sv': '瑞典语','sr': '塞尔维亚语','eo': '世界语','sk': '斯洛伐克语','sl': '斯洛文尼亚语','sw': '斯瓦希里语','uk': '乌克兰语','iw': '希伯来语','el': '希腊语','hu': '匈牙利语','hy': '亚美尼亚语','it': '意大利语','id': '印尼语','sq': '阿尔巴尼亚语','am': '阿姆哈拉语','as': '阿萨姆语','az': '阿塞拜疆语','eu': '巴斯克语','bn': '孟加拉语','bs': '波斯尼亚语','gl': '加利西亚语','ka': '格鲁吉亚语','gu': '古吉拉特语','ha': '豪萨语','ig': '伊博语','iu': '因纽特语','ga': '爱尔兰语','zu': '祖鲁语','kn': '卡纳达语','kk': '哈萨克语','ky': '吉尔吉斯语','lb': '卢森堡语','mk': '马其顿语','mt': '马耳他语','mi': '毛利语','mr': '马拉提语','ne': '尼泊尔语','or': '奥利亚语','pa': '旁遮普语','qu': '凯楚亚语','tn': '塞茨瓦纳语','si': '僧加罗语','ta': '泰米尔语','tt': '塔塔尔语','te': '泰卢固语','ur': '乌尔都语','uz': '乌兹别克语','cy': '威尔士语','yo': '约鲁巴语','yue': '粤语','wyw': '文言文' };
		
		
		public function setDstLang(dstLan:String):void
		{
			var tLan:String;
			var dstLanP:String;
			dstLanP="en";
			var key:String;
			for(key in lang_list)
			{
				if(lang_list[key]==dstLan)
				{
					dstLanP=key;
					break;
				}
			}
			dstLanguage=dstLanP;
		}
		public function getRequest(str:String):URLRequest
		{
			var request:URLRequest;
			request=new URLRequest("http://fanyi.baidu.com/v2transapi");
			request.method=URLRequestMethod.POST;
			var uv:URLVariables=new URLVariables();
//			from:zh
//			to:en
//			query:我了个去啊
//			transtype:trans
			uv.from="zh";
			uv.to=dstLanguage;
			uv.query=str;
			uv.transtype="trans";
			request.data=uv;
			
			setHeaders(request,84);
			return request;
		}
		
		public var loader:URLLoader;
		public function traslateStr(str:String):void
		{
			loader.load(getRequest(str));
		}
		
		public function securityErro(e:Event):void
		{
			DebugTools.debugTrace("翻译失败 securityErro","Report");
		}
		public function ioErro(e:Event):void
		{
			DebugTools.debugTrace("翻译失败 ioErro","Report");
		}
		public function reportResult(e:Event):void
		{
			DebugTools.debugTrace("翻译成功","Report");
			var rst:Object;
			rst=JSONTools.getJSONObject(e.target.data);
			var tStr:String;
			var transRst:Object;
			transRst=rst["trans_result"];
			if(transRst["status"]==0)
			{
				tStr=transRst["data"][0]["dst"];
			}else
			{
				tStr="翻译失败";
			}
			
			trace("翻译结果："+tStr);
			KillClient.me.sendChat(tStr);
			
		}
	}
}
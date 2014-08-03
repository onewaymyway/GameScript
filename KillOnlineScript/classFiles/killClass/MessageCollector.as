package killClass
{
	import com.tg.Tools.TextTools;
	import com.tg.Tools.TimeTools;
	import com.tools.DebugTools;
	import com.tools.JSONTools;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	import killClass.data.BasicInfos;

	public class MessageCollector
	{
		public var loader:URLLoader;
		
		public function MessageCollector()
		{		
			loader=new URLLoader();
			loader.addEventListener(Event.COMPLETE, reportResult);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,securityErro);
			loader.addEventListener(IOErrorEvent.IO_ERROR,ioErro);
			reportTypeList=["Speaker","SystemMsg","HallMsg","RoomPlayerList"];
//			reportTypeList=["RoomPlayerList"];
			reportTypeLenLimit={"RoomPlayerList":1};
		}
		public var reportTypeList:Array=["Speaker","SystemMsg","HallMsg","RoomPlayerList"];
		public var reportTypeLenLimit:Object={"RoomPlayerList":1};
		//reportTypeList=["Speaker","SystemMsg"];
		public var msgDic:Object={};
		public function getMsgListByType(type:String):Array
		{
			var rst:Array;
			if(msgDic[type])
			{
				rst=msgDic[type];
			}else
			{
				rst=[];
				msgDic[type]=rst;
			}
			return rst;
		}
		public function isReportType(type:String):String
		{
			var i:int;
			var len:int;
			len=reportTypeList.length;
			for(i=0;i<len;i++)
			{
				if(type.indexOf(reportTypeList[i])>=0)
				{
					return reportTypeList[i];
				}
			}
			return null;
		}
		
		public function getTypeLenLimit(type:String):int
		{
			if(reportTypeLenLimit.hasOwnProperty(type))
			{
				return reportTypeLenLimit[type];
			}
			return 10;
		}
		public function dealSpeaker(msg:Object,type:String):void
		{
			//DebugTools.debugTrace("收集数据："+speakList.length,"Report");
			if(!isReportType(type))
			{
				return;
			}
			msg.time=TimeTools.getTimeNow();
			JSONTools.adaptForJSON(msg);
			var tList:Array;
			tList=getMsgListByType(type);
			tList.push(msg);
			DebugTools.debugTrace("收集数据"+type+"："+tList.length,"Report");
			if(tList.length>=getTypeLenLimit(type))
			{
				reportSpeakesToSever(type,tList);
			}
		}
		
		public function reportSpeakesToSever(type:String,data:Array):void
		{
					
			var url:String="http://sogasoga.sinaapp.com/killOnline/getcontent.php";
			//url="http://t1.ss911.cn/User/Friend.ss?u="+MainData.LoginInfo.uservalues+"&p="+p+"&t=0&userid="+pid+"";
			var dataStr:String;
			dataStr=JSONTools.getJSONString(data);
			dataStr=TextTools.getPlainText(dataStr);
			data.splice(0,data.length);
			DebugTools.debugTrace("上传收集数据:"+type+"\n"+dataStr,"Report",data);
			var uv:URLVariables=new URLVariables();
			uv.action="put";
			uv.content=dataStr;
			uv.type=type;
			uv.zone=BasicInfos.zone;
			
			var rq:URLRequest = new URLRequest();
			rq.url =url;
			rq.method = URLRequestMethod.GET;
			rq.data=uv;
				
			loader.load(rq);
			DebugTools.debugTrace("上传数据end","Report");
		}
		public function securityErro(e:Event):void
		{
			DebugTools.debugTrace("上传收集数据失败 securityErro","Report");
		}
		public function ioErro(e:Event):void
		{
			DebugTools.debugTrace("上传收集数据失败 ioErro","Report");
		}
		public function reportResult(e:Event):void
		{
			DebugTools.debugTrace("上传收集数据成功","Report");
		}
	}
}
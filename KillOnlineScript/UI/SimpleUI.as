package
{
	import com.tg.Tools.DisplayUtil;
	import com.tg.Tools.StringToolsLib;
	import com.tg.Tools.TextTools;
	import com.tg.Tools.TimeTools;
	import com.tools.JSONTools;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.text.TextField;
	import flash.text.TextFieldType;

	public class SimpleUI extends MovieClip
	{
		public function SimpleUI()
		{
			
           // outTxt=new TextField;
			var tHeight:int;
			tHeight=500;
			outTxt=TextTools.getATextField(600,tHeight);
			DisplayUtil.moveTarget(this,outTxt);
			
			nameTxt=TextTools.getATextField(90,30);
			nameTxt.type=TextFieldType.INPUT;
			DisplayUtil.moveTarget(this,nameTxt,0,tHeight+20);
			
			Ok=TextTools.getATextField(60,30);
			Ok.selectable=false;
			Ok.text="获取数据";
			DisplayUtil.moveTarget(this,Ok,100,tHeight+20);
			
			Ok.addEventListener(MouseEvent.CLICK,getData);
			
			
			var kk:Object={};
			kk.key="kkp\"hello\"kkp";
			var str:String;
			str=JSONTools.getJSONString(kk);
			str=TextTools.getPlainText(str);
			trace(str);
			var kO:Object;
			kO=JSONTools.getJSONObject(str);
			trace(kO);
			
			//getName("[aess]fawe[sss]fer");
		}
		
		public var outTxt:TextField;
		public var nameTxt:TextField;
		public var Ok:TextField;
		
		
		private function getData(evt:MouseEvent):void
		{
			   var urlLoader:URLLoader=new URLLoader();
			   urlLoader.dataFormat=URLLoaderDataFormat.TEXT;
			   
			   var uv:URLVariables=new URLVariables();
			   uv.uname=nameTxt.text;
			   uv.action="get";
			   
			　　var request:URLRequest=new URLRequest();
			
			　　request.url="http://sogasoga.sinaapp.com/killOnline/getdata.php";
			　　request.method=URLRequestMethod.GET;
			　　request.data=uv;
			
			　　urlLoader.load(request);
			　　urlLoader.addEventListener(Event.COMPLETE,finish);
			    trace("getData"+nameTxt.text);
		}
		private function finish(evt:Event):void
		{
			
			　　outTxt.text=(evt.currentTarget as URLLoader).data;
			    var tO:Object;
				tO=JSONTools.getJSONObject((evt.currentTarget as URLLoader).data);
				//outTxt.text=tO.datas[0]["data"].toString();
				dealResult(tO);
				
		}
		
		private var nameDics:Object={};
		private function addUser(userO:Object):void
		{
			if(!userO["UserName"]) return;
			var tName:String;
			tName=userO["UserName"];
			var tUserO:Object;
			if(!nameDics[tName])
			{
				tUserO=new Object();
				tUserO.name=tName;
				tUserO.count=0;
				nameDics[tName]=tUserO;
			}else
			{
				tUserO=nameDics[tName];
			}
			
			tUserO.count=tUserO.count+1;
		}
		
		private function getUsersStr():String
		{
			var rst:String;
			
			var usrList:Array;
			usrList=[];
			var kk:String;
			for(kk in nameDics)
			{
				usrList.push(nameDics[kk]);
			}
			usrList.sortOn("count",Array.NUMERIC|Array.DESCENDING);
			
			var names:Array;
			var i:int;
			var len:int;
			var tUsrO:Object;
			names=[];
			len=usrList.length;
			for(i=0;i<len;i++)
			{
				tUsrO=usrList[i];
				if(i>40) break;
				names.push(tUsrO.name+":"+tUsrO.count);
			}
			rst="相关用户：\n"+names.join("\n");
			return rst;
		}
		private function getName(str:String):void
		{
			var reg:RegExp;
			reg=new RegExp("\\[.[^\\[]*\\]","g");
			var tL:Array;
			tL=str.match(reg);
			trace(JSONTools.getJSONString(tL));
			
			var i:int;
			var len:int;
			var tName:String
			len=tL.length;
			for(i=0;i<len;i++)
			{
				tName=tL[i];
				tName=StringToolsLib.getReplace(tName,"\\[","");
				tName=StringToolsLib.getReplace(tName,"]","");
				addUser({"UserName":tName});
			}
		}
		private function dealResult(data:Object):void
		{
			var uname:String;
			uname=data.uname;
			var speakerList:Array;
			var logList:Array;
			var bbList:Array;
			var tData:Object;
			speakerList=[];
			logList=[];
			bbList=[];
			var dataList:Array;
			dataList=data.datas;
			var i:int;
			var len:int;
			nameDics={};
			len=dataList.length;
			
			var j:int;
			var jLen:int;
			var tLData:Object;
			var tType:String;
			
			var tMsgList:Array;
			var tMsgO:Object;
			for(i=0;i<len;i++)
			{
				tData=dataList[i];
				var tStr:String;
				tStr=tData.data;
				//tStr=StringToolsLib.getReplace(tStr,"“","o");
				//tStr=StringToolsLib.getReplace(tStr,"\"","o");
				
				tType=tData.mType;
				try
				{
					tLData=JSONTools.getJSONObject(tStr);
				}catch(e:Error)
				{
					continue;
				}
				
				tMsgList=tLData as Array;
				jLen=tMsgList.length;
				
				for(j=0;j<jLen;j++)
				{
					tLData=tMsgList[j];
					addUser(tLData);
					tLData.date=StringToolsLib.getTimeStamp(tLData.time);
					if(tLData.Msg)
					{
						getName(tLData.Msg);
					}
					if((tLData.Msg as String).indexOf(uname)>=0||(tLData.UserName&&(tLData.UserName as String).indexOf(uname)>=0))
					{
						switch(tType)
						{
							case "HallMsg":
								logList.push(tLData.date+":"+tLData.Msg);
								
								break;
							case "Speaker":
								speakerList.push(tLData.date+":"+tLData.UserName+":"+tLData.Msg);
								break;
							case "SystemMsg":
								bbList.push(tLData.date+":"+tLData.Msg);
								break;
						};
					}
				}
			}
			
			var rst:String;
			rst=TextTools.getColorText("登录信息：\n"+logList.join("\n"),0xFFFF00)+TextTools.getColorText("\n喇叭信息：\n"+speakerList.join("\n"),0x00FFFF)+TextTools.getColorText("\n公告信息：\n"+bbList.join("\n"),0xFF00FF);
			outTxt.htmlText=rst+"\n"+TextTools.getColorText(getUsersStr(),0xFF8800);
			
		}
	}
}
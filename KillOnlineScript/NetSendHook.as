package
{
	import com.tools.DebugTools;
	import com.tools.JSONTools;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	
	public class NetSendHook  implements IMediator 
	{
		public function NetSendHook()
		{
		}
		
		public function listNotificationInterests():Array
		{
			return ["NETCALL"];
		}
		
		public function onRegister():void
		{
		}
		
		public function handleNotification(param1:INotification):void
		{
			var sender:INotification = param1;
			switch(sender.getName())
			{
				case "NETCALL":
					DebugTools.debugTrace(JSONTools.getJSONString(sender.getBody()),"netHook",sender.getBody());
					break;
			}
		}
		
		public function getMediatorName():String
		{
			return "NetSendHook";
		}
		
		public function setViewComponent(param1:Object):void
		{
		}
		
		public function getViewComponent():Object
		{
			return null;
		}
		
		public function onRemove():void
		{
		}
	}
}
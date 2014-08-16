package
{
	import com.tools.DebugTools;
	import com.tools.JSONTools;
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class NetHookClass  extends SimpleCommand implements ICommand
	{
		public  var NAME:String = "NetHookClass";
		public function NetHookClass()
		{
//			super(NetHookClass, null);
		}
		public static var exeCuteFun:Function=null;
		override public function execute(sender:INotification) : void
		{
			DebugTools.debugTrace(String(sender),"netHook",sender.getBody());
			if(exeCuteFun!=null)
			{
				exeCuteFun(sender);
			}
			return;
		}// end function
//		override public function handleNotification(param1:INotification):void
//		{
//			// TODO Auto Generated method stub
//			var sender:INotification = param1;
//			switch(sender.getName())
//			{
//				case "NETCALL":
//					DebugTools.debugTrace(JSONTools.getJSONString(sender.getBody()),"netHook",sender.getBody());
//					break;
//			}
//		}
//		
//		override public function listNotificationInterests():Array
//		{
//			// TODO Auto Generated method stub
//			return ["NETCALL"];
//		}
		
		
	}
}
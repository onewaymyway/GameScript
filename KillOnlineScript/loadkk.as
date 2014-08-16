
import Core.MyFacade;

var tFacade:MyFacade;
tFacade=MyFacade.getInstance();

function loadUrl(url:String):void
{
	var data:Object;
	data = {url:url, x:0, y:0};
	tFacade.sendNotification("PlusMediator_OPEN", data);
}

loadUrl("/KillNetHook.swf?v=gfgtgr400043r");

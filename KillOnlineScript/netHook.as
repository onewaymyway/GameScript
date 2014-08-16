import Core.MyFacade;
import Core.controller.NetCommand;

import com.tg.Tools.ScriptAdapter;
import com.tools.DebugTools;

ScriptAdapter.loadClassList(["http://sogasoga.sinaapp.com/killOnline/scripts/NetSendHook.as?v=133r"],loadSuccess);
//ScriptAdapter.loadClassList(["http://sogasoga.sinaapp.com/killOnline/scripts/NetHookClass.as?v=3f12"],loadSuccess);
function loadSuccess():void
{
	DebugTools.debugTrace("loadClassSuccess","load");
	
	var tHook:NetSendHook;
	tHook=new NetSendHook();
	var tFacade:MyFacade;
	tFacade=MyFacade.getInstance();
	DebugTools.debugTrace(tFacade,"load",tFacade);
	tFacade.removeCommand("NETCALL");
	tFacade.registerCommand("NETCALL",NetCommand);
	tFacade.registerCommand("NETCALL",NetSendHook);
//	tFacade.registerMediator(tHook);
	DebugTools.debugTrace("runsuccessaa","load");
	//ScriptAdapter.loadScriptList(["http://sogasoga.sinaapp.com/killOnline/scripts/followerScript.as?v=2"],loadScriptSuccess);
}

function loadScriptSuccess():void
{
	DebugTools.debugTrace("loadScriptSuccess","load");
}
DebugTools.debugTrace("runsuccess","load");
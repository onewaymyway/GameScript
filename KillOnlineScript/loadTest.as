import com.tg.Tools.ScriptAdapter;
import com.tools.DebugTools;

ScriptAdapter.loadClassList(["http://sogasoga.sinaapp.com/killOnline/scripts/MessageSender.as?v=1"],loadSuccess);
function loadSuccess():void
{
	DebugTools.debugTrace("loadClassSuccess","load");
	ScriptAdapter.loadScriptList(["http://sogasoga.sinaapp.com/killOnline/scripts/followerScript.as?v=2"],loadScriptSuccess);
}

function loadScriptSuccess():void
{
	DebugTools.debugTrace("loadScriptSuccess","load");
}
DebugTools.debugTrace("runsuccess","load");
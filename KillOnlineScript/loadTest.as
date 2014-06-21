import com.tg.Tools.ScriptAdapter;
import com.tools.DebugTools;

ScriptAdapter.loadClassList(["http://sogasoga.sinaapp.com/killOnline/scripts/MessageSender.as?v=1"],loadSuccess);
function loadSuccess():void
{
	DebugTools.debugTrace("loadsuccess","load");
}
DebugTools.debugTrace("runsuccess","load");
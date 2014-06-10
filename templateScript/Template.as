import com.tg.Tools.DebugToolScreen;
import com.tools.DebugTools;
import com.tg.Tools.DisplayUtil;
import flash.display.DisplayObjectContainer;


var stage:DisplayObjectContainer;
stage= DebugToolScreen.me.container.stage;

DebugTools.debugTrace("hello","ScriptOut");

import game.module.war.view.fightView.KillNumHp;


addDis(KillNumHp,200,400);

function addDis(disCla:Class,x:int,y:int):void
{
	var tDis;
	tDis=new disCla();
	stage.addChild(tDis);
	tDis.x=x;
	tDis.y=y;
	DisplayUtil.setTop(tDis);
	DebugTools.debugTrace("addDis success","ScriptOut");
}


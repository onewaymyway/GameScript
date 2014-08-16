
import uas.LoadSwfsrc;

var ld:LoadSwfsrc;
ld=new LoadSwfsrc();
ld.load("http://sogasoga.sinaapp.com/killOnline/scripts/KillNetHook.swf?v=gfgtg");
import com.tg.StageUtil;
import com.tg.Tools.DomainTools;
import com.tg.Tools.DoubleLoader;
import com.tools.DebugTools;

import flash.display.Loader;
import flash.display.Sprite;
import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.system.ApplicationDomain;
import flash.system.LoaderContext;

DoubleLoader.load("http://sogasoga.sinaapp.com/killOnline/scripts/KillNetHook.swf?v=gfgtgttttgtr443r",null);

var tt:Sprite;
tt=new Sprite();
//Image.addPic(tt,"http://sogasoga.sinaapp.com/killOnline/scripts/KillNetHook.swf?v=133r");
var tloader:Loader;
tloader=new Loader();

var rq:URLRequest;
rq=new URLRequest("http://sogasoga.sinaapp.com/killOnline/scripts/KillNetHook.swf?v=gfgtgttttgtr443r");
var tdm:ApplicationDomain;
tdm=ApplicationDomain.currentDomain;
DebugTools.debugTrace(DomainTools.me.urlDomain,"tdms",DomainTools.me.urlDomain);
//tdm=DomainTools.me.urlDomain["http://t1.ss911.cn/swf20140604/Core.swf"];
DebugTools.debugTrace(tdm,"tdm");
tloader.load(rq, new LoaderContext(false, tdm));

import NetHookClass;
import Core.MyFacade;
import com.tools.DebugTools;
import org.puremvc.as3.interfaces.ICommand;
import flash.utils.describeType;
import com.tools.ClassTools;
import Core.controller.NetCommand;
import com.tools.ObjectTranslator;
import org.puremvc.as3.interfaces.IMediator;
import org.puremvc.as3.interfaces.INotification;
import com.tools.JSONTools;


var tHook:NetHookClass;
tHook=new NetHookClass();
var tFacade:MyFacade;
tFacade=MyFacade.getInstance();
//DebugTools.debugTrace(tFacade,"load",tFacade);
//tFacade.registerMediator(tHook);
var tCMD:IMediator;
tCMD=new NetHookClass();

//tCMD=ObjectTranslator.objectToInstance(tCMD,NetHookClass);
DebugTools.debugTrace(tCMD as ICommand,"tooself",tCMD);


DebugTools.debugTrace(tCMD as ICommand,"tHook is ICommand",tCMD);
var kk:Object;
kk=ClassTools.getClassDesO(tCMD);
DebugTools.debugTrace(kk,"tHook interface",kk);
NetHookClass.exeCuteFun=sendCmds;
tFacade.removeCommand("NETCALL");
tFacade.registerCommand("NETCALL",NetHookClass);

function sendCmds(sender:INotification):void
{
  DebugTools.debugTrace(JSONTools.getJSONString(sender.getBody()),"netHookContent",sender.getBody());	
  var tcmd:NetCommand;
  tcmd=new NetCommand();
  tcmd.execute(sender);
}
//tFacade.registerMediator(tCMD);

var pCmd:ICommand;
pCmd=new NetCommand();
var pKK:Object;
pKK=ClassTools.getClassDesO(pCmd);
//pCmd=ObjectTranslator.objectToInstance(pCmd,ICommand);
DebugTools.debugTrace(pCmd as ICommand,"netCommand is ICommand",pCmd);
DebugTools.debugTrace(pKK,"netCommand interface",pKK);

var iKK:Object;
iKK=ClassTools.getClassDesO(ICommand);
DebugTools.debugTrace(iKK,"ICommand interface",iKK);
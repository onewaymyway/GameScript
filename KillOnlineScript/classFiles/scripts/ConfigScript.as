import killClass.CmdMachine;
import killClass.CopyMachine;
import killClass.KillClient;
import killClass.RoomInfoCollector;
import killClass.Translator;
import killClass.data.BasicInfos;

BasicInfos.collectInfo=false;
BasicInfos.loadUserInfo("从良未遂");



//KillClient.me.joinRoomByID(1029);

CopyMachine.isCopyOn=false;
CopyMachine.isOnlyMe=false;
CopyMachine.isTranslateOn=true;
RoomInfoCollector.isOn=false;

Translator.me.setDstLang("英语");

KillClient.me.addFriend(1549754);
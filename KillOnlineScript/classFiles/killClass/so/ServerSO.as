package killClass.so
{
    import flash.events.*;

    public class ServerSO extends Object
    {
        public static var SoObjects:Object = new Object();

        public function ServerSO()
        {
            return;
        }// end function

        public static function getRemote(sName:String) : SO
        {
            if (!SoObjects[sName])
            {
                SoObjects[sName] = new SO(sName);
            }
            return SoObjects[sName];
        }// end function

        public static function SOSync(data:Object) : void
        {
            var tName:String= String(data.SOName);
            var i:int = 0;
            while (i < data.ChangeList.length)
            {
                
                switch(data.ChangeList[i].code)
                {
                    case "clear":
                    {
                        if (SoObjects[tName])
                        {
                            SoObjects[tName].data = new Object();
                        }
                        break;
                    }
                    case "change":
                    {
                        if (SoObjects[tName] && SoObjects[tName].data)
                        {
                            SoObjects[tName].data[data.ChangeList[i].name] = data.ChangeList[i].data;
                        }
                        break;
                    }
                    case "delete":
                    {
                        if (SoObjects[tName] && SoObjects[tName].data)
                        {
                            SoObjects[tName].data[data.ChangeList[i].name] = null;
                            delete SoObjects[tName].data[data.ChangeList[i].name];
                        }
                        break;
                    }
                    default:
                    {
                        break;
                    }
                }
                i++;
            }
            if (SoObjects[tName])
            {
                SoObjects[tName].dispatchEvent(new SyncEvent(SyncEvent.SYNC, false, false, data.ChangeList));
            }
            return;
        }// end function

    }
}

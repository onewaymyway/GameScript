package Core.so
{
    import flash.events.*;

    public class ServerSO extends Object
    {
        public static var SoObjects:Object = new Object();

        public function ServerSO()
        {
            return;
        }// end function

        public static function getRemote(param1:String) : SO
        {
            if (!SoObjects[param1])
            {
                SoObjects[param1] = new SO(param1);
            }
            return SoObjects[param1];
        }// end function

        public static function SOSync(param1:Object) : void
        {
            var _loc_2:* = String(param1.SOName);
            var _loc_3:int = 0;
            while (_loc_3 < param1.ChangeList.length)
            {
                
                switch(param1.ChangeList[_loc_3].code)
                {
                    case "clear":
                    {
                        if (SoObjects[_loc_2])
                        {
                            SoObjects[_loc_2].data = new Object();
                        }
                        break;
                    }
                    case "change":
                    {
                        if (SoObjects[_loc_2] && SoObjects[_loc_2].data)
                        {
                            SoObjects[_loc_2].data[param1.ChangeList[_loc_3].name] = param1.ChangeList[_loc_3].data;
                        }
                        break;
                    }
                    case "delete":
                    {
                        if (SoObjects[_loc_2] && SoObjects[_loc_2].data)
                        {
                            SoObjects[_loc_2].data[param1.ChangeList[_loc_3].name] = null;
                            delete SoObjects[_loc_2].data[param1.ChangeList[_loc_3].name];
                        }
                        break;
                    }
                    default:
                    {
                        break;
                    }
                }
                _loc_3++;
            }
            if (SoObjects[_loc_2])
            {
                SoObjects[_loc_2].dispatchEvent(new SyncEvent(SyncEvent.SYNC, false, false, param1.ChangeList));
            }
            return;
        }// end function

    }
}

package killClass.so
{
    import flash.events.*;
    
    import killClass.KillClient;

    dynamic public class SO extends EventDispatcher
    {
        public var name:String = "";
        public var data:Object;

        public function SO(tName:String)
        {
            this.name = tName;
            return;
        }// end function

        public function connect(param1:Object = null) : void
        {
            this.data = new Object();
            var sData:Object = {cmd:"SOCmd_Sync", Type:"connect", Name:this.name};
            KillClient.me.SendCmd(sData);
            return;
        }// end function

        public function close() : void
        {
            this.data = null;
            var sData:Object = {cmd:"SOCmd_Sync", Type:"close", Name:this.name};
			KillClient.me.SendCmd(sData);
            return;
        }// end function

    }
}

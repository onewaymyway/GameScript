package Core.model.vo
{
    import flash.net.*;

    public class CallCmdVO extends Object
    {
        public var code:String = "";
        public var resp:Responder = null;
        public var arg:Array;
        public var cmd:String = "";

        public function CallCmdVO()
        {
            this.arg = [];
            return;
        }// end function

    }
}

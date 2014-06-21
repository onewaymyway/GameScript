package Core.model.vo
{

    dynamic public class NewsMsgVO extends Object
    {
        public var Msg:String = "";
        public var MsgTitle:String = "";
        public var MsgType:uint = 0;
        public var MsgColors:Array;
        public var MsgLevel:uint = 0;

        public function NewsMsgVO()
        {
            this.MsgColors = [];
            return;
        }// end function

    }
}

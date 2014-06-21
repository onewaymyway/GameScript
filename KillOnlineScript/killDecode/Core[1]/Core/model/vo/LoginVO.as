package Core.model.vo
{

    dynamic public class LoginVO extends Object
    {
        public var Id:uint;
        public var RoomId:uint;
        public var uservalues:String;
        public var userip:String;
        public var Server:Array;
        public var ConnZone:String;
        public var ConnRoom:String;
        public var Zone:String;
        public var Room:String;
        public var PF:String = "";
        public var Openid:String;
        public var Openkey:String;
        public var PFKey:String;

        public function LoginVO()
        {
            return;
        }// end function

    }
}

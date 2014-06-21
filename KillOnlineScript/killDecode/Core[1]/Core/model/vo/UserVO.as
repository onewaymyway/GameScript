package Core.model.vo
{

    dynamic public class UserVO extends Object
    {
        public var Vip:int = 0;
        public var UserName:String = "";
        public var UserFace:String = "";
        public var Integral:int = 0;
        public var UserFigure:String = "";
        public var UserId:uint = 0;
        public var UserSex:uint = 0;
        public var EXP:uint = 0;
        public var Wintimes:uint = 0;
        public var Losttimes:uint = 0;
        public var firstlogin:uint = 0;
        public var Head:String = "";
        public var Cloth:String = "";
        public var Ku:String = "";
        public var Pet:String = "";
        public var MarryName:String = "";
        public var FamilyName:String = "";
        public var Money:uint = 0;
        public var FriendSeting:String = "-1";
        public var fristGame:Boolean = false;
        public var Face:String = "";
        public var Hat:String = "";
        public var Wing:String = "";
        public var Halo:String = "";
        public var Board:String = "";
        public var Gleis:String = "";
        public var web:String = "ss911.cn";
        public var Game10:int;
        public var Game20:int;
        public var Game30:int;
        public var Game40:int;
        public var Game50:int;
        public var Game60:int;
        public var GameBT:int;

        public function UserVO()
        {
            return;
        }// end function

        public function getGameTimesByType(param1:int) : int
        {
            if (param1 == 15)
            {
                return int(this.Game10);
            }
            if (param1 == 0)
            {
                return int(this.Game20);
            }
            if (param1 == 2)
            {
                return int(this.Game30);
            }
            if (param1 == 5)
            {
                return int(this.Game40);
            }
            if (param1 == 11)
            {
                return int(this.Game50);
            }
            if (param1 == 13)
            {
                return int(this.GameBT);
            }
            if (param1 == 14)
            {
                return int(this.Game60);
            }
            return -1;
        }// end function

    }
}

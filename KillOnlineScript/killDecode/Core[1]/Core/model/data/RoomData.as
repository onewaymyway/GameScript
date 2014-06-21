package Core.model.data
{

    public class RoomData extends Object
    {
        public static var RoomInfo:Object = new Object();
        public static var Rooms:Object = new Object();

        public function RoomData()
        {
            return;
        }// end function

        public static function getRoomWhereName(param1:uint) : String
        {
            if (int(param1) > 1000 && int(param1) < 2000)
            {
                return "" + int(String(param1).substr(1)) + "号房间";
            }
            if (int(param1) > 2000 && int(param1) < 3000)
            {
                return "休息区-" + int(String(param1).substr(1)) + "";
            }
            return "大厅";
        }// end function

    }
}

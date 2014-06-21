package Core.view
{
    import flash.display.*;

    public class MainView extends Object
    {
        public static var ALT:Object;
        public static var DRAG:ViewDrag;

        public function MainView()
        {
            return;
        }// end function

        public static function ReMoveToRandomXY(param1:DisplayObject, param2:int, param3:int, param4:int = 0, param5:int = 0) : void
        {
            if (param4 != 0 && param5 != 0)
            {
                param1.x = param4 + int(Math.random() * param2);
                param1.y = param5 + int(Math.random() * param3);
            }
            else
            {
                param1.x = param1.x + int(Math.random() * param2);
                param1.y = param1.y + int(Math.random() * param3);
            }
            return;
        }// end function

    }
}

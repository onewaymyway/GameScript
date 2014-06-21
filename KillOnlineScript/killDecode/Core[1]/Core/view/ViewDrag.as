package Core.view
{
    import flash.events.*;

    public class ViewDrag extends Object
    {

        public function ViewDrag()
        {
            return;
        }// end function

        public function setDrag(param1:Object, param2:Object, param3:Object) : void
        {
            var theOBJ:* = param1;
            var PARENT1:* = param2;
            var PARENT2:* = param3;
            PARENT2.setChildIndex(PARENT1, (PARENT2.numChildren - 1));
            theOBJ.addEventListener(MouseEvent.MOUSE_DOWN, function (event:MouseEvent) : void
            {
                mouseHandler(event, PARENT1, PARENT2);
                return;
            }// end function
            , false, 0, false);
            theOBJ.addEventListener(MouseEvent.MOUSE_UP, function (event:MouseEvent) : void
            {
                mouseHandler(event, PARENT1, PARENT2);
                return;
            }// end function
            , false, 0, false);
            theOBJ.addEventListener(MouseEvent.MOUSE_MOVE, function (event:MouseEvent) : void
            {
                mouseHandler(event, PARENT1, PARENT2);
                return;
            }// end function
            , false, 0, false);
            return;
        }// end function

        private function mouseHandler(event:MouseEvent, param2:Object, param3:Object) : void
        {
            var _loc_4:* = event.currentTarget;
            if (event.type == MouseEvent.MOUSE_DOWN)
            {
                param3.setChildIndex(param2, (param3.numChildren - 1));
                param2.startDrag();
            }
            else if (event.type == MouseEvent.MOUSE_UP)
            {
                param2.stopDrag();
            }
            else if (event.type == MouseEvent.MOUSE_MOVE)
            {
                event.updateAfterEvent();
            }
            return;
        }// end function

        public function hasTheChlid(param1:Object, param2:Object) : Boolean
        {
            var _loc_5:Object = null;
            var _loc_3:Boolean = false;
            var _loc_4:* = param2.numChildren;
            while (_loc_4 > 0)
            {
                
                _loc_4 = _loc_4 - 1;
                _loc_5 = param2.getChildAt(_loc_4);
                if (_loc_5 == param1)
                {
                    _loc_3 = true;
                }
            }
            return _loc_3;
        }// end function

    }
}

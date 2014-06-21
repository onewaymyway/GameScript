package toollist_fla
{
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;

    dynamic public class Timeline_7 extends MovieClip
    {
        public var max_btn:SimpleButton;
        public var selectData:int;
        public var maxN:int;
        public var num_t:TextField;
        public var minN:int;

        public function Timeline_7()
        {
            addFrameScript(0, frame1);
            return;
        }// end function

        public function get max() : int
        {
            return maxN;
        }// end function

        public function mouseHandler(event:MouseEvent) : void
        {
            num = maxN;
            return;
        }// end function

        public function set max(param1:int) : void
        {
            maxN = param1;
            return;
        }// end function

        function frame1()
        {
            selectData = 1;
            minN = 1;
            maxN = 99;
            this.max_btn.addEventListener(MouseEvent.MOUSE_DOWN, mouseHandler);
            num_t.restrict = "0-9";
            num_t.addEventListener(Event.CHANGE, textHandler);
            num_t.addEventListener(MouseEvent.MOUSE_WHEEL, wheelHandler);
            return;
        }// end function

        public function get num() : int
        {
            return selectData;
        }// end function

        public function wheelHandler(event:MouseEvent) : void
        {
            var _loc_2:* = selectData - event.delta / 3;
            if (_loc_2 < minN)
            {
                _loc_2 = minN;
            }
            else if (_loc_2 > maxN)
            {
                _loc_2 = maxN;
            }
            num = _loc_2;
            return;
        }// end function

        public function set num(param1:int) : void
        {
            if (param1 < minN)
            {
                param1 = minN;
            }
            else if (param1 > maxN)
            {
                param1 = maxN;
            }
            selectData = param1;
            num_t.text = String(selectData);
            return;
        }// end function

        public function textHandler(event:Event) : void
        {
            var _loc_2:* = int(num_t.text);
            if (_loc_2 < minN)
            {
                _loc_2 = minN;
            }
            else if (_loc_2 > maxN)
            {
                _loc_2 = maxN;
            }
            num = _loc_2;
            return;
        }// end function

    }
}

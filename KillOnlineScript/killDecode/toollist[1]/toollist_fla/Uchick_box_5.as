package toollist_fla
{
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;

    dynamic public class Uchick_box_5 extends MovieClip
    {
        public var def:Boolean;
        public var label_txt:TextField;
        public var chick_log:MovieClip;
        public var _selectData:Object;
        public var chickData:Object;
        public var labeltxt:String;
        public var unchickData:Object;

        public function Uchick_box_5()
        {
            addFrameScript(0, frame1);
            return;
        }// end function

        function frame1()
        {
            this.buttonMode = true;
            this.mouseChildren = false;
            this.addEventListener(MouseEvent.CLICK, onChick);
            if (def)
            {
                selectData = chickData;
                chick_log.visible = true;
            }
            else
            {
                selectData = unchickData;
                chick_log.visible = false;
            }
            label_txt.text = String(labeltxt);
            return;
        }// end function

        public function get selectData() : Object
        {
            return _selectData;
        }// end function

        public function onChick(event:Event) : void
        {
            this.parent.setChildIndex(this, (this.parent.numChildren - 1));
            if (chick_log.visible == false)
            {
                _selectData = chickData;
                chick_log.visible = true;
            }
            else
            {
                _selectData = unchickData;
                chick_log.visible = false;
            }
            this.dispatchEvent(new Event(Event.CHANGE));
            return;
        }// end function

        public function set selectData(param1:Object) : void
        {
            _selectData = param1;
            if (_selectData == chickData)
            {
                _selectData = chickData;
                chick_log.visible = true;
            }
            else
            {
                _selectData = unchickData;
                chick_log.visible = false;
            }
            return;
        }// end function

    }
}

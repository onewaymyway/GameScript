package KillerRoomMenu_fla
{
    import flash.display.*;
    import flash.events.*;

    dynamic public class Uselect_box_8 extends MovieClip
    {
        public var select_list:MovieClip;
        public var def:uint;
        public var labelArr:Array;
        public var len:uint;
        public var dataArr:Array;
        public var maskH:uint;
        public var _selectData:Object;
        public var selected_btn:MovieClip;

        public function Uselect_box_8()
        {
            addFrameScript(0, frame1);
            return;
        }// end function

        public function mouseUpFunc(param1)
        {
            if (!this.hitTestPoint(this.stage.mouseX, this.stage.mouseY, true))
            {
                select_list.visible = false;
                stage.removeEventListener(MouseEvent.MOUSE_DOWN, mouseUpFunc);
            }
            return;
        }// end function

        public function get selectData() : Object
        {
            return _selectData;
        }// end function

        public function set selectData(param1:Object) : void
        {
            _selectData = param1;
            var _loc_2:uint = 0;
            while (_loc_2 < len)
            {
                
                if (_selectData == dataArr[_loc_2])
                {
                    selected_btn.select_txt.text = labelArr[_loc_2];
                    break;
                }
                _loc_2 = _loc_2 + 1;
            }
            return;
        }// end function

        public function list(param1:uint = 0) : Boolean
        {
            var _loc_3:* = undefined;
            removeAllMc(select_list.lists);
            if (dataArr.length > labelArr.length)
            {
                len = dataArr.length;
            }
            else
            {
                len = labelArr.length;
            }
            var _loc_2:uint = 0;
            while (_loc_2 < len)
            {
                
                trace(this.name + "-" + labelArr[_loc_2]);
                _loc_3 = new select_data_mc();
                _loc_3._label = labelArr[_loc_2];
                _loc_3._data = dataArr[_loc_2];
                _loc_3.data_txt.text = labelArr[_loc_2];
                _loc_3.y = _loc_2 * 20;
                _loc_3.addEventListener(MouseEvent.MOUSE_DOWN, dataClickHandler);
                select_list.lists.addChild(_loc_3);
                if (_loc_2 == param1)
                {
                    _selectData = _loc_3._data;
                    selected_btn.select_txt.text = _loc_3._label;
                }
                _loc_2 = _loc_2 + 1;
            }
            select_list.lists.dispatchEvent(new Event(Event.CHANGE));
            return true;
        }// end function

        function frame1()
        {
            len = 0;
            select_list.mask_mc.height = maskH;
            select_list.scaleY = 1;
            select_list.y = 20;
            select_list.visible = false;
            selected_btn.buttonMode = true;
            selected_btn.addEventListener(MouseEvent.MOUSE_DOWN, selectClickHandler);
            if (dataArr)
            {
                list(def);
            }
            return;
        }// end function

        public function setData(param1:Object) : Boolean
        {
            dataArr = param1.dataArr;
            labelArr = param1.labelArr;
            def = param1.def;
            return list(def);
        }// end function

        public function removeAllMc(param1:Object, param2:Array = null, param3:Array = null) : void
        {
            var _loc_5:String = null;
            var _loc_4:* = param1.numChildren;
            while (_loc_4 > 0)
            {
                
                if (param2)
                {
                    for (_loc_5 in param2)
                    {
                        
                        if (param1.getChildAt(0).hasEventListener(param2[_loc_5]))
                        {
                            param1.getChildAt(0).removeEventListener(param2[_loc_5], param3[_loc_5]);
                        }
                    }
                }
                param1.removeChildAt(0);
                _loc_4 = _loc_4 - 1;
            }
            return;
        }// end function

        public function dataClickHandler(event:MouseEvent) : void
        {
            var _loc_2:* = event.currentTarget;
            _selectData = _loc_2._data;
            selected_btn.select_txt.text = _loc_2._label;
            select_list.visible = false;
            if (stage.hasEventListener(MouseEvent.MOUSE_DOWN))
            {
                stage.removeEventListener(MouseEvent.MOUSE_DOWN, mouseUpFunc);
            }
            this.dispatchEvent(new Event(Event.CHANGE));
            return;
        }// end function

        public function selectClickHandler(event:MouseEvent) : void
        {
            this.parent.setChildIndex(this, (this.parent.numChildren - 1));
            if (select_list.visible == false)
            {
                select_list.visible = true;
                if (!stage.hasEventListener(MouseEvent.MOUSE_DOWN))
                {
                    stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseUpFunc);
                }
            }
            else
            {
                select_list.visible = false;
                if (stage.hasEventListener(MouseEvent.MOUSE_DOWN))
                {
                    stage.removeEventListener(MouseEvent.MOUSE_DOWN, mouseUpFunc);
                }
            }
            return;
        }// end function

    }
}

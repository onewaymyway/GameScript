package uas
{
    import flash.events.*;

    public class SelectListsChild extends EventDispatcher
    {
        private var _selectData:Object;
        private var selectedMc:Object;
        private var _arrBox:Array;

        public function SelectListsChild()
        {
            this._arrBox = new Array();
            return;
        }// end function

        public function init() : void
        {
            this.selectedMc = null;
            return;
        }// end function

        public function setListsChilds(param1:Array, param2:Array) : void
        {
            var _loc_4:Object = null;
            this.cleanChild();
            var _loc_3:uint = 0;
            while (_loc_3 < param1.length)
            {
                
                _loc_4 = param1[_loc_3];
                if (!this.hasObj(_loc_4))
                {
                    this._arrBox.push(_loc_4);
                }
                _loc_4.mouseChildren = false;
                _loc_4.INFO = param2[_loc_3];
                _loc_4.buttonMode = true;
                _loc_4.useHandCursor = true;
                _loc_4.btn_bg.visible = false;
                if (!_loc_4.hasEventListener(MouseEvent.MOUSE_DOWN))
                {
                    _loc_4.addEventListener(MouseEvent.MOUSE_DOWN, this.mouseDownHandler);
                    _loc_4.addEventListener(MouseEvent.MOUSE_OVER, this.mouseHandler);
                    _loc_4.addEventListener(MouseEvent.MOUSE_OUT, this.mouseHandler);
                }
                _loc_3 = _loc_3 + 1;
            }
            return;
        }// end function

        public function addListChild(param1:Object, param2:Object) : void
        {
            if (!this.hasObj(param1))
            {
                this._arrBox.push(param1);
            }
            param1.INFO = param2;
            param1.buttonMode = true;
            param1.useHandCursor = true;
            param1.mouseChildren = false;
            param1.btn_bg.visible = false;
            if (!param1.hasEventListener(MouseEvent.MOUSE_DOWN))
            {
                param1.addEventListener(MouseEvent.MOUSE_DOWN, this.mouseDownHandler);
                param1.addEventListener(MouseEvent.MOUSE_OVER, this.mouseHandler);
                param1.addEventListener(MouseEvent.MOUSE_OUT, this.mouseHandler);
            }
            return;
        }// end function

        private function mouseHandler(event:MouseEvent) : void
        {
            var _loc_2:* = event.currentTarget;
            switch(event.type)
            {
                case MouseEvent.MOUSE_OVER:
                {
                    _loc_2.btn_bg.visible = true;
                    break;
                }
                case MouseEvent.MOUSE_OUT:
                {
                    _loc_2.btn_bg.visible = false;
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        private function mouseDownHandler(event:MouseEvent) : void
        {
            var _loc_2:* = event.currentTarget;
            _loc_2.btn_bg.visible = false;
            if (this.selectedMc != _loc_2)
            {
                this._selectData = _loc_2.INFO;
                this.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN));
            }
            return;
        }// end function

        private function hasObj(param1:Object) : Boolean
        {
            var _loc_2:uint = 0;
            while (_loc_2 < this._arrBox.length)
            {
                
                if (this._arrBox[_loc_2] == param1)
                {
                    return true;
                }
                _loc_2 = _loc_2 + 1;
            }
            return false;
        }// end function

        public function cleanChild() : void
        {
            this.selectedMc = null;
            var _loc_1:uint = 0;
            while (_loc_1 < this._arrBox.length)
            {
                
                if (this._arrBox[_loc_1].hasEventListener(MouseEvent.MOUSE_DOWN))
                {
                    this._arrBox[_loc_1].removeEventListener(MouseEvent.MOUSE_DOWN, this.mouseDownHandler);
                    this._arrBox[_loc_1].removeEventListener(MouseEvent.MOUSE_OVER, this.mouseHandler);
                    this._arrBox[_loc_1].removeEventListener(MouseEvent.MOUSE_OUT, this.mouseHandler);
                }
                _loc_1 = _loc_1 + 1;
            }
            this._arrBox = new Array();
            trace("cleanChild");
            return;
        }// end function

        public function get selectData() : Object
        {
            return this._selectData;
        }// end function

    }
}

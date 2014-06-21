package uas
{
    import flash.display.*;
    import flash.events.*;

    public class SelectList extends EventDispatcher
    {
        private var _selectData:Object;
        private var selectedMc:Object;
        private var ArrboxsVo:Array;
        private var Arrboxs:Array;
        private var _defIndex:uint = 0;

        public function SelectList()
        {
            return;
        }// end function

        public function def() : void
        {
            this.selectedMc = null;
            this.Arrboxs[this._defIndex].dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN));
            return;
        }// end function

        public function SetList(param1:Array, param2:Array, param3:int) : void
        {
            var _loc_5:MovieClip = null;
            this.ArrboxsVo = new Array();
            this.Arrboxs = new Array();
            var _loc_4:uint = 0;
            while (_loc_4 < param1.length)
            {
                
                _loc_5 = param1[_loc_4] as MovieClip;
                _loc_5.buttonMode = true;
                _loc_5.useHandCursor = true;
                _loc_5.addEventListener(MouseEvent.MOUSE_DOWN, this.mouseHandler);
                _loc_5.addEventListener(MouseEvent.MOUSE_OVER, this.mouseHandler);
                _loc_5.addEventListener(MouseEvent.MOUSE_OUT, this.mouseHandler);
                this.Arrboxs.push(_loc_5);
                this.ArrboxsVo.push(param2[_loc_4]);
                _loc_4 = _loc_4 + 1;
            }
            if (param3 > -1)
            {
                this._defIndex = param3;
                this.def();
            }
            return;
        }// end function

        public function addList(param1:Array, param2:Array, param3:int) : void
        {
            var _loc_5:MovieClip = null;
            var _loc_4:uint = 0;
            while (_loc_4 < param1.length)
            {
                
                _loc_5 = param1[_loc_4] as MovieClip;
                _loc_5.buttonMode = true;
                _loc_5.useHandCursor = true;
                _loc_5.addEventListener(MouseEvent.MOUSE_DOWN, this.mouseHandler);
                _loc_5.addEventListener(MouseEvent.MOUSE_OVER, this.mouseHandler);
                _loc_5.addEventListener(MouseEvent.MOUSE_OUT, this.mouseHandler);
                this.Arrboxs.push(_loc_5);
                this.ArrboxsVo.push(param2[_loc_4]);
                _loc_4 = _loc_4 + 1;
            }
            if (param3 > -1)
            {
                this._defIndex = param3;
                this.def();
            }
            return;
        }// end function

        private function mouseHandler(event:MouseEvent) : void
        {
            var _loc_3:uint = 0;
            var _loc_2:* = event.currentTarget as MovieClip;
            switch(event.type)
            {
                case MouseEvent.MOUSE_OVER:
                {
                    _loc_2.gotoAndStop(2);
                    break;
                }
                case MouseEvent.MOUSE_OUT:
                {
                    _loc_2.gotoAndStop(1);
                    break;
                }
                case MouseEvent.MOUSE_DOWN:
                {
                    _loc_3 = 0;
                    while (_loc_3 < this.Arrboxs.length)
                    {
                        
                        if (this.Arrboxs[_loc_3] == _loc_2)
                        {
                            this.selectedMc = _loc_2;
                            this._selectData = this.ArrboxsVo[_loc_3];
                            _loc_2.gotoAndPlay(3);
                        }
                        else
                        {
                            this.Arrboxs[_loc_3].gotoAndStop(1);
                        }
                        _loc_3 = _loc_3 + 1;
                    }
                    this.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN));
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        public function set index(param1:uint) : void
        {
            var _loc_2:uint = 0;
            while (_loc_2 < this.Arrboxs.length)
            {
                
                if (_loc_2 == param1)
                {
                    this.selectedMc = this.Arrboxs[_loc_2];
                    this._selectData = this.ArrboxsVo[_loc_2];
                    this.Arrboxs[_loc_2].gotoAndPlay(3);
                }
                else
                {
                    this.Arrboxs[_loc_2].gotoAndStop(1);
                }
                _loc_2 = _loc_2 + 1;
            }
            return;
        }// end function

        public function get selectData() : Object
        {
            return this._selectData;
        }// end function

    }
}

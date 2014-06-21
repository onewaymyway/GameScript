package uas
{
    import flash.display.*;
    import flash.events.*;

    public class SelectOneBox extends EventDispatcher
    {
        private var _selectData:Object;
        private var selectedMc:Object;
        private var ArrboxsVo:Array;
        private var Arrboxs:Array;
        private var _defIndex:uint = 0;

        public function SelectOneBox()
        {
            this.ArrboxsVo = new Array();
            this.Arrboxs = new Array();
            return;
        }// end function

        public function def() : void
        {
            this.selectedMc = null;
            this.Arrboxs[this._defIndex].dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN));
            return;
        }// end function

        public function SetBoxs(ARRBOXS:Array, ARRBOXSVO:Array, DEFINDEX:int) : void
        {
            var _loc_5:MovieClip = null;
            this.ArrboxsVo = new Array();
            this.Arrboxs = new Array();
            var _loc_4:uint = 0;
            while (_loc_4 < ARRBOXS.length)
            {
                
                _loc_5 = ARRBOXS[_loc_4] as MovieClip;
                _loc_5.mouseChildren = false;
                _loc_5.buttonMode = true;
                _loc_5.useHandCursor = true;
                _loc_5.addEventListener(MouseEvent.MOUSE_DOWN, this.mouseHandler);
                _loc_5.addEventListener(MouseEvent.MOUSE_OVER, this.mouseHandler);
                _loc_5.addEventListener(MouseEvent.MOUSE_OUT, this.mouseHandler);
                this.Arrboxs.push(_loc_5);
                this.ArrboxsVo.push(ARRBOXSVO[_loc_4]);
                _loc_4 = _loc_4 + 1;
            }
            if (DEFINDEX > -1)
            {
                this._defIndex = DEFINDEX;
                this.def();
            }
            return;
        }// end function

        public function addBoxs(ARRBOXS:Array, ARRBOXSVO:Array, DEFINDEX:int) : void
        {
            var _loc_5:MovieClip = null;
            var _loc_4:uint = 0;
            while (_loc_4 < ARRBOXS.length)
            {
                
                _loc_5 = ARRBOXS[_loc_4] as MovieClip;
                _loc_5.mouseChildren = false;
                _loc_5.buttonMode = true;
                _loc_5.useHandCursor = true;
                _loc_5.addEventListener(MouseEvent.MOUSE_DOWN, this.mouseHandler);
                _loc_5.addEventListener(MouseEvent.MOUSE_OVER, this.mouseHandler);
                _loc_5.addEventListener(MouseEvent.MOUSE_OUT, this.mouseHandler);
                this.Arrboxs.push(_loc_5);
                this.ArrboxsVo.push(ARRBOXSVO[_loc_4]);
                _loc_4 = _loc_4 + 1;
            }
            if (DEFINDEX > -1)
            {
                this._defIndex = DEFINDEX;
                this.Arrboxs[this._defIndex].dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN));
            }
            return;
        }// end function

        private function mouseHandler(event:MouseEvent) : void
        {
            var _loc_3:uint = 0;
            var _loc_2:* = event.currentTarget as MovieClip;
            if (this.selectedMc != _loc_2)
            {
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
                                this.Arrboxs[_loc_3].useHandCursor = false;
                                _loc_2.gotoAndPlay(3);
                            }
                            else
                            {
                                this.Arrboxs[_loc_3].useHandCursor = true;
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
            }
            return;
        }// end function

        public function set index(n:uint) : void
        {
            var _loc_2:uint = 0;
            while (_loc_2 < this.Arrboxs.length)
            {
                
                if (_loc_2 == n)
                {
                    this.selectedMc = this.Arrboxs[_loc_2];
                    this._selectData = this.ArrboxsVo[_loc_2];
                    this.Arrboxs[_loc_2].useHandCursor = false;
                    this.Arrboxs[_loc_2].gotoAndPlay(3);
                }
                else
                {
                    this.Arrboxs[_loc_2].useHandCursor = true;
                    this.Arrboxs[_loc_2].gotoAndStop(1);
                }
                _loc_2 = _loc_2 + 1;
            }
            return;
        }// end function

        public function get index() : uint
        {
            var _loc_1:uint = 0;
            while (_loc_1 < this.Arrboxs.length)
            {
                
                if (this._selectData == this.ArrboxsVo[_loc_1])
                {
                    return _loc_1;
                }
                _loc_1 = _loc_1 + 1;
            }
            return 0;
        }// end function

        public function cleanChild() : void
        {
            var _loc_1:uint = 0;
            while (_loc_1 < this.Arrboxs.length)
            {
                
                if (this.Arrboxs[_loc_1].hasEventListener(MouseEvent.MOUSE_DOWN))
                {
                    this.Arrboxs[_loc_1].removeEventListener(MouseEvent.MOUSE_DOWN, this.mouseHandler);
                    this.Arrboxs[_loc_1].removeEventListener(MouseEvent.MOUSE_OVER, this.mouseHandler);
                    this.Arrboxs[_loc_1].removeEventListener(MouseEvent.MOUSE_OUT, this.mouseHandler);
                }
                _loc_1 = _loc_1 + 1;
            }
            this.Arrboxs = null;
            this.ArrboxsVo = null;
            this.ArrboxsVo = new Array();
            this.Arrboxs = new Array();
            return;
        }// end function

        public function get selectData() : Object
        {
            return this._selectData;
        }// end function

    }
}

package honorVipOnline_box_fla
{
    import flash.display.*;
    import flash.events.*;
    import flash.utils.*;

    dynamic public class myscorllMc_40 extends MovieClip
    {
        public var HH:Object;
        public var down_btn:SimpleButton;
        public var markHH:Object;
        public var upBtn_H:Object;
        public var act:Object;
        public var Obj:Object;
        public var ObjHH:Object;
        public var objName:Object;
        public var downBtn_H:Object;
        public var Objmark:Object;
        public var mid_btn:MovieClip;
        public var ah:Object;
        public var toWhere:Object;
        public var objmarkName:Object;
        public var up_btn:SimpleButton;
        public var myTimer:Timer;
        public var delta:Object;

        public function myscorllMc_40()
        {
            addFrameScript(0, frame1);
            return;
        }// end function

        public function timerHandler(param1)
        {
            if (act == "up")
            {
                setObjY(delta);
            }
            else if (act == "down")
            {
                setObjY(-delta);
            }
            else if (act == "mid")
            {
                midYtoObj();
            }
            return;
        }// end function

        public function midYtoObj()
        {
            var _loc_2:* = undefined;
            ObjHH = Obj.height;
            markHH = Objmark.height;
            var _loc_1:* = ObjHH - markHH;
            if (_loc_1 > 0)
            {
                _loc_2 = (mid_btn.y - upBtn_H) / scH;
                Obj.y = (-_loc_1) * _loc_2 + Objmark.y;
            }
            else
            {
                Obj.y = 0 + Objmark.y;
            }
            return;
        }// end function

        public function setToBottom()
        {
            changelHandler(null);
            mid_btn.y = upBtn_H + scH;
            midYtoObj();
            return;
        }// end function

        public function get scH() : Number
        {
            return Number(HH - upBtn_H * 2 - midBtn_H);
        }// end function

        public function setMidY()
        {
            ObjHH = Obj.height;
            markHH = Objmark.height;
            var _loc_1:* = ObjHH - markHH;
            var _loc_2:* = (-Obj.y + Objmark.y) * scH / _loc_1 + upBtn_H;
            if (_loc_1 > 0)
            {
                if (_loc_2 < upBtn_H)
                {
                    mid_btn.y = upBtn_H;
                    myTimer.stop();
                    return;
                }
                if (_loc_2 > upBtn_H + scH)
                {
                    mid_btn.y = upBtn_H + scH;
                    myTimer.stop();
                    return;
                }
                mid_btn.y = _loc_2;
            }
            else
            {
                mid_btn.y = upBtn_H;
            }
            return;
        }// end function

        public function changelHandler(event:Event) : void
        {
            HH = Objmark.height + ah;
            ObjHH = Obj.height;
            markHH = Objmark.height;
            Obj.mask = Objmark;
            if (ObjHH - markHH > 0)
            {
                this.visible = true;
            }
            else
            {
                this.visible = false;
            }
            return;
        }// end function

        public function setObjY(param1)
        {
            ObjHH = Obj.height;
            markHH = Objmark.height;
            var _loc_2:* = ObjHH - markHH;
            var _loc_3:* = Obj.y + param1;
            if (_loc_2 > 0)
            {
                if (_loc_3 < -_loc_2 + Objmark.y)
                {
                    Obj.y = -_loc_2 + Objmark.y;
                }
                else if (_loc_3 > Objmark.y)
                {
                    Obj.y = Objmark.y;
                }
                else
                {
                    Obj.y = _loc_3;
                }
                setMidY();
            }
            return;
        }// end function

        public function tryToTop()
        {
            changelHandler(null);
            if (mid_btn.y <= upBtn_H + 5)
            {
                mid_btn.y = upBtn_H;
                midYtoObj();
            }
            else
            {
            }
            return;
        }// end function

        public function tryToBottom()
        {
            changelHandler(null);
            if (mid_btn.y >= HH - upBtn_H - mid_btn.height - 5)
            {
                mid_btn.y = upBtn_H + scH;
                midYtoObj();
            }
            else
            {
            }
            return;
        }// end function

        public function mouseUpFunc(param1)
        {
            mid_btn.stopDrag();
            act = "null";
            myTimer.stop();
            stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpFunc);
            return;
        }// end function

        function frame1()
        {
            this.visible = false;
            var _loc_1:int = 1;
            this.scaleY = 1;
            this.scaleX = _loc_1;
            Obj = MovieClip(parent)[objName];
            Objmark = MovieClip(parent)[objmarkName];
            Obj.mask = Objmark;
            HH = Objmark.height + ah;
            markHH = Objmark.height;
            upBtn_H = up_btn.height;
            downBtn_H = down_btn.height;
            mid_btn.y = upBtn_H;
            down_btn.y = HH - downBtn_H;
            if (toWhere == "top")
            {
                setToTop();
            }
            else
            {
                setToBottom();
            }
            act = "null";
            Obj.addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelHandler);
            Obj.addEventListener(Event.CHANGE, changelHandler);
            myTimer = new Timer(1000, 0);
            myTimer.addEventListener(TimerEvent.TIMER, timerHandler);
            myTimer.stop();
            up_btn.addEventListener(MouseEvent.MOUSE_DOWN, handlerFunc);
            mid_btn.addEventListener(MouseEvent.MOUSE_DOWN, handlerFunc);
            down_btn.addEventListener(MouseEvent.MOUSE_DOWN, handlerFunc);
            this.graphics.clear();
            this.graphics.beginFill(3355443, 1);
            this.graphics.drawRect(0, 0, this.width, this.height);
            this.graphics.endFill();
            return;
        }// end function

        public function handlerFunc(param1)
        {
            var _loc_2:* = param1.currentTarget.name;
            if (_loc_2 == "up_btn")
            {
                act = "up";
                setObjY(delta);
                myTimer.delay = 500;
                myTimer.start();
                if (!stage.hasEventListener(MouseEvent.MOUSE_UP))
                {
                    stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpFunc);
                }
            }
            else if (_loc_2 == "down_btn")
            {
                act = "down";
                setObjY(-delta);
                myTimer.delay = 500;
                myTimer.start();
                if (!stage.hasEventListener(MouseEvent.MOUSE_UP))
                {
                    stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpFunc);
                }
            }
            else if (_loc_2 == "mid_btn")
            {
                act = "mid";
                if (!stage.hasEventListener(MouseEvent.MOUSE_UP))
                {
                    stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpFunc);
                }
                mid_btn.startDrag(false, new Rectangle(0, upBtn_H, 0, scH));
                myTimer.delay = 50;
                myTimer.start();
            }
            return;
        }// end function

        public function setToTop()
        {
            changelHandler(null);
            mid_btn.y = upBtn_H;
            midYtoObj();
            return;
        }// end function

        public function mouseWheelHandler(event:MouseEvent) : void
        {
            setObjY(event.delta / 3 * delta);
            return;
        }// end function

        public function get midBtn_H() : Number
        {
            var _loc_1:Number = NaN;
            if (Obj.height > 0)
            {
                _loc_1 = Objmark.height / Obj.height;
                if (_loc_1 < 1)
                {
                    mid_btn.height = _loc_1 * (HH - upBtn_H - downBtn_H);
                }
            }
            return mid_btn.height;
        }// end function

    }
}

package Core.model.data
{
    import Core.*;
    import flash.display.*;

    dynamic public class NewUserTeskData extends Object
    {
        public var isNewUser:Boolean = true;
        public var isgetPrize:Boolean = false;
        public var nowStep:uint = 0;
        public var nowId:uint = 0;
        public var tasks:Object;
        public var stepBtns:Object;
        public var nowBtn:DisplayObject;
        private var myFacade:MyFacade;

        public function NewUserTeskData()
        {
            this.tasks = new Object();
            this.stepBtns = new Object();
            this.myFacade = MyFacade.getInstance();
            return;
        }// end function

        public function setTarget(param1:String, param2:DisplayObject) : void
        {
            if (param2)
            {
                this.stepBtns[param1] = param2;
            }
            return;
        }// end function

        public function getBtn(param1:String) : DisplayObject
        {
            this.nowBtn = this.stepBtns[param1];
            return this.nowBtn;
        }// end function

        public function IsNowBtn(param1:String) : Boolean
        {
            if (this.nowBtn == this.stepBtns[param1])
            {
                return true;
            }
            return false;
        }// end function

        public function clearBtn(param1:String) : void
        {
            this.stepBtns[param1] = null;
            return;
        }// end function

    }
}

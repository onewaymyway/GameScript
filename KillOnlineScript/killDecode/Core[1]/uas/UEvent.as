package uas
{
    import flash.events.*;

    public class UEvent extends Event
    {
        public var Data:Object;

        public function UEvent(param1:String, param2:Object = null)
        {
            super(param1);
            this.Data = param2;
            return;
        }// end function

    }
}

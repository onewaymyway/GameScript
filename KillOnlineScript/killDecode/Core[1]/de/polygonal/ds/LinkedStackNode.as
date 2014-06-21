package de.polygonal.ds
{
    import flash.*;

    public class LinkedStackNode extends Object
    {
        public var val:Object;
        public var next:LinkedStackNode;

        public function LinkedStackNode(param1:Object = ) : void
        {
            if (Boot.skip_constructor)
            {
                return;
            }
            val = param1;
            return;
        }// end function

        public function toString() : String
        {
            return Std.string(val);
        }// end function

    }
}

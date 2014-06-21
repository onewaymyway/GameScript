package de.polygonal.ds
{
    import flash.*;

    public class LinkedQueueNode extends Object
    {
        public var val:Object;
        public var next:LinkedQueueNode;

        public function LinkedQueueNode(param1:Object = ) : void
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
            return "" + val;
        }// end function

    }
}

package Core.cmd
{

    public class JsCmd extends Object
    {
        private var cmd:Object;
        private var name:String;

        public function JsCmd(param1:String) : void
        {
            this.cmd = new Object();
            this.name = param1;
            return;
        }// end function

        public function getCmd() : Object
        {
            return this.cmd;
        }// end function

        public function getName() : String
        {
            return this.name;
        }// end function

    }
}

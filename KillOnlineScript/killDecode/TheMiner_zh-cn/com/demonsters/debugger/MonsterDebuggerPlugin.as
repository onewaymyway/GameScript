package com.demonsters.debugger
{

    public class MonsterDebuggerPlugin extends Object
    {
        private var _id:String;

        public function MonsterDebuggerPlugin(id:String)
        {
            this._id = id;
            return;
        }// end function

        public function get id() : String
        {
            return this._id;
        }// end function

        protected function send(data:Object) : void
        {
            MonsterDebugger.send(this._id, data);
            return;
        }// end function

        public function handle(item:MonsterDebuggerData) : void
        {
            return;
        }// end function

    }
}

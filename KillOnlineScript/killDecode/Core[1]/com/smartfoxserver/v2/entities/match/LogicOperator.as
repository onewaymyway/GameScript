package com.smartfoxserver.v2.entities.match
{

    public class LogicOperator extends Object
    {
        private var _id:String;
        public static const AND:LogicOperator = new LogicOperator("AND");
        public static const OR:LogicOperator = new LogicOperator("OR");

        public function LogicOperator(param1:String)
        {
            this._id = param1;
            return;
        }// end function

        public function get id() : String
        {
            return this._id;
        }// end function

    }
}

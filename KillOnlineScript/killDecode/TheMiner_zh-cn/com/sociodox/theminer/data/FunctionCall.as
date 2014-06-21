package com.sociodox.theminer.data
{

    public class FunctionCall extends Object
    {
        public var _fqcn:String;
        public var _lineNumber:uint;
        public var _methodName:String;
        public var _methodArguments:String;
        private static var mNext:int = 0;

        public function FunctionCall(fqcn:String, lineNumber:uint, methodName:String, methodArguments:String)
        {
            this._fqcn = fqcn;
            this._lineNumber = lineNumber;
            this._methodName = methodName;
            this._methodArguments = methodArguments;
            return;
        }// end function

    }
}

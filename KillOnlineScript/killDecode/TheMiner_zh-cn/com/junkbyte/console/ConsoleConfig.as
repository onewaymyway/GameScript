package com.junkbyte.console
{
    import flash.utils.*;

    public class ConsoleConfig extends Object
    {
        public var keystrokePassword:String;
        public var remotingPassword:String;
        public var maxLines:uint = 1000;
        public var maxRepeats:int = 75;
        public var autoStackPriority:int = 10;
        public var defaultStackDepth:int = 2;
        public var useObjectLinking:Boolean = true;
        public var objectHardReferenceTimer:uint = 0;
        public var tracing:Boolean;
        public var traceCall:Function;
        public var showTimestamp:Boolean = false;
        public var timeStampFormatter:Function;
        public var showLineNumber:Boolean = false;
        private var _stackIgnoredExp:RegExp;
        public var remotingConnectionName:String = "_Console";
        public var allowedRemoteDomain:String = "*";
        public var commandLineAllowed:Boolean;
        public var commandLineAutoScope:Boolean;
        public var commandLineInputPassThrough:Function;
        public var commandLineAutoCompleteEnabled:Boolean = true;
        public var keyBindsEnabled:Boolean = true;
        public var displayRollerEnabled:Boolean = true;
        public var sharedObjectName:String = "com.junkbyte/Console/UserData";
        public var sharedObjectPath:String = "/";
        public var rememberFilterSettings:Boolean;
        public var alwaysOnTop:Boolean = true;
        private var _style:ConsoleStyle;

        public function ConsoleConfig()
        {
            this.traceCall = function (ch:String, line:String, ... args) : void
            {
                trace("[" + ch + "] " + line);
                return;
            }// end function
            ;
            this.timeStampFormatter = function (timer:uint) : String
            {
                var _loc_2:* = timer * 0.001;
                return this.makeTimeDigit(_loc_2 / 60) + ":" + this.makeTimeDigit(_loc_2 % 60);
            }// end function
            ;
            this._stackIgnoredExp = new RegExp("Function|" + this.addDotSlash(getQualifiedClassName(Console)) + "|" + this.addDotSlash(getQualifiedClassName(Cc)));
            this._style = new ConsoleStyle();
            return;
        }// end function

        private function makeTimeDigit(v:uint) : String
        {
            if (v < 10)
            {
                return "0" + v;
            }
            return String(v);
        }// end function

        public function get stackTraceIgnoreExpression() : RegExp
        {
            return this._stackIgnoredExp;
        }// end function

        public function addStackTraceIgnoreClass(classToIgnore:Class) : void
        {
            var _loc_2:* = "|" + this.addDotSlash(getQualifiedClassName(classToIgnore));
            var _loc_3:* = this._stackIgnoredExp.source;
            var _loc_4:* = _loc_3.indexOf(_loc_2);
            var _loc_5:* = _loc_4 + _loc_2.length;
            if (_loc_4 >= 0)
            {
                if (_loc_5 < _loc_3.length)
                {
                }
            }
            if (_loc_3.charAt(_loc_5) != "|")
            {
                _loc_3 = _loc_3 + _loc_2;
                this._stackIgnoredExp = new RegExp(_loc_3 + _loc_2);
            }
            return;
        }// end function

        private function addDotSlash(string:String) : String
        {
            return string.replace(/\.""\./g, "\\.");
        }// end function

        public function get style() : ConsoleStyle
        {
            return this._style;
        }// end function

    }
}

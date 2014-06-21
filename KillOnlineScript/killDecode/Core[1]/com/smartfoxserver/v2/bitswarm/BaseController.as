package com.smartfoxserver.v2.bitswarm
{
    import com.smartfoxserver.v2.exceptions.*;
    import com.smartfoxserver.v2.logging.*;

    public class BaseController extends Object implements IController
    {
        protected var _id:int = -1;
        protected var log:Logger;

        public function BaseController()
        {
            this.log = Logger.getInstance();
            return;
        }// end function

        public function get id() : int
        {
            return this._id;
        }// end function

        public function set id(param1:int) : void
        {
            if (this._id == -1)
            {
                this._id = param1;
            }
            else
            {
                throw new SFSError("Controller ID is already set: " + this._id + ". Can\'t be changed at runtime!");
            }
            return;
        }// end function

        public function handleMessage(param1:IMessage) : void
        {
            trace("System controller got request: " + param1);
            return;
        }// end function

    }
}

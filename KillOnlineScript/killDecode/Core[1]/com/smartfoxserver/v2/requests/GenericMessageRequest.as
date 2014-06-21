package com.smartfoxserver.v2.requests
{
    import com.smartfoxserver.v2.*;
    import com.smartfoxserver.v2.entities.*;
    import com.smartfoxserver.v2.entities.data.*;
    import com.smartfoxserver.v2.exceptions.*;
    import com.smartfoxserver.v2.logging.*;
    import de.polygonal.ds.*;

    public class GenericMessageRequest extends BaseRequest
    {
        protected var _type:int = -1;
        protected var _room:Room;
        protected var _user:User;
        protected var _message:String;
        protected var _params:ISFSObject;
        protected var _recipient:Object;
        protected var _sendMode:int = -1;
        protected var _log:Logger;
        public static const KEY_ROOM_ID:String = "r";
        public static const KEY_USER_ID:String = "u";
        public static const KEY_MESSAGE:String = "m";
        public static const KEY_MESSAGE_TYPE:String = "t";
        public static const KEY_RECIPIENT:String = "rc";
        public static const KEY_RECIPIENT_MODE:String = "rm";
        public static const KEY_XTRA_PARAMS:String = "p";
        public static const KEY_SENDER_DATA:String = "sd";

        public function GenericMessageRequest()
        {
            super(BaseRequest.GenericMessage);
            this._log = Logger.getInstance();
            return;
        }// end function

        override public function validate(param1:SmartFox) : void
        {
            if (this._type < 0)
            {
                throw new SFSValidationError("PublicMessage request error", ["Unsupported message type: " + this._type]);
            }
            var _loc_2:Array = [];
            switch(this._type)
            {
                case GenericMessageType.PUBLIC_MSG:
                {
                    this.validatePublicMessage(param1, _loc_2);
                    break;
                }
                case GenericMessageType.PRIVATE_MSG:
                {
                    this.validatePrivateMessage(param1, _loc_2);
                    break;
                }
                case GenericMessageType.OBJECT_MSG:
                {
                    this.validateObjectMessage(param1, _loc_2);
                    break;
                }
                case GenericMessageType.BUDDY_MSG:
                {
                    this.validateBuddyMessage(param1, _loc_2);
                    break;
                }
                default:
                {
                    this.validateSuperUserMessage(param1, _loc_2);
                    break;
                }
            }
            if (_loc_2.length > 0)
            {
                throw new SFSValidationError("Request error - ", _loc_2);
            }
            return;
        }// end function

        override public function execute(param1:SmartFox) : void
        {
            _sfso.putByte(KEY_MESSAGE_TYPE, this._type);
            switch(this._type)
            {
                case GenericMessageType.PUBLIC_MSG:
                {
                    this.executePublicMessage(param1);
                    break;
                }
                case GenericMessageType.PRIVATE_MSG:
                {
                    this.executePrivateMessage(param1);
                    break;
                }
                case GenericMessageType.OBJECT_MSG:
                {
                    this.executeObjectMessage(param1);
                    break;
                }
                case GenericMessageType.BUDDY_MSG:
                {
                    this.executeBuddyMessage(param1);
                    break;
                }
                default:
                {
                    this.executeSuperUserMessage(param1);
                    break;
                }
            }
            return;
        }// end function

        private function validatePublicMessage(param1:SmartFox, param2:Array) : void
        {
            if (this._message == null || this._message.length == 0)
            {
                param2.push("Public message is empty!");
            }
            if (this._room != null && !param1.mySelf.isJoinedInRoom(this._room))
            {
                param2.push("You are not joined in the target Room: " + this._room);
            }
            return;
        }// end function

        private function validatePrivateMessage(param1:SmartFox, param2:Array) : void
        {
            if (this._message == null || this._message.length == 0)
            {
                param2.push("Private message is empty!");
            }
            if (this._recipient < 0)
            {
                param2.push("Invalid recipient id: " + this._recipient);
            }
            return;
        }// end function

        private function validateObjectMessage(param1:SmartFox, param2:Array) : void
        {
            if (this._params == null)
            {
                param2.push("Object message is null!");
            }
            return;
        }// end function

        private function validateBuddyMessage(param1:SmartFox, param2:Array) : void
        {
            if (!param1.buddyManager.isInited)
            {
                param2.push("BuddyList is not inited. Please send an InitBuddyRequest first.");
            }
            if (param1.buddyManager.myOnlineState == false)
            {
                param2.push("Can\'t send messages while off-line");
            }
            if (this._message == null || this._message.length == 0)
            {
                param2.push("Buddy message is empty!");
            }
            var _loc_3:* = Number(this._recipient);
            if (_loc_3 < 0)
            {
                param2.push("Recipient is not online or not in your buddy list");
            }
            return;
        }// end function

        private function validateSuperUserMessage(param1:SmartFox, param2:Array) : void
        {
            if (this._message == null || this._message.length == 0)
            {
                param2.push("Moderator message is empty!");
            }
            switch(this._sendMode)
            {
                case MessageRecipientMode.TO_USER:
                {
                    if (!(this._recipient is User))
                    {
                        param2.push("TO_USER expects a User object as recipient");
                    }
                    break;
                }
                case MessageRecipientMode.TO_ROOM:
                {
                    if (!(this._recipient is Room))
                    {
                        param2.push("TO_ROOM expects a Room object as recipient");
                    }
                    break;
                }
                case MessageRecipientMode.TO_GROUP:
                {
                    if (!(this._recipient is String))
                    {
                        param2.push("TO_GROUP expects a String object (the groupId) as recipient");
                    }
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        private function executePublicMessage(param1:SmartFox) : void
        {
            if (this._room == null)
            {
                this._room = param1.lastJoinedRoom;
            }
            if (this._room == null)
            {
                throw new SFSError("User should be joined in a room in order to send a public message");
            }
            _sfso.putInt(KEY_ROOM_ID, this._room.id);
            _sfso.putInt(KEY_USER_ID, param1.mySelf.id);
            _sfso.putUtfString(KEY_MESSAGE, this._message);
            if (this._params != null)
            {
                _sfso.putSFSObject(KEY_XTRA_PARAMS, this._params);
            }
            return;
        }// end function

        private function executePrivateMessage(param1:SmartFox) : void
        {
            _sfso.putInt(KEY_RECIPIENT, this._recipient as int);
            _sfso.putUtfString(KEY_MESSAGE, this._message);
            if (this._params != null)
            {
                _sfso.putSFSObject(KEY_XTRA_PARAMS, this._params);
            }
            return;
        }// end function

        private function executeBuddyMessage(param1:SmartFox) : void
        {
            _sfso.putInt(KEY_RECIPIENT, this._recipient as int);
            _sfso.putUtfString(KEY_MESSAGE, this._message);
            if (this._params != null)
            {
                _sfso.putSFSObject(KEY_XTRA_PARAMS, this._params);
            }
            return;
        }// end function

        private function executeSuperUserMessage(param1:SmartFox) : void
        {
            _sfso.putUtfString(KEY_MESSAGE, this._message);
            if (this._params != null)
            {
                _sfso.putSFSObject(KEY_XTRA_PARAMS, this._params);
            }
            _sfso.putInt(KEY_RECIPIENT_MODE, this._sendMode);
            switch(this._sendMode)
            {
                case MessageRecipientMode.TO_USER:
                {
                    _sfso.putInt(KEY_RECIPIENT, this._recipient.id);
                    break;
                }
                case MessageRecipientMode.TO_ROOM:
                {
                    _sfso.putInt(KEY_RECIPIENT, this._recipient.id);
                    break;
                }
                case MessageRecipientMode.TO_GROUP:
                {
                    _sfso.putUtfString(KEY_RECIPIENT, this._recipient);
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        private function executeObjectMessage(param1:SmartFox) : void
        {
            var _loc_3:Array = null;
            var _loc_4:* = undefined;
            if (this._room == null)
            {
                this._room = param1.lastJoinedRoom;
            }
            var _loc_2:* = new ListSet();
            if (this._recipient is Array)
            {
                _loc_3 = this._recipient as Array;
                if (_loc_3.length > this._room.capacity)
                {
                    throw new ArgumentError("The number of recipients is bigger than the target Room capacity: " + _loc_3.length);
                }
                for each (_loc_4 in _loc_3)
                {
                    
                    if (_loc_4 is User)
                    {
                        _loc_2.set(_loc_4.id);
                        continue;
                    }
                    this._log.warn("Bad recipient in ObjectMessage recipient list: " + (typeof(_loc_4)) + ", expected type: User");
                }
            }
            _sfso.putInt(KEY_ROOM_ID, this._room.id);
            _sfso.putSFSObject(KEY_XTRA_PARAMS, this._params);
            if (_loc_2.size() > 0)
            {
                _sfso.putIntArray(KEY_RECIPIENT, _loc_2.toDA().getArray());
            }
            return;
        }// end function

    }
}

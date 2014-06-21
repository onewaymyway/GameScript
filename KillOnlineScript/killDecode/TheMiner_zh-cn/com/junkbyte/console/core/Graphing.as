package com.junkbyte.console.core
{
    import com.junkbyte.console.*;
    import com.junkbyte.console.vos.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.utils.*;

    public class Graphing extends ConsoleCore
    {
        protected var _groups:Array;
        protected var _map:Object;
        protected var _fpsGroup:GraphGroup;
        protected var _memGroup:GraphGroup;
        protected var _groupAddedDispatcher:CcCallbackDispatcher;

        public function Graphing(m:Console)
        {
            var m:* = m;
            this._groups = [];
            this._map = {};
            this._groupAddedDispatcher = new CcCallbackDispatcher();
            super(m);
            remoter.addEventListener(Event.CONNECT, this.onRemoteConnection);
            remoter.registerCallback("fps", function (bytes:ByteArray) : void
            {
                fpsMonitor = !fpsMonitor;
                return;
            }// end function
            );
            remoter.registerCallback("mem", function (bytes:ByteArray) : void
            {
                memoryMonitor = !memoryMonitor;
                return;
            }// end function
            );
            remoter.registerCallback("removeGraphGroup", this.onRemotingRemoveGraphGroup);
            remoter.registerCallback("menuGraphGroup", this.onRemotingMenuGraphGroup);
            return;
        }// end function

        public function add(n:String, obj:Object, prop:String, col:Number = -1, key:String = null, rect:Rectangle = null, inverse:Boolean = false) : GraphGroup
        {
            var newGroup:Boolean;
            var i:GraphInterest;
            var n:* = n;
            var obj:* = obj;
            var prop:* = prop;
            var col:* = col;
            var key:* = key;
            var rect:* = rect;
            var inverse:* = inverse;
            if (obj == null)
            {
                report("ERROR: Graph [" + n + "] received a null object to graph property [" + prop + "].", 10);
                return null;
            }
            var group:* = this._map[n];
            if (!group)
            {
                newGroup;
                group = new GraphGroup(n);
            }
            var interests:* = group.interests;
            if (!isNaN(col))
            {
                isNaN(col);
            }
            if (col < 0)
            {
                if (interests.length <= 5)
                {
                    col = config.style["priority" + (10 - interests.length * 2)];
                }
                else
                {
                    col = Math.random() * 16777215;
                }
            }
            if (key == null)
            {
                key = prop;
            }
            var _loc_9:int = 0;
            var _loc_10:* = interests;
            while (_loc_10 in _loc_9)
            {
                
                i = _loc_10[_loc_9];
                if (i.key == key)
                {
                    report("Graph with key [" + key + "] already exists in [" + n + "]", 10);
                    return null;
                }
            }
            if (rect)
            {
                group.rect = rect;
            }
            if (inverse)
            {
                group.inverted = inverse;
            }
            var interest:* = new GraphInterest(key, col);
            var v:* = NaN;
            try
            {
                v = interest.setObject(obj, prop);
            }
            catch (e:Error)
            {
                report("Error with graph value for [" + key + "] in [" + n + "]. " + e, 10);
                return null;
            }
            if (isNaN(v))
            {
                report("Graph value for key [" + key + "] in [" + n + "] is not a number (NaN).", 10);
            }
            else
            {
                group.interests.push(interest);
                if (newGroup)
                {
                    this._map[n] = group;
                    this.addGroup(group);
                }
            }
            return group;
        }// end function

        public function remove(n:String, obj:Object = null, prop:String = null) : void
        {
            var _loc_5:Array = null;
            var _loc_6:int = 0;
            var _loc_7:GraphInterest = null;
            var _loc_4:* = this._map[n];
            if (_loc_4)
            {
                if (obj == null)
                {
                }
                if (prop == null)
                {
                    _loc_4.close();
                }
                else
                {
                    _loc_5 = _loc_4.interests;
                    _loc_6 = _loc_5.length - 1;
                    while (_loc_6 >= 0)
                    {
                        
                        _loc_7 = _loc_5[_loc_6];
                        if (obj != null)
                        {
                        }
                        if (_loc_7.obj == obj)
                        {
                            if (prop != null)
                            {
                            }
                        }
                        if (_loc_7.prop == prop)
                        {
                            _loc_5.splice(_loc_6, 1);
                        }
                        _loc_6 = _loc_6 - 1;
                    }
                    if (_loc_5.length == 0)
                    {
                        _loc_4.close();
                    }
                }
            }
            return;
        }// end function

        public function fixRange(name:String, min:Number = NaN, max:Number = NaN) : void
        {
            var _loc_4:* = this._map[name];
            if (_loc_4)
            {
                _loc_4.fixedMin = min;
                _loc_4.fixedMax = max;
            }
            return;
        }// end function

        public function get onGroupAdded() : CcCallbackDispatcher
        {
            return this._groupAddedDispatcher;
        }// end function

        public function get fpsMonitor() : Boolean
        {
            return this._fpsGroup != null;
        }// end function

        public function set fpsMonitor(b:Boolean) : void
        {
            if (b)
            {
                if (this._fpsGroup)
                {
                    return;
                }
                this._fpsGroup = new GraphFPSGroup(console);
                this._fpsGroup.onClose.add(this.onFPSGroupClose);
                this.addGroup(this._fpsGroup);
                console.panels.mainPanel.updateMenu();
            }
            else if (this._fpsGroup)
            {
                this._fpsGroup.close();
            }
            return;
        }// end function

        private function onFPSGroupClose(group:GraphGroup) : void
        {
            this._fpsGroup = null;
            console.panels.mainPanel.updateMenu();
            return;
        }// end function

        public function get memoryMonitor() : Boolean
        {
            return this._memGroup != null;
        }// end function

        public function set memoryMonitor(b:Boolean) : void
        {
            if (b)
            {
                if (this._memGroup)
                {
                    return;
                }
                this._memGroup = new GraphMemoryGroup(console);
                this._memGroup.onClose.add(this.onMemGroupClose);
                this.addGroup(this._memGroup);
                console.panels.mainPanel.updateMenu();
            }
            else if (this._memGroup)
            {
                this._memGroup.close();
            }
            return;
        }// end function

        private function onMemGroupClose(group:GraphGroup) : void
        {
            this._memGroup = null;
            console.panels.mainPanel.updateMenu();
            return;
        }// end function

        public function addGroup(group:GraphGroup) : void
        {
            if (this._groups.indexOf(group) < 0)
            {
                this._groups.push(group);
                group.onClose.add(this.onGroupClose);
                this._groupAddedDispatcher.apply(group);
                this.syncAddGroup(group);
            }
            return;
        }// end function

        protected function onGroupClose(group:GraphGroup) : void
        {
            var _loc_2:* = this._groups.indexOf(group);
            if (_loc_2 >= 0)
            {
                this._groups.splice(_loc_2, 1);
                this.syncRemoveGroup(_loc_2);
            }
            return;
        }// end function

        public function update(timeDelta:uint) : void
        {
            var _loc_2:GraphGroup = null;
            for each (_loc_2 in this._groups)
            {
                
                _loc_2.tick(timeDelta);
            }
            return;
        }// end function

        protected function onRemoteConnection(event:Event) : void
        {
            var _loc_3:GraphGroup = null;
            var _loc_2:* = new ByteArray();
            _loc_2.writeShort(this._groups.length);
            for each (_loc_3 in this._groups)
            {
                
                _loc_3.writeToBytes(_loc_2);
                this.setupSyncGroupUpdate(_loc_3);
            }
            remoter.send("graphGroups", _loc_2);
            return;
        }// end function

        protected function onRemotingRemoveGraphGroup(bytes:ByteArray) : void
        {
            var _loc_2:* = bytes.readShort();
            var _loc_3:* = this._groups[_loc_2];
            if (_loc_3)
            {
                _loc_3.close();
            }
            return;
        }// end function

        protected function onRemotingMenuGraphGroup(bytes:ByteArray) : void
        {
            var _loc_2:* = bytes.readShort();
            var _loc_3:* = bytes.readUTF();
            var _loc_4:* = this._groups[_loc_2];
            if (_loc_4)
            {
                _loc_4.onMenu.apply(_loc_3);
            }
            return;
        }// end function

        protected function syncAddGroup(group:GraphGroup) : void
        {
            var _loc_2:ByteArray = null;
            if (remoter.connected)
            {
                _loc_2 = new ByteArray();
                group.writeToBytes(_loc_2);
                remoter.send("addGraphGroup", _loc_2);
                this.setupSyncGroupUpdate(group);
            }
            return;
        }// end function

        protected function syncRemoveGroup(index:int) : void
        {
            var _loc_2:ByteArray = null;
            if (remoter.connected)
            {
                _loc_2 = new ByteArray();
                _loc_2.writeShort(index);
                remoter.send("removeGraphGroup", _loc_2);
            }
            return;
        }// end function

        protected function setupSyncGroupUpdate(group:GraphGroup) : void
        {
            var group:* = group;
            group.onUpdate.add(function (values:Array) : void
            {
                syncGroupUpdate(group, values);
                return;
            }// end function
            );
            return;
        }// end function

        protected function syncGroupUpdate(group:GraphGroup, values:Array) : void
        {
            var _loc_3:int = 0;
            var _loc_4:ByteArray = null;
            var _loc_5:Number = NaN;
            if (remoter.connected)
            {
                _loc_3 = this._groups.indexOf(group);
                if (_loc_3 < 0)
                {
                    return;
                }
                _loc_4 = new ByteArray();
                _loc_4.writeShort(_loc_3);
                for each (_loc_5 in values)
                {
                    
                    _loc_4.writeDouble(_loc_5);
                }
                remoter.send("updateGraphGroup", _loc_4);
            }
            return;
        }// end function

    }
}

package com.junkbyte.console.core
{
    import com.junkbyte.console.*;
    import com.junkbyte.console.vos.*;
    import flash.events.*;
    import flash.utils.*;

    public class Logs extends ConsoleCore
    {
        private var _channels:Object;
        private var _repeating:uint;
        private var _lastRepeat:Log;
        private var _newRepeat:Log;
        private var _timer:uint;
        public var hasNewLog:Boolean;
        public var first:Log;
        public var last:Log;
        private var _length:uint;
        private var _lines:uint;

        public function Logs(console:Console)
        {
            super(console);
            this._channels = new Object();
            remoter.addEventListener(Event.CONNECT, this.onRemoteConnection);
            return;
        }// end function

        private function onRemoteConnection(event:Event) : void
        {
            var _loc_2:* = this.first;
            while (_loc_2)
            {
                
                this.send2Remote(_loc_2);
                _loc_2 = _loc_2.next;
            }
            return;
        }// end function

        protected function send2Remote(line:Log) : void
        {
            var _loc_2:ByteArray = null;
            if (remoter.connected)
            {
                _loc_2 = new ByteArray();
                line.writeToBytes(_loc_2);
                remoter.send("log", _loc_2);
            }
            return;
        }// end function

        public function update(time:uint) : void
        {
            this._timer = time;
            if (this._repeating > 0)
            {
                var _loc_2:String = this;
                var _loc_3:* = this._repeating - 1;
                _loc_2._repeating = _loc_3;
            }
            if (this._newRepeat)
            {
                if (this._lastRepeat)
                {
                    this.remove(this._lastRepeat);
                }
                this._lastRepeat = this._newRepeat;
                this._newRepeat = null;
                this.push(this._lastRepeat);
            }
            return;
        }// end function

        public function add(line:Log) : void
        {
            var _loc_2:String = this;
            var _loc_3:* = this._lines + 1;
            _loc_2._lines = _loc_3;
            line.line = this._lines;
            line.time = this._timer;
            this.registerLog(line);
            return;
        }// end function

        protected function registerLog(line:Log) : void
        {
            this.hasNewLog = true;
            this.addChannel(line.ch);
            line.lineStr = line.line + " ";
            line.chStr = "[<a href=\"event:channel_" + line.ch + "\">" + line.ch + "</a>] ";
            line.timeStr = config.timeStampFormatter(line.time) + " ";
            this.send2Remote(line);
            if (line.repeat)
            {
                if (this._repeating > 0)
                {
                }
                if (this._lastRepeat)
                {
                    line.line = this._lastRepeat.line;
                    this._newRepeat = line;
                    return;
                }
                this._repeating = config.maxRepeats;
                this._lastRepeat = line;
            }
            this.push(line);
            do
            {
                
                this.remove(this.first);
                if (this._length > config.maxLines)
                {
                }
            }while (config.maxLines > 0)
            if (config.tracing)
            {
            }
            if (config.traceCall != null)
            {
                config.traceCall(line.ch, line.plainText(), line.priority);
            }
            return;
        }// end function

        public function clear(channel:String = null) : void
        {
            var _loc_2:Log = null;
            if (channel)
            {
                _loc_2 = this.first;
                while (_loc_2)
                {
                    
                    if (_loc_2.ch == channel)
                    {
                        this.remove(_loc_2);
                    }
                    _loc_2 = _loc_2.next;
                }
                delete this._channels[channel];
            }
            else
            {
                this.first = null;
                this.last = null;
                this._length = 0;
                this._channels = new Object();
            }
            return;
        }// end function

        public function getLogsAsString(splitter:String, incChNames:Boolean = true, filter:Function = null) : String
        {
            var _loc_4:String = "";
            var _loc_5:* = this.first;
            while (_loc_5)
            {
                
                if (filter != null)
                {
                }
                if (this.filter(_loc_5))
                {
                    if (this.first != _loc_5)
                    {
                        _loc_4 = _loc_4 + splitter;
                    }
                    _loc_4 = _loc_4 + (incChNames ? (_loc_5.toString()) : (_loc_5.plainText()));
                }
                _loc_5 = _loc_5.next;
            }
            return _loc_4;
        }// end function

        public function getChannels() : Array
        {
            var _loc_3:String = null;
            var _loc_1:* = new Array(ConsoleChannel.GLOBAL_CHANNEL);
            this.addIfexist(ConsoleChannel.DEFAULT_CHANNEL, _loc_1);
            this.addIfexist(ConsoleChannel.FILTER_CHANNEL, _loc_1);
            this.addIfexist(LogReferences.INSPECTING_CHANNEL, _loc_1);
            this.addIfexist(ConsoleChannel.CONSOLE_CHANNEL, _loc_1);
            var _loc_2:* = new Array();
            for (_loc_3 in this._channels)
            {
                
                if (_loc_1.indexOf(_loc_3) < 0)
                {
                    _loc_2.push(_loc_3);
                }
            }
            return _loc_1.concat(_loc_2.sort(Array.CASEINSENSITIVE));
        }// end function

        private function addIfexist(n:String, arr:Array) : void
        {
            if (this._channels.hasOwnProperty(n))
            {
                arr.push(n);
            }
            return;
        }// end function

        public function cleanChannels() : void
        {
            this._channels = new Object();
            var _loc_1:* = this.first;
            while (_loc_1)
            {
                
                this.addChannel(_loc_1.ch);
                _loc_1 = _loc_1.next;
            }
            return;
        }// end function

        public function addChannel(n:String) : void
        {
            this._channels[n] = null;
            return;
        }// end function

        private function push(v:Log) : void
        {
            if (this.last == null)
            {
                this.first = v;
            }
            else
            {
                this.last.next = v;
                v.prev = this.last;
            }
            this.last = v;
            var _loc_2:String = this;
            var _loc_3:* = this._length + 1;
            _loc_2._length = _loc_3;
            return;
        }// end function

        private function remove(log:Log) : void
        {
            if (this.first == log)
            {
                this.first = log.next;
            }
            if (this.last == log)
            {
                this.last = log.prev;
            }
            if (log == this._lastRepeat)
            {
                this._lastRepeat = null;
            }
            if (log == this._newRepeat)
            {
                this._newRepeat = null;
            }
            if (log.next != null)
            {
                log.next.prev = log.prev;
            }
            if (log.prev != null)
            {
                log.prev.next = log.next;
            }
            var _loc_2:String = this;
            var _loc_3:* = this._length - 1;
            _loc_2._length = _loc_3;
            return;
        }// end function

    }
}

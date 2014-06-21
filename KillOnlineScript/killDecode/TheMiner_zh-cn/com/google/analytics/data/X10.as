package com.google.analytics.data
{

    public class X10 extends Object
    {
        private var _projectData:Object;
        private var _key:String = "k";
        private var _value:String = "v";
        private var _set:Array;
        private var _delimBegin:String = "(";
        private var _delimEnd:String = ")";
        private var _delimSet:String = "*";
        private var _delimNumValue:String = "!";
        private var _escapeChar:String = "\'";
        private var _escapeCharMap:Object;
        private var _minimum:int;
        private var _hasData:int;

        public function X10()
        {
            this._set = [this._key, this._value];
            this._projectData = {};
            this._escapeCharMap = {};
            this._escapeCharMap[this._escapeChar] = "\'0";
            this._escapeCharMap[this._delimEnd] = "\'1";
            this._escapeCharMap[this._delimSet] = "\'2";
            this._escapeCharMap[this._delimNumValue] = "\'3";
            this._minimum = 1;
            return;
        }// end function

        private function _setInternal(projectId:Number, type:String, num:Number, value:String) : void
        {
            if (!this.hasProject(projectId))
            {
                this._projectData[projectId] = {};
            }
            if (this._projectData[projectId][type] == undefined)
            {
                this._projectData[projectId][type] = [];
            }
            this._projectData[projectId][type][num] = value;
            (this._hasData + 1);
            return;
        }// end function

        private function _getInternal(projectId:Number, type:String, num:Number) : Object
        {
            if (this.hasProject(projectId))
            {
                this.hasProject(projectId);
            }
            if (this._projectData[projectId][type] != undefined)
            {
                return this._projectData[projectId][type][num];
            }
            return undefined;
        }// end function

        private function _clearInternal(projectId:Number, type:String) : void
        {
            var _loc_3:Boolean = false;
            var _loc_4:int = 0;
            var _loc_5:int = 0;
            if (this.hasProject(projectId))
            {
                this.hasProject(projectId);
            }
            if (this._projectData[projectId][type] != undefined)
            {
                this._projectData[projectId][type] = undefined;
                _loc_3 = true;
                _loc_5 = this._set.length;
                _loc_4 = 0;
                while (_loc_4 < _loc_5)
                {
                    
                    if (this._projectData[projectId][this._set[_loc_4]] != undefined)
                    {
                        _loc_3 = false;
                        break;
                    }
                    _loc_4 = _loc_4 + 1;
                }
                if (_loc_3)
                {
                    this._projectData[projectId] = undefined;
                    (this._hasData - 1);
                }
            }
            return;
        }// end function

        private function _escapeExtensibleValue(value:String) : String
        {
            var _loc_3:int = 0;
            var _loc_4:String = null;
            var _loc_5:String = null;
            var _loc_2:String = "";
            _loc_3 = 0;
            while (_loc_3 < value.length)
            {
                
                _loc_4 = value.charAt(_loc_3);
                _loc_5 = this._escapeCharMap[_loc_4];
                if (_loc_5)
                {
                    _loc_2 = _loc_2 + _loc_5;
                }
                else
                {
                    _loc_2 = _loc_2 + _loc_4;
                }
                _loc_3 = _loc_3 + 1;
            }
            return _loc_2;
        }// end function

        private function _renderDataType(data:Array) : String
        {
            var _loc_3:String = null;
            var _loc_4:int = 0;
            var _loc_2:Array = [];
            _loc_4 = 0;
            while (_loc_4 < data.length)
            {
                
                if (data[_loc_4] != undefined)
                {
                    _loc_3 = "";
                    if (_loc_4 != this._minimum)
                    {
                    }
                    if (data[(_loc_4 - 1)] == undefined)
                    {
                        _loc_3 = _loc_3 + _loc_4.toString();
                        _loc_3 = _loc_3 + this._delimNumValue;
                    }
                    _loc_3 = _loc_3 + this._escapeExtensibleValue(data[_loc_4]);
                    _loc_2.push(_loc_3);
                }
                _loc_4 = _loc_4 + 1;
            }
            return this._delimBegin + _loc_2.join(this._delimSet) + this._delimEnd;
        }// end function

        private function _renderProject(project:Object) : String
        {
            var _loc_4:int = 0;
            var _loc_5:Array = null;
            var _loc_2:String = "";
            var _loc_3:Boolean = false;
            var _loc_6:* = this._set.length;
            _loc_4 = 0;
            while (_loc_4 < _loc_6)
            {
                
                _loc_5 = project[this._set[_loc_4]];
                if (_loc_5)
                {
                    if (_loc_3)
                    {
                        _loc_2 = _loc_2 + this._set[_loc_4];
                    }
                    _loc_2 = _loc_2 + this._renderDataType(_loc_5);
                    _loc_3 = false;
                }
                else
                {
                    _loc_3 = true;
                }
                _loc_4 = _loc_4 + 1;
            }
            return _loc_2;
        }// end function

        public function hasProject(projectId:Number) : Boolean
        {
            return this._projectData[projectId];
        }// end function

        public function hasData() : Boolean
        {
            return this._hasData > 0;
        }// end function

        public function setKey(projectId:Number, num:Number, value:String) : Boolean
        {
            this._setInternal(projectId, this._key, num, value);
            return true;
        }// end function

        public function getKey(projectId:Number, num:Number) : String
        {
            return this._getInternal(projectId, this._key, num) as String;
        }// end function

        public function clearKey(projectId:Number) : void
        {
            this._clearInternal(projectId, this._key);
            return;
        }// end function

        public function setValue(projectId:Number, num:Number, value:Number) : Boolean
        {
            if (Math.round(value) == value)
            {
            }
            if (!isNaN(value))
            {
                isNaN(value);
            }
            if (value == Infinity)
            {
                return false;
            }
            this._setInternal(projectId, this._value, num, value.toString());
            return true;
        }// end function

        public function getValue(projectId:Number, num:Number)
        {
            var _loc_3:* = this._getInternal(projectId, this._value, num);
            if (_loc_3 == null)
            {
                return null;
            }
            return Number(_loc_3);
        }// end function

        public function clearValue(projectId:Number) : void
        {
            this._clearInternal(projectId, this._value);
            return;
        }// end function

        public function renderUrlString() : String
        {
            var _loc_2:String = null;
            var _loc_1:Array = [];
            for (_loc_2 in this._projectData)
            {
                
                if (this.hasProject(Number(_loc_2)))
                {
                    _loc_1.push(_loc_2 + this._renderProject(this._projectData[_loc_2]));
                }
            }
            return _loc_1.join("");
        }// end function

        public function renderMergedUrlString(extObject:X10 = null) : String
        {
            var _loc_3:String = null;
            if (!extObject)
            {
                return this.renderUrlString();
            }
            var _loc_2:Array = [extObject.renderUrlString()];
            for (_loc_3 in this._projectData)
            {
                
                if (this.hasProject(Number(_loc_3)))
                {
                    this.hasProject(Number(_loc_3));
                }
                if (!extObject.hasProject(Number(_loc_3)))
                {
                    _loc_2.push(_loc_3 + this._renderProject(this._projectData[_loc_3]));
                }
            }
            return _loc_2.join("");
        }// end function

    }
}

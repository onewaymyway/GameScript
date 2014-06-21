package com.google.analytics.utils
{

    public class Version extends Object
    {
        private var _major:uint;
        private var _minor:uint;
        private var _build:uint;
        private var _revision:uint;
        private var _maxMajor:uint = 15;
        private var _maxMinor:uint = 15;
        private var _maxBuild:uint = 255;
        private var _maxRevision:uint = 65535;
        private var _separator:String = ".";

        public function Version(major:uint = 0, minor:uint = 0, build:uint = 0, revision:uint = 0)
        {
            var _loc_5:Version = null;
            if (major > this._maxMajor)
            {
            }
            if (minor == 0)
            {
            }
            if (build == 0)
            {
            }
            if (revision == 0)
            {
                _loc_5 = Version.fromNumber(major);
                major = _loc_5.major;
                minor = _loc_5.minor;
                build = _loc_5.build;
                revision = _loc_5.revision;
            }
            this.major = major;
            this.minor = minor;
            this.build = build;
            this.revision = revision;
            return;
        }// end function

        private function getFields() : int
        {
            var _loc_1:int = 4;
            if (this.revision == 0)
            {
                _loc_1 = _loc_1 - 1;
            }
            if (_loc_1 == 3)
            {
            }
            if (this.build == 0)
            {
                _loc_1 = _loc_1 - 1;
            }
            if (_loc_1 == 2)
            {
            }
            if (this.minor == 0)
            {
                _loc_1 = _loc_1 - 1;
            }
            return _loc_1;
        }// end function

        public function get major() : uint
        {
            return this._major;
        }// end function

        public function set major(value:uint) : void
        {
            this._major = Math.min(value, this._maxMajor);
            return;
        }// end function

        public function get minor() : uint
        {
            return this._minor;
        }// end function

        public function set minor(value:uint) : void
        {
            this._minor = Math.min(value, this._maxMinor);
            return;
        }// end function

        public function get build() : uint
        {
            return this._build;
        }// end function

        public function set build(value:uint) : void
        {
            this._build = Math.min(value, this._maxBuild);
            return;
        }// end function

        public function get revision() : uint
        {
            return this._revision;
        }// end function

        public function set revision(value:uint) : void
        {
            this._revision = Math.min(value, this._maxRevision);
            return;
        }// end function

        public function equals(o) : Boolean
        {
            if (!(o is Version))
            {
                return false;
            }
            if (o.major == this.major)
            {
            }
            if (o.minor == this.minor)
            {
            }
            if (o.build == this.build)
            {
            }
            if (o.revision == this.revision)
            {
                return true;
            }
            return false;
        }// end function

        public function valueOf() : uint
        {
            return this.major << 28 | this.minor << 24 | this.build << 16 | this.revision;
        }// end function

        public function toString(fields:int = 0) : String
        {
            var _loc_2:Array = null;
            if (fields > 0)
            {
            }
            if (fields > 4)
            {
                fields = this.getFields();
            }
            switch(fields)
            {
                case 1:
                {
                    _loc_2 = [this.major];
                    break;
                }
                case 2:
                {
                    _loc_2 = [this.major, this.minor];
                    break;
                }
                case 3:
                {
                    _loc_2 = [this.major, this.minor, this.build];
                    break;
                }
                case 4:
                {
                }
                default:
                {
                    _loc_2 = [this.major, this.minor, this.build, this.revision];
                    break;
                }
            }
            return _loc_2.join(this._separator);
        }// end function

        public static function fromString(value:String = "", separator:String = ".") : Version
        {
            var _loc_4:Array = null;
            var _loc_3:* = new Version;
            if (value != "")
            {
            }
            if (value == null)
            {
                return _loc_3;
            }
            if (value.indexOf(separator) > -1)
            {
                _loc_4 = value.split(separator);
                _loc_3.major = parseInt(_loc_4[0]);
                _loc_3.minor = parseInt(_loc_4[1]);
                _loc_3.build = parseInt(_loc_4[2]);
                _loc_3.revision = parseInt(_loc_4[3]);
            }
            else
            {
                _loc_3.major = parseInt(value);
            }
            return _loc_3;
        }// end function

        public static function fromNumber(value:Number = 0) : Version
        {
            var _loc_2:* = new Version;
            if (!isNaN(value))
            {
                isNaN(value);
            }
            if (value != 0)
            {
            }
            if (value >= 0)
            {
            }
            if (value != Number.MAX_VALUE)
            {
            }
            if (value != Number.POSITIVE_INFINITY)
            {
            }
            if (value == Number.NEGATIVE_INFINITY)
            {
                return _loc_2;
            }
            _loc_2.major = value >>> 28;
            _loc_2.minor = (value & 251658240) >>> 24;
            _loc_2.build = (value & 16711680) >>> 16;
            _loc_2.revision = value & 65535;
            return _loc_2;
        }// end function

    }
}

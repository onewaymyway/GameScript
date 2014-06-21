package com.google.analytics.external
{
    import com.google.analytics.debug.*;

    public class AdSenseGlobals extends JavascriptProxy
    {
        private var _gaGlobalVerified:Boolean = false;
        public static var gaGlobal_js:XML = <script>r
n            <![CDATA[r
n                function()r
n                {r
n                    tryr
n                    {r
n                        gaGlobalr
n                    }r
n                    catch(e)r
n                    {r
n                        gaGlobal = {} ;r
n                    }r
n                }r
n            ]]>r
n        </script>")("<script>
            <![CDATA[
                function()
                {
                    try
                    {
                        gaGlobal
                    }
                    catch(e)
                    {
                        gaGlobal = {} ;
                    }
                }
            ]]>
        </script>;

        public function AdSenseGlobals(debug:DebugConfiguration)
        {
            super(debug);
            return;
        }// end function

        private function _verify() : void
        {
            if (!this._gaGlobalVerified)
            {
                executeBlock(gaGlobal_js);
                this._gaGlobalVerified = true;
            }
            return;
        }// end function

        public function get gaGlobal() : Object
        {
            if (!isAvailable())
            {
                return null;
            }
            this._verify();
            return getProperty("gaGlobal");
        }// end function

        public function get dh() : String
        {
            if (!isAvailable())
            {
                return null;
            }
            this._verify();
            return getProperty("gaGlobal.dh");
        }// end function

        public function get hid() : String
        {
            if (!isAvailable())
            {
                return null;
            }
            this._verify();
            return getProperty("gaGlobal.hid");
        }// end function

        public function set hid(value:String) : void
        {
            if (!isAvailable())
            {
                return;
            }
            this._verify();
            setProperty("gaGlobal.hid", value);
            return;
        }// end function

        public function get sid() : String
        {
            if (!isAvailable())
            {
                return null;
            }
            this._verify();
            return getProperty("gaGlobal.sid");
        }// end function

        public function set sid(value:String) : void
        {
            if (!isAvailable())
            {
                return;
            }
            this._verify();
            setProperty("gaGlobal.sid", value);
            return;
        }// end function

        public function get vid() : String
        {
            if (!isAvailable())
            {
                return null;
            }
            this._verify();
            return getProperty("gaGlobal.vid");
        }// end function

        public function set vid(value:String) : void
        {
            if (!isAvailable())
            {
                return;
            }
            this._verify();
            setProperty("gaGlobal.vid", value);
            return;
        }// end function

    }
}

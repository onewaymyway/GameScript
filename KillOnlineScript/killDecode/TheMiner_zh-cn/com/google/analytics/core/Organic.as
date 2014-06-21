package com.google.analytics.core
{
    import com.google.analytics.utils.*;

    public class Organic extends Object
    {
        private var _sources:Array;
        private var _sourcesCache:Array;
        private var _sourcesEngine:Array;
        private var _ignoredReferrals:Array;
        private var _ignoredReferralsCache:Object;
        private var _ignoredKeywords:Array;
        private var _ignoredKeywordsCache:Object;
        public static var throwErrors:Boolean = false;

        public function Organic()
        {
            this._sources = [];
            this._sourcesCache = [];
            this._sourcesEngine = [];
            this._ignoredReferrals = [];
            this._ignoredReferralsCache = {};
            this._ignoredKeywords = [];
            this._ignoredKeywordsCache = {};
            return;
        }// end function

        public function get count() : int
        {
            return this._sources.length;
        }// end function

        public function get sources() : Array
        {
            return this._sources;
        }// end function

        public function get ignoredReferralsCount() : int
        {
            return this._ignoredReferrals.length;
        }// end function

        public function get ignoredKeywordsCount() : int
        {
            return this._ignoredKeywords.length;
        }// end function

        public function addSource(engine:String, keyword:String) : void
        {
            var _loc_3:* = new OrganicReferrer(engine, keyword);
            if (this._sourcesCache[_loc_3.toString()] == undefined)
            {
                this._sources.push(_loc_3);
                this._sourcesCache[_loc_3.toString()] = this._sources.length - 1;
                if (this._sourcesEngine[_loc_3.engine] == undefined)
                {
                    this._sourcesEngine[_loc_3.engine] = [(this._sources.length - 1)];
                }
                else
                {
                    this._sourcesEngine[_loc_3.engine].push((this._sources.length - 1));
                }
            }
            else if (throwErrors)
            {
                throw new Error(_loc_3.toString() + " already exists, we don\'t add it.");
            }
            return;
        }// end function

        public function addIgnoredReferral(referrer:String) : void
        {
            if (this._ignoredReferralsCache[referrer] == undefined)
            {
                this._ignoredReferrals.push(referrer);
                this._ignoredReferralsCache[referrer] = this._ignoredReferrals.length - 1;
            }
            else if (throwErrors)
            {
                throw new Error("\"" + referrer + "\" already exists, we don\'t add it.");
            }
            return;
        }// end function

        public function addIgnoredKeyword(keyword:String) : void
        {
            if (this._ignoredKeywordsCache[keyword] == undefined)
            {
                this._ignoredKeywords.push(keyword);
                this._ignoredKeywordsCache[keyword] = this._ignoredKeywords.length - 1;
            }
            else if (throwErrors)
            {
                throw new Error("\"" + keyword + "\" already exists, we don\'t add it.");
            }
            return;
        }// end function

        public function clear() : void
        {
            this.clearEngines();
            this.clearIgnoredReferrals();
            this.clearIgnoredKeywords();
            return;
        }// end function

        public function clearEngines() : void
        {
            this._sources = [];
            this._sourcesCache = [];
            this._sourcesEngine = [];
            return;
        }// end function

        public function clearIgnoredReferrals() : void
        {
            this._ignoredReferrals = [];
            this._ignoredReferralsCache = {};
            return;
        }// end function

        public function clearIgnoredKeywords() : void
        {
            this._ignoredKeywords = [];
            this._ignoredKeywordsCache = {};
            return;
        }// end function

        public function getKeywordValue(or:OrganicReferrer, path:String) : String
        {
            var _loc_3:* = or.keyword;
            return getKeywordValueFromPath(_loc_3, path);
        }// end function

        public function getReferrerByName(name:String) : OrganicReferrer
        {
            var _loc_2:int = 0;
            if (this.match(name))
            {
                _loc_2 = this._sourcesEngine[name][0];
                return this._sources[_loc_2];
            }
            return null;
        }// end function

        public function isIgnoredReferral(referrer:String) : Boolean
        {
            if (this._ignoredReferralsCache.hasOwnProperty(referrer))
            {
                return true;
            }
            return false;
        }// end function

        public function isIgnoredKeyword(keyword:String) : Boolean
        {
            if (this._ignoredKeywordsCache.hasOwnProperty(keyword))
            {
                return true;
            }
            return false;
        }// end function

        public function match(name:String) : Boolean
        {
            if (name == "")
            {
                return false;
            }
            name = name.toLowerCase();
            if (this._sourcesEngine[name] != undefined)
            {
                return true;
            }
            return false;
        }// end function

        public static function getKeywordValueFromPath(keyword:String, path:String) : String
        {
            var _loc_3:String = null;
            var _loc_4:Variables = null;
            if (path.indexOf(keyword + "=") > -1)
            {
                if (path.charAt(0) == "?")
                {
                    path = path.substr(1);
                }
                path = path.split("+").join("%20");
                _loc_4 = new Variables(path);
                _loc_3 = _loc_4[keyword];
            }
            return _loc_3;
        }// end function

    }
}

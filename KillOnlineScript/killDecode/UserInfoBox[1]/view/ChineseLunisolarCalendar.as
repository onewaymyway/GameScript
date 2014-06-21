package view
{

    public class ChineseLunisolarCalendar extends Object
    {
        private var tabCnMonthInfo:Object;
        private var tabCnSolarTermIntervalInfo:Object;
        private var tabGDateInfo:Object;
        private var tabHeavenlyStemsName:Object;
        private var tabEarthlyBranchesName:Object;
        private var tabCnAnimalSignName:Array;
        private var tabCnSolarTermName:Object;
        private var tabCnMonthName:Object;
        private var tabCnDigitsName:Object;
        private var tabCnTensName:Object;
        private var tabGrMonthName:Object;
        private var tabGrDayName:Object;
        private var tabGrConstellation:Object;
        private var lFtv:Array;
        private var sFtv:Array;
        private var wFtv:Array;
        private var cnYear:String;
        private var cnMonth:String;
        private var cnDay:String;
        private var cnHour:String;
        private var cnMoment:String;
        private var cyear:int;
        private var cmonth:int;
        private var cday:int;
        private var isLeap:Boolean;
        private var size:Boolean;
        private var solarTerm:String;
        private var mydate:Date;
        private var y:int;
        private var m:int;
        private var d:int;

        public function ChineseLunisolarCalendar(date:Date)
        {
            this.tabCnMonthInfo = new Array(19416, 19168, 42352, 21717, 53856, 55632, 21844, 22191, 39632, 21970, 19168, 42422, 42192, 53840, 53845, 46415, 54944, 44450, 38320, 18807, 18815, 42160, 46261, 27216, 27968, 43860, 11119, 38256, 21234, 18800, 25958, 54432, 59984, 27285, 23263, 11104, 34531, 37615, 51415, 51551, 54432, 55462, 46431, 22176, 42420, 9695, 37584, 53938, 43344, 46423, 27808, 46416, 21333, 19887, 42416, 17779, 21183, 43432, 59728, 27296, 44710, 43856, 19296, 43748, 42352, 21088, 62051, 55632, 23383, 22176, 38608, 19925, 19152, 42192, 54484, 53840, 54616, 46400, 46752, 38310, 38335, 18864, 43380, 42160, 45690, 27216, 27968, 44870, 43872, 38256, 19189, 18800, 25776, 29859, 59984, 27480, 23232, 43872, 38613, 37600, 51552, 55636, 54432, 55888, 30034, 22176, 43959, 9680, 37584, 51893, 43344, 46240, 47780, 44368, 21977, 19360, 42416, 20854, 21183, 43312, 31060, 27296, 44368, 23378, 19296, 42726, 42208, 53856, 60005, 54576, 23200, 30371, 38608, 19195, 19152, 42192, 53430, 53855, 54560, 56645, 46496, 22224, 21938, 18864, 42359, 42160, 43600, 45653, 27951, 44448, 19299, 37759, 18936, 18800, 25776, 26790, 59999, 27424, 42692, 43759, 37600, 53987, 51552, 54615, 54432, 55888, 23893, 22176, 42704, 21972, 21200, 43448, 43344, 46240, 46758, 44368, 21920, 43940, 42416, 21168, 45683, 26928, 29495, 27296, 44368, 19285, 19311, 42352, 21732, 53856, 59752, 54560, 55968, 27302, 22239, 19168, 43476, 42192, 53584, 62034, 54560);
            this.tabCnSolarTermIntervalInfo = new Array(0, 21208, 42467, 63836, 85337, 107014, 128867, 150921, 173149, 195551, 218072, 240693, 263343, 285989, 308563, 331033, 353350, 375494, 397447, 419210, 440795, 462224, 483532, 504758);
            this.tabGDateInfo = new Array(31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31);
            this.tabHeavenlyStemsName = new Array("甲", "乙", "丙", "丁", "戊", "己", "庚", "辛", "壬", "癸");
            this.tabEarthlyBranchesName = new Array("子", "丑", "寅", "卯", "辰", "巳", "午", "未", "申", "酉", "戌", "亥");
            this.tabCnAnimalSignName = new Array("鼠", "牛", "虎", "兔", "龙", "蛇", "马", "羊", "猴", "鸡", "狗", "猪");
            this.tabCnSolarTermName = new Array("小寒", "大寒", "立春", "雨水", "惊蛰", "春分", "清明", "谷雨", "立夏", "小满", "芒种", "夏至", "小暑", "大暑", "立秋", "处暑", "白露", "秋分", "寒露", "霜降", "立冬", "小雪", "大雪", "冬至");
            this.tabCnMonthName = new Array("正", "二", "三", "四", "五", "六", "七", "八", "九", "十", "冬", "腊");
            this.tabCnDigitsName = new Array("零", "一", "二", "三", "四", "五", "六", "七", "八", "九", "十", "廿", "卅", "卌", "百", "千", "万", "兆");
            this.tabCnTensName = new Array("初", "十", "廿", "三");
            this.tabGrMonthName = new Array("JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", "AUG", "SEP", "OCT", "NOV", "DEC");
            this.tabGrDayName = new Array("Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat");
            this.tabGrConstellation = new Array("摩羯", "水瓶", "双鱼", "牧羊", "金牛", "双子", "巨蟹", "狮子", "处女", "天秤", "天蝎", "射手");
            this.lFtv = new Array("0101 春节", "0102 大年初二", "0103 大年初三", "0105 路神生日", "0115 元宵节", "0202 龙抬头", "0303 王母娘娘蟠桃宴", "0404 寒食节", "0505 端午节", "0606 天贶节姑姑节", "0707 七夕情人节", "0714 鬼节(南方)", "0815 中秋节", "0909 重阳节", "1001 祭祖节", "1208 腊八节", "1223 过小年", "0100 除夕");
            this.sFtv = new Array("0101 元旦", "0106 中国13亿人口日", "0202 世界湿地日", "0214 情人节", "0219 国际慢调生活日", "0308 妇女节", "0312 植树节", "0315 消费者权益保护日", "0321 世界森林日", "0322 世界水日", "0323 世界气象日", "0401 愚人节", "0501 国际劳动节", "0504 中国青年节", "0512 国际护士节", "0515 国际家庭日", "0518 国际博物馆日", "0519 中国汶川地震哀悼日 全国助残日", "0531 世界无烟日", "0601 国际儿童节", "0605 世界环境日", "0701 建党节 香港回归纪念日", "0707 抗日战争纪念日", "0801 八一建军节", "0815 日本正式宣布无条件投降日", "0910 教师节", "0918 九·一八事变纪念日", "1001 国庆节 国际音乐节 国际老人节", "1017 高世伦先生诞辰日", "1117 国际大学生节", "1201 世界艾滋病日", "1213 南京大屠杀(1937年)纪念日", "1220 澳门回归纪念日", "1224 平安夜", "1225 圣诞节 世界强化免疫日");
            this.wFtv = new Array("0520 母亲节", "0530 全国助残日", "0630 父亲节", "1144 感恩节");
            this.mydate = new Date();
            var _loc_2:int = 0;
            var _loc_3:int = 0;
            this.mydate = date;
            this.y = this.mydate.getFullYear();
            this.m = this.mydate.getMonth();
            this.d = this.mydate.getDate();
            var _loc_4:* = (Date.UTC(this.y, this.m, this.d) - Date.UTC(1900, 0, 31)) / 86400000;
            var _loc_5:* = 1900;
            do
            {
                
                _loc_3 = this.lYearDays(_loc_5);
                _loc_4 = _loc_4 - _loc_3;
                _loc_5 = _loc_5 + 1;
                if (_loc_5 < 2100)
                {
                }
            }while (_loc_4 > 0)
            if (_loc_4 < 0)
            {
                _loc_4 = _loc_4 + _loc_3;
                _loc_5 = _loc_5 - 1;
            }
            this.cyear = _loc_5;
            _loc_2 = this.leapMonth(_loc_5);
            this.isLeap = false;
            var _loc_6:* = 1;
            do
            {
                
                if (_loc_2 > 0)
                {
                }
                if (_loc_6 == (_loc_2 + 1))
                {
                }
                if (this.isLeap == false)
                {
                    _loc_6 = _loc_6 - 1;
                    this.isLeap = true;
                    _loc_3 = this.leapDays(this.cyear);
                }
                else
                {
                    _loc_3 = this.monthDays(this.cyear, _loc_6);
                }
                if (this.isLeap == true)
                {
                }
                if (_loc_6 == (_loc_2 + 1))
                {
                    this.isLeap = false;
                }
                _loc_4 = _loc_4 - _loc_3;
                _loc_6 = _loc_6 + 1;
                if (_loc_6 < 13)
                {
                }
            }while (_loc_4 > 0)
            if (_loc_4 == 0)
            {
            }
            if (_loc_2 > 0)
            {
            }
            if (_loc_6 == (_loc_2 + 1))
            {
                if (this.isLeap)
                {
                    this.isLeap = false;
                }
                else
                {
                    this.isLeap = true;
                    _loc_6 = _loc_6 - 1;
                }
            }
            if (_loc_4 < 0)
            {
                _loc_4 = _loc_4 + _loc_3;
                _loc_6 = _loc_6 - 1;
            }
            this.cmonth = _loc_6;
            this.cday = _loc_4 + 1;
            if (_loc_3 == 30)
            {
                this.size = true;
            }
            else
            {
                this.size = false;
            }
            return;
        }// end function

        private function lYearDays(y)
        {
            var _loc_2:int = 348;
            var _loc_3:* = 32768;
            while (_loc_3 > 8)
            {
                
                _loc_2 = _loc_2 + (this.tabCnMonthInfo[y - 1900] & _loc_3 ? (1) : (0));
                _loc_3 = _loc_3 >> 1;
            }
            return _loc_2 + this.leapDays(y);
        }// end function

        private function leapDays(y)
        {
            if (this.leapMonth(y))
            {
                return this.tabCnMonthInfo[y - 1899] & 15 == 15 ? (30) : (29);
            }
            else
            {
                return 0;
            }
        }// end function

        private function leapMonth(y)
        {
            var _loc_2:* = this.tabCnMonthInfo[y - 1900] & 15;
            return _loc_2 == 15 ? (0) : (_loc_2);
        }// end function

        private function monthDays(y, m)
        {
            return this.tabCnMonthInfo[y - 1900] & 65536 >> m ? (30) : (29);
        }// end function

        private function sTerm(y, n)
        {
            var _loc_3:* = new Date(3.15569e+010 * y - 1900 + this.tabCnSolarTermIntervalInfo[n] * 60000 + Date.UTC(1900, 0, 6, 2, 5));
            return _loc_3.getUTCDate();
        }// end function

        private function cyclical(num)
        {
            return this.tabHeavenlyStemsName[num % 10] + this.tabEarthlyBranchesName[num % 12];
        }// end function

        private function solarDays(y, m)
        {
            if (m == 1)
            {
                if (y % 4 == 0)
                {
                }
                if (y % 100 == 0)
                {
                }
                return y % 400 == 0 ? (29) : (28);
            }
            else
            {
                return this.tabGDateInfo[m];
            }
        }// end function

        private function dateNWeek(y, m, n:int, w:int) : int
        {
            var _loc_5:Date = null;
            var _loc_6:int = 0;
            if (n < 5)
            {
                _loc_5 = new Date(y, m, 1);
                if (_loc_5.day == w)
                {
                    _loc_6 = 1;
                }
                if (_loc_5.day < w)
                {
                    _loc_6 = w - _loc_5.day + 1;
                }
                if (_loc_5.day > w)
                {
                    _loc_6 = 7 - _loc_5.day + w + 1;
                }
                _loc_6 = _loc_6 + (n - 1) * 7;
            }
            if (n > 5)
            {
                _loc_5 = new Date(y, m, this.solarDays(y, m));
                if (_loc_5.day == w)
                {
                    _loc_6 = this.solarDays(y, m);
                }
                if (_loc_5.day < w)
                {
                    _loc_6 = 7 - w + _loc_5.day;
                }
                if (_loc_5.day > w)
                {
                    _loc_6 = this.solarDays(y, m) - (_loc_5.day - w);
                }
                _loc_6 = _loc_6 - (10 - n - 1) * 7;
            }
            return _loc_6;
        }// end function

        public function getCnAnimalsSign()
        {
            var _loc_1:* = (this.cyear - 4) % 12;
            return this.tabCnAnimalSignName[_loc_1];
        }// end function

        public function getCnYearNumber() : String
        {
            var _loc_1:* = this.getCYear();
            var _loc_2:String = "";
            var _loc_3:int = 1000;
            while (_loc_3 > 0)
            {
                
                _loc_2 = _loc_2 + this.tabCnDigitsName[int(_loc_1 / _loc_3)];
                _loc_1 = _loc_1 % _loc_3;
                _loc_3 = _loc_3 / 10;
            }
            return _loc_2;
        }// end function

        public function getCnYear() : String
        {
            return this.cyclical(this.cyear - 1900 + 36);
        }// end function

        public function getCnMonth() : String
        {
            if (this.isLeap == true)
            {
                this.cnMonth = "闰";
            }
            else
            {
                this.cnMonth = "";
            }
            this.cnMonth = this.cnMonth + (this.tabCnMonthName[(this.cmonth - 1)] + "月");
            var _loc_1:Boolean = true;
            this.size = true;
            if (_loc_1)
            {
                this.cnMonth = this.cnMonth + "大";
            }
            else
            {
                this.cnMonth = this.cnMonth + "小";
            }
            return this.cnMonth;
        }// end function

        public function getCnDay() : String
        {
            if (this.cday % 10 == 0)
            {
                this.cnDay = this.tabCnTensName[int(this.cday / 10)] + this.tabCnDigitsName[10];
            }
            else
            {
                this.cnDay = this.tabCnTensName[int(this.cday / 10)] + this.tabCnDigitsName[this.cday % 10];
            }
            return this.cnDay;
        }// end function

        public function getCnHours() : String
        {
            this.cnHour = this.tabEarthlyBranchesName[Math.round(this.mydate.getHours() % 23 / 2)] + "时";
            this.cnMoment = this.tabCnDigitsName[this.mydate.getHours() % 2 * 4 + int(this.mydate.getMinutes() / 15) + 1] + "刻";
            return this.cnHour + this.cnMoment;
        }// end function

        public function getCYear() : int
        {
            return this.cyear + 2698;
        }// end function

        public function getCMonth() : int
        {
            return this.cmonth;
        }// end function

        public function getCDay() : int
        {
            return this.cday;
        }// end function

        public function getGrMonth() : String
        {
            return this.tabGrMonthName[this.m];
        }// end function

        public function getGrDay() : String
        {
            return this.tabGrDayName[this.mydate.day];
        }// end function

        public function getGYear() : int
        {
            return this.mydate.fullYear;
        }// end function

        public function getGMonth() : int
        {
            return this.mydate.month;
        }// end function

        public function getGDate() : int
        {
            return this.mydate.date;
        }// end function

        public function getCnSolarTerm() : String
        {
            var _loc_1:* = this.sTerm(this.cyear, this.m * 2);
            var _loc_2:* = this.sTerm(this.cyear, this.m * 2 + 1);
            if (this.d == _loc_1)
            {
                this.solarTerm = this.tabCnSolarTermName[this.m * 2];
            }
            else if (this.d == _loc_2)
            {
                this.solarTerm = this.tabCnSolarTermName[this.m * 2 + 1];
            }
            else
            {
                this.solarTerm = "";
            }
            return this.solarTerm;
        }// end function

        public function getsFtv() : String
        {
            var _loc_2:String = null;
            var _loc_1:String = "";
            for (_loc_2 in this.sFtv)
            {
                
                if (int(this.sFtv[_loc_2].substring(0, 4)) == 100 * (this.m + 1) + this.d)
                {
                    _loc_1 = this.sFtv[_loc_2].substring(5);
                }
            }
            return _loc_1;
        }// end function

        public function getwFtv() : String
        {
            var _loc_2:String = null;
            var _loc_1:String = "";
            for (_loc_2 in this.wFtv)
            {
                
                if (int(this.wFtv[_loc_2].substring(0, 2)) == (this.m + 1))
                {
                }
                if (this.dateNWeek(this.y, this.m, int(this.wFtv[_loc_2].substring(2)), int(this.wFtv[_loc_2].substring(3))) == this.d)
                {
                    _loc_1 = this.wFtv[_loc_2].substring(5);
                }
            }
            return _loc_1;
        }// end function

        public function getlFtv() : String
        {
            var _loc_2:String = null;
            var _loc_1:String = "";
            for (_loc_2 in this.lFtv)
            {
                
                if (int(this.lFtv[_loc_2].substring(0, 4)) == 100 * (this.cmonth + 1) + this.cday)
                {
                    _loc_1 = this.lFtv[_loc_2].substring(5);
                }
            }
            if (this.cmonth == 12)
            {
            }
            if (this.leapMonth(this.cyear) == 12)
            {
                if (this.cday == 29)
                {
                }
                if (this.size == false)
                {
                    _loc_1 = "除夕";
                }
                if (this.cday == 30)
                {
                }
                if (this.size == true)
                {
                    _loc_1 = "除夕";
                }
            }
            else if (this.cmonth == 12)
            {
                if (this.cday == 29)
                {
                }
                if (this.size == false)
                {
                    _loc_1 = "除夕";
                }
                if (this.cday == 30)
                {
                }
                if (this.size == true)
                {
                    _loc_1 = "除夕";
                }
            }
            return _loc_1;
        }// end function

    }
}

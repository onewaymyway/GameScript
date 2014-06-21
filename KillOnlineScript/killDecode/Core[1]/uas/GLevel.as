package uas
{

    public class GLevel extends Object
    {

        public function GLevel()
        {
            return;
        }// end function

        public static function getName(param1:int) : String
        {
            if (!isNaN(param1))
            {
                if (param1 < -50)
                {
                    return "弱智";
                }
                if (param1 >= -50 && param1 < 20)
                {
                    return "正常";
                }
                if (param1 >= 20 && param1 < 100)
                {
                    return "小聪明";
                }
                if (param1 >= 100 && param1 < 300)
                {
                    return "聪明";
                }
                if (param1 >= 300 && param1 < 700)
                {
                    return "聪明绝顶";
                }
                if (param1 >= 700 && param1 < 1500)
                {
                    return "小精明";
                }
                if (param1 >= 1500 && param1 < 3100)
                {
                    return "精明";
                }
                if (param1 >= 3100 && param1 < 6400)
                {
                    return "精明绝顶";
                }
                if (param1 >= 6400 && param1 < 12000)
                {
                    return "神童";
                }
                if (param1 >= 12000 && param1 < 24000)
                {
                    return "小天才";
                }
                if (param1 >= 24000 && param1 < 36000)
                {
                    return "天才";
                }
                if (param1 >= 36000 && param1 < 60000)
                {
                    return "超级天才";
                }
                if (param1 >= 60000 && param1 < 120000)
                {
                    return "神";
                }
                if (param1 >= 120000 && param1 < 180000)
                {
                    return "大神";
                }
                if (param1 >= 180000 && param1 < 240000)
                {
                    return "天神";
                }
                if (param1 >= 240000 && param1 < 360000)
                {
                    return "神君";
                }
                if (param1 >= 360000 && param1 < 600000)
                {
                    return "神王";
                }
                if (param1 >= 600000 && param1 < 960000)
                {
                    return "神帝";
                }
                if (param1 >= 960000)
                {
                    return "神尊";
                }
                return "弱智";
            }
            else
            {
                return "弱智";
            }
        }// end function

        public static function getLog(param1:int) : uint
        {
            if (!isNaN(param1))
            {
                if (param1 < -50)
                {
                    return 1;
                }
                if (param1 >= -50 && param1 < 20)
                {
                    return 2;
                }
                if (param1 >= 20 && param1 < 100)
                {
                    return 3;
                }
                if (param1 >= 100 && param1 < 300)
                {
                    return 4;
                }
                if (param1 >= 300 && param1 < 700)
                {
                    return 5;
                }
                if (param1 >= 700 && param1 < 1500)
                {
                    return 6;
                }
                if (param1 >= 1500 && param1 < 3100)
                {
                    return 7;
                }
                if (param1 >= 3100 && param1 < 6400)
                {
                    return 8;
                }
                if (param1 >= 6400 && param1 < 12000)
                {
                    return 9;
                }
                if (param1 >= 12000 && param1 < 24000)
                {
                    return 10;
                }
                if (param1 >= 24000 && param1 < 36000)
                {
                    return 11;
                }
                if (param1 >= 36000 && param1 < 60000)
                {
                    return 12;
                }
                if (param1 >= 60000 && param1 < 120000)
                {
                    return 13;
                }
                if (param1 >= 120000 && param1 < 180000)
                {
                    return 14;
                }
                if (param1 >= 180000 && param1 < 240000)
                {
                    return 15;
                }
                if (param1 >= 240000 && param1 < 360000)
                {
                    return 16;
                }
                if (param1 >= 360000 && param1 < 600000)
                {
                    return 17;
                }
                if (param1 >= 600000 && param1 < 960000)
                {
                    return 18;
                }
                if (param1 >= 960000)
                {
                    return 19;
                }
                return 1;
            }
            else
            {
                return 1;
            }
        }// end function

    }
}

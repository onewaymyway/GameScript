package com.google.analytics
{
    import com.google.analytics.utils.*;

    public class API extends Object
    {
        public static var version:Version = new Version();

        public function API()
        {
            return;
        }// end function

        version.major = 1;
        version.minor = 0;
        version.build = 1;
        version.revision = "$Rev: 319 $ ".split(" ")[1];
    }
}

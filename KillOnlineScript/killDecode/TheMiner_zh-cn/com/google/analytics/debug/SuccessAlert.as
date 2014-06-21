package com.google.analytics.debug
{

    public class SuccessAlert extends Alert
    {

        public function SuccessAlert(debug:DebugConfiguration, text:String, actions:Array)
        {
            var _loc_4:* = Align.bottomLeft;
            var _loc_5:Boolean = true;
            var _loc_6:Boolean = false;
            if (debug.verbose)
            {
                text = "<u><span class=\"uiAlertTitle\">Success</span>" + spaces(18) + "</u>\n\n" + text;
                _loc_4 = Align.center;
                _loc_5 = false;
                _loc_6 = true;
            }
            super(text, actions, "uiSuccess", Style.successColor, _loc_4, _loc_5, _loc_6);
            return;
        }// end function

    }
}

﻿package com.google.analytics.debug
{
    import flash.net.*;
    import flash.text.*;

    public class _Style extends Object
    {
        private var _defaultSheet:String;
        private var _sheet:StyleSheet;
        private var _loader:URLLoader;
        public var backgroundColor:uint;
        public var borderColor:uint;
        public var infoColor:uint;
        public var roundedCorner:uint;
        public var warningColor:uint;
        public var alertColor:uint;
        public var successColor:uint;
        public var failureColor:uint;

        public function _Style()
        {
            this._sheet = new StyleSheet();
            this._loader = new URLLoader();
            this._init();
            return;
        }// end function

        private function _init() : void
        {
            this._defaultSheet = "";
            this._defaultSheet = this._defaultSheet + "a{text-decoration: underline;}\n";
            this._defaultSheet = this._defaultSheet + ".uiLabel{color: #000000;font-family: Arial;font-size: 12;margin-left: 2;margin-right: 2;}\n";
            this._defaultSheet = this._defaultSheet + ".uiWarning{color: #ffffff;font-family: Arial;font-size: 14;font-weight: bold;margin-left: 6;margin-right: 6;}\n";
            this._defaultSheet = this._defaultSheet + ".uiAlert{color: #ffffff;font-family: Arial;font-size: 14;font-weight: bold;margin-left: 6;margin-right: 6;}\n";
            this._defaultSheet = this._defaultSheet + ".uiInfo{color: #000000;font-family: Arial;font-size: 14;font-weight: bold;margin-left: 6;margin-right: 6;}\n";
            this._defaultSheet = this._defaultSheet + ".uiSuccess{color: #ffffff;font-family: Arial;font-size: 12;font-weight: bold;margin-left: 6;margin-right: 6;}\n";
            this._defaultSheet = this._defaultSheet + ".uiFailure{color: #ffffff;font-family: Arial;font-size: 12;font-weight: bold;margin-left: 6;margin-right: 6;}\n";
            this._defaultSheet = this._defaultSheet + ".uiAlertAction{color: #ffffff;text-align: center;font-family: Arial;font-size: 12;font-weight: bold;margin-left: 6;margin-right: 6;}\n";
            this._defaultSheet = this._defaultSheet + ".uiAlertTitle{color: #ffffff;font-family: Arial;font-size: 16;font-weight: bold;margin-left: 6;margin-right: 6;}\n";
            this._defaultSheet = this._defaultSheet + "\n";
            this.roundedCorner = 6;
            this.backgroundColor = 13421772;
            this.borderColor = 5592405;
            this.infoColor = 16777113;
            this.alertColor = 16763904;
            this.warningColor = 13369344;
            this.successColor = 65280;
            this.failureColor = 16711680;
            this._parseSheet(this._defaultSheet);
            return;
        }// end function

        private function _parseSheet(data:String) : void
        {
            this._sheet.parseCSS(data);
            return;
        }// end function

        public function get sheet() : StyleSheet
        {
            return this._sheet;
        }// end function

    }
}

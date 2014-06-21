package com.junkbyte.console.view
{
    import com.junkbyte.console.*;
    import com.junkbyte.console.vos.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.text.*;
    import flash.utils.*;

    public class PanelsManager extends Object
    {
        protected var console:Console;
        protected var _mainPanel:MainPanel;
        private var _chsPanel:ChannelsPanel;
        private var _graphsMap:Dictionary;
        private var _tooltipField:TextField;
        private var _canDraw:Boolean;

        public function PanelsManager(master:Console)
        {
            this._graphsMap = new Dictionary();
            this.console = master;
            this._mainPanel = this.createMainPanel();
            this._tooltipField = this.mainPanel.makeTF("tooltip", true);
            this._tooltipField.mouseEnabled = false;
            this._tooltipField.autoSize = TextFieldAutoSize.CENTER;
            this._tooltipField.multiline = true;
            this.addPanel(this._mainPanel);
            this.console.graphing.onGroupAdded.add(this.onGraphingGroupAdded);
            return;
        }// end function

        protected function createMainPanel() : MainPanel
        {
            return new MainPanel(this.console);
        }// end function

        public function addPanel(panel:ConsolePanel) : void
        {
            if (this.console.contains(this._tooltipField))
            {
                this.console.addChildAt(panel, this.console.getChildIndex(this._tooltipField));
            }
            else
            {
                this.console.addChild(panel);
            }
            panel.addEventListener(ConsolePanel.DRAGGING_STARTED, this.onPanelStartDragScale, false, 0, true);
            panel.addEventListener(ConsolePanel.SCALING_STARTED, this.onPanelStartDragScale, false, 0, true);
            return;
        }// end function

        public function removePanel(n:String) : void
        {
            var _loc_2:* = this.console.getChildByName(n) as ConsolePanel;
            if (_loc_2)
            {
                _loc_2.close();
            }
            return;
        }// end function

        public function getPanel(n:String) : ConsolePanel
        {
            return this.console.getChildByName(n) as ConsolePanel;
        }// end function

        public function get mainPanel() : MainPanel
        {
            return this._mainPanel;
        }// end function

        public function panelExists(n:String) : Boolean
        {
            return this.console.getChildByName(n) as ConsolePanel ? (true) : (false);
        }// end function

        public function setPanelArea(panelname:String, rect:Rectangle) : void
        {
            var _loc_3:* = this.getPanel(panelname);
            if (_loc_3)
            {
                _loc_3.x = rect.x;
                _loc_3.y = rect.y;
                if (rect.width)
                {
                    _loc_3.width = rect.width;
                }
                if (rect.height)
                {
                    _loc_3.height = rect.height;
                }
            }
            return;
        }// end function

        public function updateMenu() : void
        {
            this._mainPanel.updateMenu();
            var _loc_1:* = this.getPanel(ChannelsPanel.NAME) as ChannelsPanel;
            if (_loc_1)
            {
                _loc_1.update();
            }
            return;
        }// end function

        function update(paused:Boolean, lineAdded:Boolean) : void
        {
            this._canDraw = !paused;
            if (!paused)
            {
            }
            this._mainPanel.update(lineAdded);
            if (!paused)
            {
                if (lineAdded)
                {
                }
                if (this._chsPanel != null)
                {
                    this._chsPanel.update();
                }
            }
            return;
        }// end function

        private function onGraphingGroupAdded(group:GraphGroup) : void
        {
            group.onClose.add(this.onGraphGroupClose);
            var _loc_2:* = new GraphingPanel(this.console, group);
            this._graphsMap[group] = _loc_2;
            this.addPanel(_loc_2);
            return;
        }// end function

        private function onGraphGroupClose(group:GraphGroup) : void
        {
            var _loc_2:* = this.getGraphByGroup(group);
            if (_loc_2)
            {
                delete this._graphsMap[group];
                _loc_2.close();
            }
            return;
        }// end function

        public function getGraphByGroup(group:GraphGroup) : GraphingPanel
        {
            return this._graphsMap[group];
        }// end function

        public function get displayRoller() : Boolean
        {
            return this.getPanel(RollerPanel.NAME) as RollerPanel ? (true) : (false);
        }// end function

        public function set displayRoller(n:Boolean) : void
        {
            var _loc_2:RollerPanel = null;
            if (this.displayRoller != n)
            {
                if (n)
                {
                    if (this.console.config.displayRollerEnabled)
                    {
                        _loc_2 = new RollerPanel(this.console);
                        _loc_2.x = this._mainPanel.x + this._mainPanel.width - 180;
                        _loc_2.y = this._mainPanel.y + 55;
                        this.addPanel(_loc_2);
                    }
                    else
                    {
                        this.console.report("Display roller is disabled in config.", 9);
                    }
                }
                else
                {
                    this.removePanel(RollerPanel.NAME);
                }
                this._mainPanel.updateMenu();
            }
            return;
        }// end function

        public function get channelsPanel() : Boolean
        {
            return this._chsPanel != null;
        }// end function

        public function set channelsPanel(b:Boolean) : void
        {
            if (this.channelsPanel != b)
            {
                this.console.logs.cleanChannels();
                if (b)
                {
                    this._chsPanel = new ChannelsPanel(this.console);
                    this._chsPanel.x = this._mainPanel.x + this._mainPanel.width - 332;
                    this._chsPanel.y = this._mainPanel.y - 2;
                    this.addPanel(this._chsPanel);
                    this._chsPanel.update();
                    this.updateMenu();
                }
                else
                {
                    this.removePanel(ChannelsPanel.NAME);
                    this._chsPanel = null;
                }
                this.updateMenu();
            }
            return;
        }// end function

        public function tooltip(str:String = null, panel:ConsolePanel = null) : void
        {
            var _loc_3:Array = null;
            var _loc_4:Rectangle = null;
            var _loc_5:Rectangle = null;
            var _loc_6:Number = NaN;
            var _loc_7:Number = NaN;
            var _loc_8:Number = NaN;
            if (str)
            {
                _loc_3 = str.split("::");
                str = _loc_3[0];
                if (_loc_3.length > 1)
                {
                    str = str + ("<br/><low>" + _loc_3[1] + "</low>");
                }
                this.console.addChild(this._tooltipField);
                this._tooltipField.wordWrap = false;
                this._tooltipField.htmlText = "<tt>" + str + "</tt>";
                if (this._tooltipField.width > 120)
                {
                    this._tooltipField.width = 120;
                    this._tooltipField.wordWrap = true;
                }
                this._tooltipField.x = this.console.mouseX - this._tooltipField.width / 2;
                this._tooltipField.y = this.console.mouseY + 20;
                if (panel)
                {
                    _loc_4 = this._tooltipField.getBounds(this.console);
                    _loc_5 = new Rectangle(panel.x, panel.y, panel.width, panel.height);
                    _loc_6 = _loc_4.bottom - _loc_5.bottom;
                    if (_loc_6 > 0)
                    {
                        if (this._tooltipField.y - _loc_6 > this.console.mouseY + 15)
                        {
                            this._tooltipField.y = this._tooltipField.y - _loc_6;
                        }
                        else
                        {
                            if (_loc_5.y < this.console.mouseY - 24)
                            {
                            }
                            if (_loc_4.y > _loc_5.bottom)
                            {
                                this._tooltipField.y = this.console.mouseY - this._tooltipField.height - 15;
                            }
                        }
                    }
                    _loc_7 = _loc_4.left - _loc_5.left;
                    _loc_8 = _loc_4.right - _loc_5.right;
                    if (_loc_7 < 0)
                    {
                        this._tooltipField.x = this._tooltipField.x - _loc_7;
                    }
                    else if (_loc_8 > 0)
                    {
                        this._tooltipField.x = this._tooltipField.x - _loc_8;
                    }
                }
            }
            else if (this.console.contains(this._tooltipField))
            {
                this.console.removeChild(this._tooltipField);
            }
            return;
        }// end function

        private function onPanelStartDragScale(event:Event) : void
        {
            var _loc_3:Array = null;
            var _loc_4:Array = null;
            var _loc_5:int = 0;
            var _loc_6:int = 0;
            var _loc_7:ConsolePanel = null;
            var _loc_2:* = event.currentTarget as ConsolePanel;
            if (this.console.config.style.panelSnapping)
            {
                _loc_3 = [0];
                _loc_4 = [0];
                if (this.console.stage)
                {
                    _loc_3.push(this.console.stage.stageWidth);
                    _loc_4.push(this.console.stage.stageHeight);
                }
                _loc_5 = this.console.numChildren;
                _loc_6 = 0;
                while (_loc_6 < _loc_5)
                {
                    
                    _loc_7 = this.console.getChildAt(_loc_6) as ConsolePanel;
                    if (_loc_7)
                    {
                    }
                    if (_loc_7.visible)
                    {
                        _loc_3.push(_loc_7.x, _loc_7.x + _loc_7.width);
                        _loc_4.push(_loc_7.y, _loc_7.y + _loc_7.height);
                    }
                    _loc_6 = _loc_6 + 1;
                }
                _loc_2.registerSnaps(_loc_3, _loc_4);
            }
            return;
        }// end function

    }
}

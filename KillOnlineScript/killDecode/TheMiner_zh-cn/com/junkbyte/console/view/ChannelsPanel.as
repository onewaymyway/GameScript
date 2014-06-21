package com.junkbyte.console.view
{
    import com.junkbyte.console.*;
    import flash.events.*;
    import flash.text.*;

    public class ChannelsPanel extends ConsolePanel
    {
        public static const NAME:String = "channelsPanel";

        public function ChannelsPanel(m:Console)
        {
            super(m);
            name = NAME;
            init(10, 10, false);
            txtField = makeTF("channelsField");
            txtField.wordWrap = true;
            txtField.width = 160;
            txtField.multiline = true;
            txtField.autoSize = TextFieldAutoSize.LEFT;
            registerTFRoller(txtField, this.onMenuRollOver, this.linkHandler);
            registerDragger(txtField);
            addChild(txtField);
            return;
        }// end function

        public function update() : void
        {
            txtField.wordWrap = false;
            txtField.width = 80;
            var _loc_1:* = "<high><menu> <b><a href=\"event:close\">X</a></b></menu> " + console.panels.mainPanel.getChannelsLink();
            txtField.htmlText = _loc_1 + "</high>";
            if (txtField.width > 160)
            {
                txtField.wordWrap = true;
                txtField.width = 160;
            }
            width = txtField.width + 4;
            height = txtField.height;
            return;
        }// end function

        private function onMenuRollOver(event:TextEvent) : void
        {
            console.panels.mainPanel.onMenuRollOver(event, this);
            return;
        }// end function

        protected function linkHandler(event:TextEvent) : void
        {
            txtField.setSelection(0, 0);
            if (event.text == "close")
            {
                console.panels.channelsPanel = false;
            }
            else if (event.text.substring(0, 8) == "channel_")
            {
                console.panels.mainPanel.onChannelPressed(event.text.substring(8));
            }
            txtField.setSelection(0, 0);
            event.stopPropagation();
            return;
        }// end function

    }
}

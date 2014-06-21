package com.sociodox.theminer.window
{
    import com.junkbyte.console.*;
    import com.sociodox.theminer.manager.*;
    import flash.display.*;
    import flash.utils.*;

    public class ConsoleContainer extends Sprite implements IWindow
    {
        private var mTimeSpent:int = 0;

        public function ConsoleContainer()
        {
            this.mTimeSpent = getTimer();
            Cc.start(this);
            Cc.instance.cl.base = Stage2D;
            Cc.config.commandLineAllowed = true;
            Cc.y = 17;
            Cc.width = Stage2D.stageWidth;
            Cc.height = Stage2D.stageHeight - 17;
            Analytics.Track("Tab", "Console", "Console Enter");
            return;
        }// end function

        public function Dispose() : void
        {
            trace("Dispose");
            Cc.remove();
            Cc.visible = false;
            this.mTimeSpent = getTimer() - this.mTimeSpent;
            this.mTimeSpent = this.mTimeSpent / 1000;
            Analytics.Track("Tab", "Console", "Console Exit", this.mTimeSpent);
            return;
        }// end function

        public function Unlink() : void
        {
            if (this.parent != null)
            {
                this.parent.removeChild(this);
            }
            return;
        }// end function

        public function Link(aParent:DisplayObjectContainer, aPos:int) : void
        {
            aParent.addChildAt(this, aPos);
            return;
        }// end function

        public function Update() : void
        {
            return;
        }// end function

    }
}

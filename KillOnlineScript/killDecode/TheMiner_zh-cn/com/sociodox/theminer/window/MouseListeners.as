package com.sociodox.theminer.window
{
    import com.sociodox.theminer.manager.*;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.utils.*;

    public class MouseListeners extends Sprite implements IWindow
    {
        private var mRenderTargetData:BitmapData = null;
        private var mRenderTarget:Bitmap = null;
        private var mRenderTargetDataRect:Rectangle = null;
        private var currentRenderTarget:Sprite;
        private var mEnterTime:int = 0;
        private static const COLOR_ALPHA:Number = 0.3;

        public function MouseListeners()
        {
            this.currentRenderTarget = new Sprite();
            this.Init();
            this.mEnterTime = getTimer();
            Analytics.Track("Tab", "MouseProfiler", "MouseProfiler Enter");
            return;
        }// end function

        private function Init() : void
        {
            this.mouseChildren = false;
            this.mouseEnabled = false;
            this.mRenderTargetData = new BitmapData(Stage2D.stageWidth, Stage2D.stageHeight, false, 0);
            this.mRenderTargetDataRect = this.mRenderTargetData.rect;
            this.mRenderTarget = new Bitmap();
            this.mRenderTarget.bitmapData = this.mRenderTargetData;
            this.addChild(this.mRenderTarget);
            return;
        }// end function

        public function Dispose() : void
        {
            Analytics.Track("Tab", "MouseProfiler", "MouseProfiler Enter", int((getTimer() - this.mEnterTime) / 1000));
            if (this.mRenderTarget != null)
            {
                this.mRenderTarget.bitmapData = null;
                this.mRenderTarget = null;
            }
            if (this.mRenderTargetData != null)
            {
                this.mRenderTargetData.dispose();
                this.mRenderTargetData = null;
            }
            this.mRenderTargetDataRect = null;
            while (this.numChildren > 0)
            {
                
                this.removeChildAt(0);
            }
            this.currentRenderTarget = null;
            return;
        }// end function

        public function Update() : void
        {
            this.alpha = Commands.Opacity / 10;
            this.mRenderTargetData.fillRect(this.mRenderTargetData.rect, SkinManager.COLOR_GLOBAL_BG);
            this.mRenderTargetData.lock();
            this.ParseStage(Stage2D);
            this.mRenderTargetData.unlock();
            return;
        }// end function

        protected function ParseStage(obj:DisplayObjectContainer) : void
        {
            var _loc_3:DisplayObject = null;
            var _loc_4:InteractiveObject = null;
            var _loc_5:Rectangle = null;
            if (obj != null)
            {
            }
            if (obj == parent)
            {
                return;
            }
            if (obj.mouseChildren == false)
            {
                return;
            }
            var _loc_2:int = 0;
            while (_loc_2 < obj.numChildren)
            {
                
                _loc_3 = obj.getChildAt(_loc_2);
                if (_loc_3 == null)
                {
                }
                else
                {
                    _loc_4 = _loc_3 as InteractiveObject;
                    if (_loc_4 == null)
                    {
                    }
                    else
                    {
                        if (_loc_4.mouseEnabled == true)
                        {
                            _loc_5 = _loc_3.getRect(Stage2D);
                            _loc_5 = _loc_5.intersection(this.mRenderTargetDataRect);
                            this.currentRenderTarget.graphics.clear();
                            if (!_loc_4.hasEventListener(MouseEvent.CLICK))
                            {
                                _loc_4.hasEventListener(MouseEvent.CLICK);
                            }
                            if (!_loc_4.hasEventListener(MouseEvent.MOUSE_DOWN))
                            {
                                _loc_4.hasEventListener(MouseEvent.MOUSE_DOWN);
                            }
                            if (_loc_4.hasEventListener(MouseEvent.MOUSE_UP))
                            {
                                this.currentRenderTarget.graphics.beginFill(SkinManager.COLOR_MOUSE_CLICK, COLOR_ALPHA / 2);
                            }
                            else
                            {
                                if (!_loc_4.hasEventListener(MouseEvent.MOUSE_MOVE))
                                {
                                    _loc_4.hasEventListener(MouseEvent.MOUSE_MOVE);
                                }
                                if (!_loc_4.hasEventListener(MouseEvent.MOUSE_OVER))
                                {
                                    _loc_4.hasEventListener(MouseEvent.MOUSE_OVER);
                                }
                                if (_loc_4.hasEventListener(MouseEvent.MOUSE_OUT))
                                {
                                    this.currentRenderTarget.graphics.beginFill(SkinManager.COLOR_MOUSE_MOVE, COLOR_ALPHA / 2);
                                }
                                else
                                {
                                    this.currentRenderTarget.graphics.beginFill(SkinManager.COLOR_MOUSE_ENABLED, COLOR_ALPHA / 2);
                                }
                            }
                            this.currentRenderTarget.graphics.drawRect(_loc_5.x, _loc_5.y, _loc_5.width, _loc_5.height);
                            this.currentRenderTarget.graphics.endFill();
                            this.mRenderTargetData.draw(this.currentRenderTarget);
                        }
                        this.ParseStage(_loc_3 as DisplayObjectContainer);
                    }
                }
                _loc_2 = _loc_2 + 1;
            }
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

    }
}

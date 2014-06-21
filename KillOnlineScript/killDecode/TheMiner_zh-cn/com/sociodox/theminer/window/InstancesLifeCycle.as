package com.sociodox.theminer.window
{
    import com.sociodox.theminer.manager.*;
    import flash.display.*;
    import flash.events.*;
    import flash.filters.*;
    import flash.geom.*;
    import flash.text.*;
    import flash.utils.*;

    public class InstancesLifeCycle extends Sprite implements IWindow
    {
        private var mRenderTargetData:BitmapData = null;
        private var mRenderTargetDataReuse:BitmapData = null;
        private var mRenderTargetDataCreate:BitmapData = null;
        private var mRenderTargetDataRemoved:BitmapData = null;
        private var mRenderTargetDataGC:BitmapData = null;
        private var mRenderTarget:Bitmap = null;
        private var mAssetsDict:Dictionary = null;
        private var renderTarget1:Shape = null;
        private var renderTarget2:Shape = null;
        private var currentRenderTarget:Shape = null;
        private var mLegend:Sprite = null;
        private var mInfos:TextField;
        private var mLegendTxt:Array = null;
        private var mAddedLastSecond:int = 0;
        private var mRemovedLastSecond:int = 0;
        private var mDOTotal:int = 0;
        private var mDOToCollect:int = 0;
        private var mLastTick:int = 0;
        private var mEnterTime:int = 0;
        private var mBiggerRect:Rectangle;
        private var mMinRect:Rectangle;
        private var pos:Point;
        private static const COLOR_ALPHA:Number = 0.3;

        public function InstancesLifeCycle()
        {
            this.mBiggerRect = new Rectangle();
            this.mMinRect = new Rectangle(0, 0, 4, 4);
            this.pos = new Point();
            this.Init();
            this.mEnterTime = getTimer();
            return;
        }// end function

        private function Init() : void
        {
            var _loc_2:Sprite = null;
            Analytics.Track("Tab", "LifeCycle", "LifeCycle Enter");
            this.mouseChildren = false;
            this.mouseEnabled = false;
            this.mLegend = new Sprite();
            this.mAssetsDict = new Dictionary(true);
            this.mRenderTargetData = new BitmapData(Stage2D.stageWidth, Stage2D.stageHeight, true, 0);
            this.mRenderTargetDataReuse = new BitmapData(Stage2D.stageWidth, Stage2D.stageHeight, true, 0);
            this.mRenderTargetDataReuse.fillRect(this.mRenderTargetData.rect, 1476395008 + (16777215 & SkinManager.COLOR_LIFLECYCLE_REUSE));
            this.mRenderTargetDataCreate = new BitmapData(Stage2D.stageWidth, Stage2D.stageHeight, true, 0);
            this.mRenderTargetDataCreate.fillRect(this.mRenderTargetData.rect, 1476395008 + (16777215 & SkinManager.COLOR_LIFLECYCLE_CREATE));
            this.mRenderTargetDataRemoved = new BitmapData(Stage2D.stageWidth, Stage2D.stageHeight, true, 0);
            this.mRenderTargetDataRemoved.fillRect(this.mRenderTargetData.rect, 1476395008 + (16777215 & SkinManager.COLOR_LIFLECYCLE_REMOVED));
            this.mRenderTargetDataGC = new BitmapData(Stage2D.stageWidth, Stage2D.stageHeight, true, 0);
            this.mRenderTargetDataGC.fillRect(this.mRenderTargetData.rect, 1476395008 + (16777215 & SkinManager.COLOR_LIFLECYCLE_GC));
            this.mRenderTarget = new Bitmap();
            this.mRenderTarget.bitmapData = this.mRenderTargetData;
            this.addChild(this.mRenderTarget);
            Stage2D.addEventListener(Event.ADDED_TO_STAGE, this.OnAddedToStage, true);
            Stage2D.addEventListener(Event.REMOVED_FROM_STAGE, this.OnRemovedToStage, true);
            var _loc_1:* = Stage2D.stageWidth;
            _loc_2 = new Sprite();
            _loc_2.graphics.beginFill(SkinManager.COLOR_GLOBAL_BG, 0.3);
            _loc_2.graphics.drawRect(0, 0, _loc_1, 17);
            _loc_2.graphics.endFill();
            _loc_2.graphics.beginFill(SkinManager.COLOR_GLOBAL_LINE_DARK, 0.6);
            _loc_2.graphics.drawRect(0, 1, _loc_1, 1);
            _loc_2.graphics.endFill();
            _loc_2.graphics.beginFill(SkinManager.COLOR_GLOBAL_LINE, 0.8);
            _loc_2.graphics.drawRect(0, 0, _loc_1, 1);
            _loc_2.graphics.endFill();
            addChild(_loc_2);
            _loc_2.y = Stage2D.stageHeight - _loc_2.height;
            var _loc_3:* = new TextFormat("_sans", 11, SkinManager.COLOR_GLOBAL_TEXT, false);
            var _loc_4:* = new TextFormat("_sans", 9, SkinManager.COLOR_GLOBAL_TEXT, false);
            var _loc_5:* = new GlowFilter(SkinManager.COLOR_GLOBAL_TEXT_GLOW, 1, 2, 2, 3, 2, false, false);
            this.mInfos = new TextField();
            this.mInfos.autoSize = TextFieldAutoSize.LEFT;
            this.mInfos.defaultTextFormat = _loc_3;
            this.mInfos.selectable = false;
            this.mInfos.text = "";
            this.mInfos.filters = [_loc_5];
            this.mInfos.x = 2;
            addChild(this.mInfos);
            this.mInfos.y = Stage2D.stageHeight - _loc_2.height;
            this.mLegendTxt = [new TextField(), new TextField(), new TextField(), new TextField()];
            var _loc_6:int = 0;
            while (_loc_6 < 4)
            {
                
                this.mLegendTxt[_loc_6].autoSize = TextFieldAutoSize.LEFT;
                this.mLegendTxt[_loc_6].defaultTextFormat = _loc_4;
                this.mLegendTxt[_loc_6].selectable = false;
                this.mLegendTxt[_loc_6].filters = [_loc_5];
                this.mLegend.addChild(this.mLegendTxt[_loc_6]);
                this.mLegendTxt[_loc_6].y = -4;
                _loc_6 = _loc_6 + 1;
            }
            this.mLegend.y = Stage2D.stageHeight - 28;
            this.mLegend.graphics.clear();
            this.mLegend.graphics.beginFill(SkinManager.COLOR_LIFLECYCLE_CREATE, 1);
            this.mLegend.graphics.drawRect(3, 0, 10, 7);
            this.mLegend.graphics.endFill();
            this.mLegendTxt[0].x = 12;
            this.mLegendTxt[0].text = Localization.Lbl_DOLC_Create;
            this.mLegend.graphics.beginFill(SkinManager.COLOR_LIFLECYCLE_REUSE, 1);
            this.mLegend.graphics.drawRect(this.mLegendTxt[0].x + this.mLegendTxt[0].textWidth + 6, 0, 10, 7);
            this.mLegend.graphics.endFill();
            this.mLegendTxt[1].x = this.mLegendTxt[0].x + this.mLegendTxt[0].textWidth + 15;
            this.mLegendTxt[1].text = Localization.Lbl_DOLC_ReUse;
            this.mLegend.graphics.beginFill(SkinManager.COLOR_LIFLECYCLE_REMOVED, 1);
            this.mLegend.graphics.drawRect(this.mLegendTxt[1].x + this.mLegendTxt[1].textWidth + 6, 0, 10, 7);
            this.mLegend.graphics.endFill();
            this.mLegendTxt[2].x = this.mLegendTxt[1].x + this.mLegendTxt[1].textWidth + 15;
            this.mLegendTxt[2].text = Localization.Lbl_DOLC_Removed;
            this.mLegend.graphics.beginFill(SkinManager.COLOR_LIFLECYCLE_GC, 1);
            this.mLegend.graphics.drawRect(this.mLegendTxt[2].x + this.mLegendTxt[2].textWidth + 6, 0, 10, 7);
            this.mLegend.graphics.endFill();
            this.mLegendTxt[3].x = this.mLegendTxt[2].x + this.mLegendTxt[2].textWidth + 15;
            this.mLegendTxt[3].text = Localization.Lbl_DOLC_WaitingGC;
            addChild(this.mLegend);
            this.mLegend.alpha = 0.5;
            this.ParseStage(Stage2D);
            return;
        }// end function

        public function Dispose() : void
        {
            var _loc_1:* = undefined;
            Analytics.Track("Tab", "LifeCycle", "LifeCycle Exit", int((getTimer() - this.mEnterTime) / 1000));
            Stage2D.removeEventListener(Event.ADDED_TO_STAGE, this.OnAddedToStage, true);
            Stage2D.removeEventListener(Event.REMOVED_FROM_STAGE, this.OnRemovedToStage, true);
            if (this.mRenderTargetData)
            {
                this.mRenderTargetData.dispose();
            }
            if (this.mRenderTargetDataReuse)
            {
                this.mRenderTargetDataReuse.dispose();
            }
            if (this.mRenderTargetDataCreate)
            {
                this.mRenderTargetDataCreate.dispose();
            }
            if (this.mRenderTargetDataRemoved)
            {
                this.mRenderTargetDataRemoved.dispose();
            }
            if (this.mRenderTargetDataGC)
            {
                this.mRenderTargetDataGC.dispose();
            }
            this.mRenderTarget = null;
            for (_loc_1 in this.mAssetsDict)
            {
                
                delete this.mAssetsDict[_loc_1];
            }
            this.mAssetsDict = null;
            this.renderTarget1 = null;
            this.renderTarget2 = null;
            this.currentRenderTarget = null;
            this.mLegend = null;
            this.mInfos = null;
            this.mLegendTxt = null;
            this.mBiggerRect = null;
            this.mMinRect = null;
            this.pos = null;
            return;
        }// end function

        public function Update() : void
        {
            var _loc_2:Object = null;
            var _loc_3:String = null;
            if (getTimer() - this.mLastTick >= 1000)
            {
                this.mLastTick = getTimer();
                _loc_3 = Localization.Lbl_DOLC_DisplayObjectOnStage + "[ " + this.mDOTotal + " ]  " + Localization.Lbl_DOLC_AddedToStage + "[ " + this.mAddedLastSecond + " ]  " + Localization.Lbl_DOLC_RemovedFromStage + "[ " + this.mRemovedLastSecond + " ]  " + Localization.Lbl_DOLC_WaitingGC + "[ " + this.mDOToCollect + " ]";
                this.mInfos.text = _loc_3;
                this.mDOTotal = this.mDOTotal + this.mAddedLastSecond - this.mRemovedLastSecond;
                var _loc_4:int = 0;
                this.mAddedLastSecond = 0;
                this.mRemovedLastSecond = _loc_4;
            }
            this.mRenderTargetData.fillRect(this.mRenderTargetData.rect, (SkinManager.COLOR_GLOBAL_BG & 16777215) + 2281701376);
            var _loc_1:Rectangle = null;
            this.mDOToCollect = 0;
            for (_loc_2 in this.mAssetsDict)
            {
                
                if (_loc_2.stage != null)
                {
                }
                if (this.mAssetsDict[_loc_2] == false)
                {
                    var _loc_6:String = this;
                    var _loc_7:* = this.mDOToCollect + 1;
                    _loc_6.mDOToCollect = _loc_7;
                    _loc_1 = _loc_2.getRect(Stage2D);
                    this.pos.x = _loc_1.x;
                    this.pos.y = _loc_1.y;
                    this.mRenderTargetData.copyPixels(this.mRenderTargetDataGC, _loc_1, this.pos, null, null, true);
                }
            }
            return;
        }// end function

        private function OnAddedToStage(event:Event) : void
        {
            var _loc_2:* = event.target as DisplayObject;
            if (_loc_2 == Stage2D)
            {
                return;
            }
            if (_loc_2 == parent)
            {
                return;
            }
            var _loc_3:* = _loc_2.getRect(Stage2D);
            this.pos.x = _loc_3.x;
            this.pos.y = _loc_3.y;
            var _loc_4:Boolean = true;
            if (this.mAssetsDict[_loc_2] == true)
            {
                _loc_4 = false;
            }
            if (_loc_4)
            {
                var _loc_5:String = this;
                var _loc_6:* = this.mAddedLastSecond + 1;
                _loc_5.mAddedLastSecond = _loc_6;
                if (_loc_3.width < 8)
                {
                }
                if (_loc_3.width < 8)
                {
                    this.mMinRect.x = _loc_3.x;
                    this.mMinRect.y = _loc_3.y;
                    this.mRenderTargetData.copyPixels(this.mRenderTargetDataCreate, this.mMinRect, this.pos, null, null, true);
                }
                else
                {
                    this.mRenderTargetData.copyPixels(this.mRenderTargetDataCreate, _loc_3, this.pos, null, null, true);
                }
                this.mAssetsDict[_loc_2] = true;
            }
            else
            {
                if (_loc_3.width < 8)
                {
                }
                if (_loc_3.width < 8)
                {
                    this.mMinRect.x = _loc_3.x;
                    this.mMinRect.y = _loc_3.y;
                    this.mRenderTargetData.copyPixels(this.mRenderTargetDataReuse, this.mMinRect, this.pos, null, null, true);
                }
                else
                {
                    this.mRenderTargetData.copyPixels(this.mRenderTargetDataReuse, _loc_3, this.pos, null, null, true);
                }
            }
            return;
        }// end function

        private function OnRemovedToStage(event:Event) : void
        {
            var _loc_2:* = event.target as DisplayObject;
            if (_loc_2 == Stage2D)
            {
                return;
            }
            if (_loc_2 == parent)
            {
                return;
            }
            if (this.mAssetsDict[_loc_2] == true)
            {
                var _loc_4:String = this;
                var _loc_5:* = this.mRemovedLastSecond + 1;
                _loc_4.mRemovedLastSecond = _loc_5;
            }
            var _loc_3:* = _loc_2.getRect(Stage2D);
            this.pos.x = _loc_3.x;
            this.pos.y = _loc_3.y;
            this.mBiggerRect.x = _loc_3.x - 2;
            this.mBiggerRect.y = _loc_3.y - 2;
            this.mBiggerRect.width = _loc_3.width + 4;
            this.mBiggerRect.height = _loc_3.height + 4;
            this.mRenderTargetData.copyPixels(this.mRenderTargetDataRemoved, this.mBiggerRect, this.pos, null, null, true);
            this.mAssetsDict[_loc_2] = false;
            return;
        }// end function

        private function ParseStage(obj:DisplayObjectContainer) : void
        {
            if (obj != null)
            {
            }
            if (obj == parent)
            {
                return;
            }
            var _loc_2:int = 0;
            while (_loc_2 < obj.numChildren)
            {
                
                var _loc_3:String = this;
                var _loc_4:* = this.mDOTotal + 1;
                _loc_3.mDOTotal = _loc_4;
                this.ParseStage(obj.getChildAt(_loc_2) as DisplayObjectContainer);
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

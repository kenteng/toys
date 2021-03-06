﻿package com.qiyi.player.wonder.plugins.continueplay.view.parts
{
    import com.qiyi.player.core.model.def.*;
    import com.qiyi.player.wonder.common.localization.*;
    import com.qiyi.player.wonder.common.ui.*;
    import com.qiyi.player.wonder.common.utils.*;
    import com.qiyi.player.wonder.plugins.continueplay.model.*;
    import continueplay.*;
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;
    import gs.*;

    public class ContinueItemView extends Sprite
    {
        private const DEFAULT_COLOR:uint = 16777215;
        private const PLAYING_COLOR:uint = 9221390;
        private const TWEEN_TIME:Number = 0.3;
        private var _itewImage:ContinueItemImage;
        private var _itemUI:ContinueGridItem;
        private var _titleTF:TextField;
        private var _describeTF:TextField;
        private var _publishTimeTF:TextField;
        private var _describeCon:Sprite;
        private var _continueInfo:ContinueInfo;
        private var _isPlaying:Boolean = false;
        private var _adLabel:ADLabel;
        private var _itemUIHeight:Number = 0;
        public static const RECT_W:int = 115;
        public static const RECT_H:int = 66;

        public function ContinueItemView()
        {
            this._itemUI = new ContinueGridItem();
            this._itemUI.mouseChildren = false;
            this._itemUI.mouseEnabled = false;
            addChild(this._itemUI);
            this._titleTF = FastCreator.createLabel("", this.DEFAULT_COLOR);
            this._titleTF.mouseEnabled = false;
            this._titleTF.x = (this._itemUI.width - this._titleTF.width) / 2;
            this._titleTF.y = 46;
            addChild(this._titleTF);
            this._describeCon = new Sprite();
            this._describeCon.mouseChildren = false;
            this._describeCon.mouseEnabled = false;
            addChild(this._describeCon);
            this._describeTF = FastCreator.createLabel("", this.DEFAULT_COLOR);
            this._publishTimeTF = FastCreator.createLabel("", this.DEFAULT_COLOR);
            var _loc_1:Boolean = false;
            this._describeTF.mouseEnabled = false;
            this._publishTimeTF.mouseEnabled = _loc_1;
            var _loc_1:Boolean = true;
            this._publishTimeTF.wordWrap = true;
            this._describeTF.wordWrap = _loc_1;
            var _loc_1:Boolean = false;
            this._describeTF.multiline = false;
            this._publishTimeTF.multiline = _loc_1;
            var _loc_1:* = this._itemUI.width;
            this._describeTF.width = this._itemUI.width;
            this._publishTimeTF.width = _loc_1;
            this._describeTF.defaultTextFormat = new TextFormat(FastCreator.FONT_MSYH, 12, this.DEFAULT_COLOR, false, null, null, null, null, "center");
            this._publishTimeTF.defaultTextFormat = new TextFormat(FastCreator.FONT_MSYH, 12, this.DEFAULT_COLOR, false, null, null, null, null, "center");
            this._describeCon.addChild(this._describeTF);
            this._describeCon.addChild(this._publishTimeTF);
            this._itemUIHeight = this._itemUI.height;
            buttonMode = true;
            useHandCursor = true;
            addEventListener(MouseEvent.ROLL_OVER, this.onRollOver);
            addEventListener(MouseEvent.ROLL_OUT, this.onRollOut);
            return;
        }// end function

        public function get isPlaying() : Boolean
        {
            return this._isPlaying;
        }// end function

        public function set isPlaying(param1:Boolean) : void
        {
            if (this._isPlaying != param1)
            {
                this._isPlaying = param1;
                this.updateContent();
            }
            return;
        }// end function

        public function getContinueInfo() : ContinueInfo
        {
            return this._continueInfo;
        }// end function

        public function setContinueInfo(param1:ContinueInfo) : void
        {
            this._continueInfo = param1;
            if (this._itewImage)
            {
                removeChild(this._itewImage);
                this._itewImage = null;
                if (this._adLabel)
                {
                    removeChild(this._adLabel);
                    this._adLabel = null;
                }
            }
            if (this._continueInfo)
            {
                this._itewImage = ContinueItemImage.getImage(param1.imageURL);
                this._itewImage.x = -1;
                addChildAt(this._itewImage, 0);
                if (this._continueInfo.isAdVideo)
                {
                    this._adLabel = new ADLabel();
                    this._adLabel.x = this._itemUI.width - this._adLabel.width - 1;
                    this._adLabel.y = 1;
                    addChildAt(this._adLabel, 1);
                }
                this._describeCon.alpha = 0;
                this._itemUI.blackBar.y = 49;
                this._titleTF.y = 46;
                this.updateContent();
            }
            return;
        }// end function

        private function updateContent() : void
        {
            if (this._isPlaying)
            {
                this._itemUI.gotoAndStop(2);
                this._titleTF.textColor = this.PLAYING_COLOR;
                this._describeTF.textColor = this.PLAYING_COLOR;
                this._publishTimeTF.textColor = this.PLAYING_COLOR;
                this._titleTF.text = LocalizationManager.instance.getLanguageStringByName(LocalizationDef.CONTINUE_ITEM_VIEW_PLAYING);
            }
            else
            {
                this._itemUI.gotoAndStop(1);
                this._titleTF.textColor = this.DEFAULT_COLOR;
                this._describeTF.textColor = this.DEFAULT_COLOR;
                this._publishTimeTF.textColor = this.DEFAULT_COLOR;
                if (this._continueInfo)
                {
                    if (this._continueInfo.channelID == ChannelEnum.DOCUMENTARY.id)
                    {
                        if (this._continueInfo.curSet > 0)
                        {
                            this._titleTF.text = StringUtils.remainWord(StringUtils.substitute("[{0}]" + this._continueInfo.title, this._continueInfo.curSet), 9);
                            this._describeTF.text = StringUtils.remainWord(this._continueInfo.describe, 18);
                        }
                        else
                        {
                            this._titleTF.text = StringUtils.remainWord(this._continueInfo.title, 7);
                            this._describeTF.text = StringUtils.remainWord(this._continueInfo.describe, 18);
                        }
                    }
                    else if (this._continueInfo.curSet > 0)
                    {
                        this._titleTF.text = StringUtils.substitute(LocalizationManager.instance.getLanguageStringByName(LocalizationDef.CONTINUE_ITEM_VIEW_CUR_SET), this._continueInfo.curSet);
                        this._describeTF.text = StringUtils.remainWord(this._continueInfo.describe, 15);
                    }
                    else
                    {
                        this._titleTF.text = StringUtils.remainWord(this._continueInfo.title, 7);
                        this._describeTF.text = StringUtils.remainWord(this._continueInfo.title, 15);
                    }
                    this._publishTimeTF.text = this.checkVideoPublishTime(this._continueInfo.publishTime);
                }
            }
            this._titleTF.x = (this._itemUI.width - this._titleTF.width) / 2;
            if (this._publishTimeTF.text == "")
            {
                this._describeTF.height = this._describeTF.textHeight + 10;
                this._describeTF.y = (this._itemUIHeight - this._describeTF.height) / 2;
            }
            else
            {
                this._describeTF.height = this._describeTF.textHeight + 10;
                this._describeTF.y = (this._itemUIHeight - this._describeTF.height - 6) / 2;
                this._publishTimeTF.y = this._describeTF.y + this._describeTF.height - 4;
            }
            return;
        }// end function

        private function checkVideoPublishTime(param1:String) : String
        {
            var _loc_5:String = null;
            var _loc_6:Number = NaN;
            var _loc_7:Number = NaN;
            var _loc_8:Number = NaN;
            var _loc_2:* = new Date();
            var _loc_3:* = LocalizationManager.instance.getLanguageStringByName(LocalizationDef.CONTINUE_ITEM_VIEW_PT_DES1) + " ";
            var _loc_4:* = param1;
            if (_loc_4 == "")
            {
                _loc_3 = "";
            }
            else
            {
                while (_loc_4.indexOf("-") != -1)
                {
                    
                    _loc_4 = _loc_4.replace("-", "/");
                }
                _loc_5 = _loc_2.getFullYear() + "/" + (_loc_2.getMonth() + 1) + "/" + _loc_2.getDate();
                _loc_6 = Date.parse(_loc_2.getFullYear() + "/" + (_loc_2.getMonth() + 1) + "/" + _loc_2.getDate());
                _loc_7 = Date.parse(_loc_4);
                _loc_8 = 86400000;
                if (_loc_7 - _loc_6 >= 0)
                {
                    if (int(param1.split(" ")[1].split(":")[0]) > 0 || int(param1.split(" ")[1].split(":")[1]) > 0 || int(param1.split(" ")[1].split(":")[2]) > 0)
                    {
                        if (_loc_2.time - _loc_7 >= 0 && _loc_2.time - _loc_7 <= _loc_8 / 24)
                        {
                            _loc_3 = _loc_3 + (Math.floor((_loc_2.time - _loc_7) / 60000) + LocalizationManager.instance.getLanguageStringByName(LocalizationDef.CONTINUE_ITEM_VIEW_PT_DES2));
                        }
                        else if (_loc_2.time - _loc_7 > _loc_8 / 24)
                        {
                            _loc_3 = _loc_3 + (LocalizationManager.instance.getLanguageStringByName(LocalizationDef.CONTINUE_ITEM_VIEW_PT_TODAY) + param1.split(" ")[1].split(":")[0] + ":" + param1.split(" ")[1].split(":")[1]);
                        }
                        else
                        {
                            _loc_3 = _loc_3 + param1.split(" ")[0];
                        }
                    }
                    else
                    {
                        _loc_3 = _loc_3 + LocalizationManager.instance.getLanguageStringByName(LocalizationDef.CONTINUE_ITEM_VIEW_PT_TODAY);
                    }
                }
                else if (Math.abs(_loc_7 - _loc_6) <= _loc_8)
                {
                    _loc_3 = _loc_3 + LocalizationManager.instance.getLanguageStringByName(LocalizationDef.CONTINUE_ITEM_VIEW_PT_YESTERDAY);
                }
                else if (Math.abs(_loc_7 - _loc_6) > _loc_8 && Math.abs(_loc_7 - _loc_6) <= _loc_8 * 2)
                {
                    _loc_3 = _loc_3 + LocalizationManager.instance.getLanguageStringByName(LocalizationDef.CONTINUE_ITEM_VIEW_PT_BEFORE_YESTERDAY);
                }
                else
                {
                    _loc_3 = _loc_3 + param1.split(" ")[0];
                }
            }
            return _loc_3;
        }// end function

        private function onRollOver(event:MouseEvent) : void
        {
            if (this._isPlaying)
            {
                this._itemUI.gotoAndStop(4);
                this._itemUI.playingCover.alpha = 0;
                TweenLite.to(this._itemUI.playingCover, this.TWEEN_TIME, {alpha:1});
            }
            else
            {
                this._itemUI.gotoAndStop(3);
                this._itemUI.normalCover.alpha = 0;
                TweenLite.to(this._itemUI.normalCover, this.TWEEN_TIME, {alpha:1});
            }
            this._describeCon.alpha = 0;
            TweenLite.to(this._describeCon, this.TWEEN_TIME, {alpha:1});
            this._itemUI.blackBar.y = 49;
            TweenLite.to(this._itemUI.blackBar, this.TWEEN_TIME, {y:this._itemUI.blackBar.y + this._itemUI.blackBar.height});
            this._titleTF.y = 46;
            TweenLite.to(this._titleTF, this.TWEEN_TIME, {y:this._titleTF.y + this._titleTF.height});
            return;
        }// end function

        private function onRollOut(event:MouseEvent) : void
        {
            if (this._isPlaying)
            {
                this._itemUI.gotoAndStop(2);
            }
            else
            {
                this._itemUI.gotoAndStop(1);
            }
            TweenLite.to(this._describeCon, this.TWEEN_TIME, {alpha:0});
            TweenLite.to(this._itemUI.blackBar, this.TWEEN_TIME, {y:49});
            TweenLite.to(this._titleTF, this.TWEEN_TIME, {y:46});
            return;
        }// end function

    }
}

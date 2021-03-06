﻿package com.qiyi.player.wonder.plugins.tips.view
{
    import __AS3__.vec.*;
    import com.iqiyi.components.global.*;
    import com.qiyi.player.base.pub.*;
    import com.qiyi.player.base.utils.*;
    import com.qiyi.player.core.model.*;
    import com.qiyi.player.core.model.def.*;
    import com.qiyi.player.core.model.impls.*;
    import com.qiyi.player.core.model.impls.pub.*;
    import com.qiyi.player.user.*;
    import com.qiyi.player.wonder.body.*;
    import com.qiyi.player.wonder.body.model.*;
    import com.qiyi.player.wonder.common.config.*;
    import com.qiyi.player.wonder.common.pingback.*;
    import com.qiyi.player.wonder.common.sw.*;
    import com.qiyi.player.wonder.common.utils.*;
    import com.qiyi.player.wonder.common.vo.*;
    import com.qiyi.player.wonder.plugins.ad.*;
    import com.qiyi.player.wonder.plugins.ad.model.*;
    import com.qiyi.player.wonder.plugins.continueplay.*;
    import com.qiyi.player.wonder.plugins.continueplay.model.*;
    import com.qiyi.player.wonder.plugins.controllbar.*;
    import com.qiyi.player.wonder.plugins.controllbar.model.*;
    import com.qiyi.player.wonder.plugins.hint.*;
    import com.qiyi.player.wonder.plugins.tips.*;
    import com.qiyi.player.wonder.plugins.tips.model.*;
    import com.qiyi.player.wonder.plugins.tips.view.parts.*;
    import com.qiyi.player.wonder.plugins.topbar.*;
    import com.qiyi.player.wonder.plugins.topbar.model.*;
    import flash.external.*;
    import flash.net.*;
    import gs.*;
    import org.puremvc.as3.interfaces.*;
    import org.puremvc.as3.patterns.mediator.*;

    public class TipsViewMediator extends Mediator implements ISwitch
    {
        private var _tipsProxy:TipsProxy;
        private var _tipsView:TipsView;
        private var _isTyrWatchTipShown:Boolean;
        private var _curFocusTip:FocusTip;
        public static const NAME:String = "com.qiyi.player.wonder.plugins.tips.view.TipsViewMediator";

        public function TipsViewMediator(param1:TipsView)
        {
            super(NAME, param1);
            this._tipsView = param1;
            return;
        }// end function

        override public function onRegister() : void
        {
            super.onRegister();
            SwitchManager.getInstance().register(this);
            this._tipsProxy = facade.retrieveProxy(TipsProxy.NAME) as TipsProxy;
            this._tipsView.addEventListener(TipsEvent.Evt_Open, this.onTipsViewOpen);
            this._tipsView.addEventListener(TipsEvent.Evt_Close, this.onTipsViewClose);
            TipManager.setDataUrl(FlashVarConfig.tipDataURL);
            TipManager.initialize(this._tipsView.tipBar);
            TipManager.addEventListener(TipEvent.All, this.onTipEvent);
            TipManager.setSubscribed(false);
            return;
        }// end function

        override public function listNotificationInterests() : Array
        {
            return [TipsDef.NOTIFIC_ADD_STATUS, TipsDef.NOTIFIC_REMOVE_STATUS, BodyDef.NOTIFIC_RESIZE, BodyDef.NOTIFIC_CHECK_USER_COMPLETE, BodyDef.NOTIFIC_JS_CALL_SUBSCRIBE, BodyDef.NOTIFIC_PLAYER_ADD_STATUS, BodyDef.NOTIFIC_PLAYER_SWITCH_PRE_ACTOR, BodyDef.NOTIFIC_PLAYER_RUNNING, BodyDef.NOTIFIC_PLAYER_SKIP_TITLE, BodyDef.NOTIFIC_PLAYER_PREPARE_PLAY_END, BodyDef.NOTIFIC_PLAYER_DEFINITION_SWITCHED, BodyDef.NOTIFIC_PLAYER_AUDIOTRACK_SWITCHED, BodyDef.NOTIFIC_PLAYER_STUCK, BodyDef.NOTIFIC_PLAYER_START_FROM_HISTORY, BodyDef.NOTIFIC_PLAYER_REPLAYED, BodyDef.NOTIFIC_JS_CALL_SET_SMALL_WINDOW_MODE, ADDef.NOTIFIC_ADD_STATUS, ADDef.NOTIFIC_AD_UNLOADED, ContinuePlayDef.NOTIFIC_SWITCH_VIDEO_TYPE_CHANGED, TipsDef.NOTIFIC_REQUEST_SHOW_TIP, TipsDef.NOTIFIC_REQUEST_HIDE_TIP, TipsDef.NOTIFIC_UPDATE_TIP_ATTR, ControllBarDef.NOTIFIC_ADD_STATUS, ControllBarDef.NOTIFIC_REMOVE_STATUS, HintDef.NOTIFIC_ADD_STATUS];
        }// end function

        override public function handleNotification(param1:INotification) : void
        {
            var _loc_2:Object = null;
            var _loc_5:uint = 0;
            super.handleNotification(param1);
            _loc_2 = param1.getBody();
            var _loc_3:* = param1.getName();
            var _loc_4:* = param1.getType();
            switch(_loc_3)
            {
                case TipsDef.NOTIFIC_ADD_STATUS:
                {
                    this._tipsView.onAddStatus(int(_loc_2));
                    break;
                }
                case TipsDef.NOTIFIC_REMOVE_STATUS:
                {
                    this._tipsView.onRemoveStatus(int(_loc_2));
                    break;
                }
                case BodyDef.NOTIFIC_RESIZE:
                {
                    this._tipsView.onResize(_loc_2.w, _loc_2.h);
                    break;
                }
                case BodyDef.NOTIFIC_CHECK_USER_COMPLETE:
                {
                    this.onCheckUserComplete();
                    break;
                }
                case BodyDef.NOTIFIC_JS_CALL_SUBSCRIBE:
                {
                    TipManager.setCanSubscribe(_loc_2.canSubscribe);
                    break;
                }
                case BodyDef.NOTIFIC_PLAYER_ADD_STATUS:
                {
                    this.onPlayerStatusChanged(int(_loc_2), true, _loc_4);
                    break;
                }
                case BodyDef.NOTIFIC_PLAYER_SWITCH_PRE_ACTOR:
                {
                    this.onPlayerSwitchPreActor();
                    break;
                }
                case BodyDef.NOTIFIC_PLAYER_RUNNING:
                {
                    this.onPlayerRunning(_loc_2.currentTime, _loc_2.bufferTime, _loc_2.duration, _loc_2.playingDuration);
                    break;
                }
                case BodyDef.NOTIFIC_PLAYER_SKIP_TITLE:
                {
                    if (_loc_4 == BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_CUR)
                    {
                        PingBack.getInstance().userActionPing(PingBackDef.PASS_HEAD_TILE);
                        this.showTip(TipsDef.TIP_ID_SKIPPED_HEAD);
                    }
                    break;
                }
                case BodyDef.NOTIFIC_PLAYER_PREPARE_PLAY_END:
                {
                    if (_loc_4 == BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_CUR)
                    {
                        this.onPlayerPreparePlayEnd();
                    }
                    break;
                }
                case BodyDef.NOTIFIC_PLAYER_DEFINITION_SWITCHED:
                {
                    if (_loc_4 == BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_CUR)
                    {
                        this.onPlayerDefinitionSwitched(int(_loc_2));
                    }
                    break;
                }
                case BodyDef.NOTIFIC_PLAYER_AUDIOTRACK_SWITCHED:
                {
                    if (_loc_4 == BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_CUR)
                    {
                        this.onPlayerAudioTrackSwitched(int(_loc_2));
                    }
                    break;
                }
                case BodyDef.NOTIFIC_PLAYER_STUCK:
                {
                    if (_loc_4 == BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_CUR)
                    {
                        this.onPlayerStuck();
                    }
                    break;
                }
                case BodyDef.NOTIFIC_PLAYER_START_FROM_HISTORY:
                {
                    if (_loc_4 == BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_CUR)
                    {
                        this.onPlayerStartFromHistory(int(_loc_2));
                    }
                    break;
                }
                case BodyDef.NOTIFIC_PLAYER_REPLAYED:
                {
                    if (_loc_4 == BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_CUR)
                    {
                        if (this.checkShowStatus())
                        {
                            this._tipsProxy.addStatus(TipsDef.STATUS_OPEN);
                        }
                    }
                    break;
                }
                case BodyDef.NOTIFIC_JS_CALL_SET_SMALL_WINDOW_MODE:
                {
                    if (_loc_2)
                    {
                        this._tipsProxy.removeStatus(TipsDef.STATUS_OPEN);
                    }
                    else if (this.checkShowStatus())
                    {
                        this._tipsProxy.addStatus(TipsDef.STATUS_OPEN);
                    }
                    break;
                }
                case ADDef.NOTIFIC_ADD_STATUS:
                {
                    this.onADStatusChanged(int(_loc_2), true);
                    break;
                }
                case ADDef.NOTIFIC_AD_UNLOADED:
                {
                    TipManager.setADState(false);
                    break;
                }
                case ContinuePlayDef.NOTIFIC_SWITCH_VIDEO_TYPE_CHANGED:
                {
                    break;
                }
                case TipsDef.NOTIFIC_REQUEST_SHOW_TIP:
                {
                    _loc_5 = this.showTip(String(_loc_2));
                    break;
                }
                case TipsDef.NOTIFIC_REQUEST_HIDE_TIP:
                {
                    this.hideTip();
                    break;
                }
                case TipsDef.NOTIFIC_UPDATE_TIP_ATTR:
                {
                    this.updateTipAttr(_loc_2.attr, _loc_2.value);
                    break;
                }
                case ControllBarDef.NOTIFIC_ADD_STATUS:
                {
                    this.onControllBarStatusChanged(int(_loc_2), true);
                    break;
                }
                case ControllBarDef.NOTIFIC_REMOVE_STATUS:
                {
                    this.onControllBarStatusChanged(int(_loc_2), false);
                    break;
                }
                case HintDef.NOTIFIC_ADD_STATUS:
                {
                    if (int(_loc_2) == HintDef.STATUS_OPEN)
                    {
                        if (TipManager.isShow(TipsDef.TIP_ID_TRY_WATCH) || TipManager.isShow(TipsDef.TIP_ID_TRY_WATCH_HAVE_TICKET) || TipManager.isShow(TipsDef.TIP_ID_TRY_WATCH_NOT_HAVE_TICKET))
                        {
                            this.hideTip(TipsDef.TIP_ID_TRY_WATCH);
                            this.hideTip(TipsDef.TIP_ID_TRY_WATCH_HAVE_TICKET);
                            this.hideTip(TipsDef.TIP_ID_TRY_WATCH_NOT_HAVE_TICKET);
                        }
                        else if (TipManager.isShow(TipsDef.TIP_ID_TRY_WATCH_TOTAL))
                        {
                            this.hideTip(TipsDef.TIP_ID_TRY_WATCH_TOTAL);
                        }
                    }
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        public function getSwitchID() : Vector.<int>
        {
            return this.Vector.<int>([SwitchDef.ID_SHOW_TIPS]);
        }// end function

        public function onSwitchStatusChanged(param1:int, param2:Boolean) : void
        {
            switch(param1)
            {
                case SwitchDef.ID_SHOW_TIPS:
                {
                    if (param2)
                    {
                        if (this.checkShowStatus())
                        {
                            this._tipsProxy.addStatus(TipsDef.STATUS_OPEN);
                        }
                    }
                    else
                    {
                        this.hideTip();
                        this._tipsProxy.removeStatus(TipsDef.STATUS_OPEN);
                    }
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        private function showTip(param1:String) : int
        {
            return TipManager.showTip(param1);
        }// end function

        private function hideTip(param1:String = "") : void
        {
            TipManager.hideTip(param1);
            return;
        }// end function

        private function updateTipAttr(param1:String, param2:String) : void
        {
            TipManager.updateAttribute(param1, param2);
            return;
        }// end function

        private function onTipsViewOpen(event:TipsEvent) : void
        {
            if (!this._tipsProxy.hasStatus(TipsDef.STATUS_OPEN))
            {
                this._tipsProxy.addStatus(TipsDef.STATUS_OPEN);
            }
            return;
        }// end function

        private function onTipsViewClose(event:TipsEvent) : void
        {
            if (this._tipsProxy.hasStatus(TipsDef.STATUS_OPEN))
            {
                this._tipsProxy.removeStatus(TipsDef.STATUS_OPEN);
            }
            return;
        }// end function

        private function onCheckUserComplete() : void
        {
            var _loc_1:* = facade.retrieveProxy(UserProxy.NAME) as UserProxy;
            TipManager.setIsMember(_loc_1.userLevel != UserDef.USER_LEVEL_NORMAL);
            TipManager.setIsLogin(_loc_1.isLogin);
            TipManager.setPassportId(_loc_1.passportID);
            var _loc_2:* = new UserInfoVO();
            _loc_2.isLogin = _loc_1.isLogin;
            _loc_2.passportID = _loc_1.passportID;
            _loc_2.userID = _loc_1.userID;
            _loc_2.userName = _loc_1.userName;
            _loc_2.userLevel = _loc_1.userLevel;
            _loc_2.userType = _loc_1.userType;
            this._tipsView.onUserInfoChanged(_loc_2);
            this.updateTipAttr(TipsDef.TIP_ATTR_NAME_LOGIN, _loc_1.isLogin ? ("") : ("登录提示"));
            return;
        }// end function

        private function onPlayerStatusChanged(param1:int, param2:Boolean, param3:String) : void
        {
            if (param3 != BodyDef.PLAYER_ACTOR_NOTIFIC_TYPE_CUR)
            {
                return;
            }
            var _loc_4:PlayerProxy = null;
            switch(param1)
            {
                case BodyDef.PLAYER_STATUS_ALREADY_READY:
                case BodyDef.PLAYER_STATUS_ALREADY_INFO_READY:
                {
                    if (param2)
                    {
                        _loc_4 = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
                        this._tipsProxy.clearHotChatTipsTimes();
                        if (_loc_4.curActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_READY) && _loc_4.curActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_INFO_READY))
                        {
                            if (this.checkShowStatus())
                            {
                                this._tipsProxy.addStatus(TipsDef.STATUS_OPEN);
                            }
                            this.onReady();
                        }
                    }
                    break;
                }
                case BodyDef.PLAYER_STATUS_PLAYING:
                {
                    _loc_4 = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
                    if (_loc_4.curActor.isTryWatch)
                    {
                        if (!this._isTyrWatchTipShown)
                        {
                            if (_loc_4.curActor.tryWatchType == TryWatchEnum.TOTAL)
                            {
                                this.showTip(TipsDef.TIP_ID_TRY_WATCH_TOTAL);
                            }
                            else if (_loc_4.curActor.authenticationTipType == TipsDef.AUTH_TIP_TYPE_NOT_TICKET)
                            {
                                this.showTip(TipsDef.TIP_ID_TRY_WATCH_NOT_HAVE_TICKET);
                            }
                            else if (_loc_4.curActor.authenticationTipType == TipsDef.AUTH_TIP_TYPE_TICKET)
                            {
                                this.showTip(TipsDef.TIP_ID_TRY_WATCH_HAVE_TICKET);
                            }
                            else
                            {
                                this.showTip(TipsDef.TIP_ID_TRY_WATCH);
                            }
                            this._isTyrWatchTipShown = true;
                        }
                    }
                    else if (TipManager.isShow(TipsDef.TIP_ID_TRY_WATCH) || TipManager.isShow(TipsDef.TIP_ID_TRY_WATCH_HAVE_TICKET) || TipManager.isShow(TipsDef.TIP_ID_TRY_WATCH_NOT_HAVE_TICKET))
                    {
                        this.hideTip(TipsDef.TIP_ID_TRY_WATCH);
                        this.hideTip(TipsDef.TIP_ID_TRY_WATCH_HAVE_TICKET);
                        this.hideTip(TipsDef.TIP_ID_TRY_WATCH_NOT_HAVE_TICKET);
                    }
                    else if (TipManager.isShow(TipsDef.TIP_ID_TRY_WATCH_TOTAL))
                    {
                        this.hideTip(TipsDef.TIP_ID_TRY_WATCH_TOTAL);
                    }
                    break;
                }
                case BodyDef.PLAYER_STATUS_STOPPING:
                {
                    break;
                }
                case BodyDef.PLAYER_STATUS_ALREADY_LOAD_MOVIE:
                {
                    if (param2)
                    {
                        this.hideTip();
                        this._tipsProxy.removeStatus(TipsDef.STATUS_OPEN);
                        TweenLite.killTweensOf(this.onPlayerDefinitionSwitchComplete);
                        TweenLite.killTweensOf(this.onPlayerAudioTrackSwitchComplete);
                    }
                    break;
                }
                case BodyDef.PLAYER_STATUS_STOPED:
                case BodyDef.PLAYER_STATUS_FAILED:
                {
                    if (param2)
                    {
                        this.hideTip();
                        this._tipsProxy.removeStatus(TipsDef.STATUS_OPEN);
                        TweenLite.killTweensOf(this.onPlayerDefinitionSwitchComplete);
                        TweenLite.killTweensOf(this.onPlayerAudioTrackSwitchComplete);
                    }
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        private function onADStatusChanged(param1:int, param2:Boolean) : void
        {
            switch(param1)
            {
                case ADDef.STATUS_LOADING:
                case ADDef.STATUS_PLAYING:
                {
                    if (param2)
                    {
                        TipManager.setADState(true);
                    }
                    break;
                }
                case ADDef.STATUS_PLAY_END:
                {
                    if (param2)
                    {
                        TipManager.setADState(false);
                    }
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        private function onControllBarStatusChanged(param1:int, param2:Boolean) : void
        {
            switch(param1)
            {
                case ControllBarDef.STATUS_SHOW:
                {
                    this.checkTipsLocation();
                    break;
                }
                case ControllBarDef.STATUS_SEEK_BAR_SHOW:
                {
                    this.checkTipsLocation();
                    break;
                }
                case ControllBarDef.STATUS_SEEK_BAR_THICK:
                {
                    this.checkTipsLocation();
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        private function onPlayerSwitchPreActor() : void
        {
            this.hideTip();
            this._tipsProxy.removeStatus(TipsDef.STATUS_OPEN);
            this._tipsProxy.clearHotChatTipsTimes();
            TweenLite.killTweensOf(this.onPlayerDefinitionSwitchComplete);
            TweenLite.killTweensOf(this.onPlayerAudioTrackSwitchComplete);
            var _loc_1:* = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
            if (_loc_1.curActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_READY) && _loc_1.curActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_INFO_READY))
            {
                this._isTyrWatchTipShown = false;
                if (this.checkShowStatus())
                {
                    this._tipsProxy.addStatus(TipsDef.STATUS_OPEN);
                }
                this.onReady();
            }
            return;
        }// end function

        private function onReady() : void
        {
            var _loc_4:String = null;
            var _loc_5:Date = null;
            var _loc_6:String = null;
            var _loc_1:* = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
            var _loc_2:* = _loc_1.curActor.movieModel;
            var _loc_3:* = _loc_1.curActor.movieInfo;
            TipManager.setPlayerModel(_loc_1.curActor.corePlayer);
            TipManager.setStartTime(Math.floor(_loc_1.curActor.strategy.getStartTime() / 1000));
            TipManager.setTotalTime(Math.floor(_loc_2.duration / 1000));
            if (Settings.instance.skipTrailer && _loc_2.trailerTime > 0)
            {
                TipManager.setEndTime(Math.floor(_loc_2.trailerTime / 1000));
            }
            else
            {
                TipManager.setEndTime(Math.floor(_loc_2.duration / 1000));
            }
            if (_loc_3.infoJSON.hasOwnProperty("etm"))
            {
                _loc_4 = _loc_3.infoJSON["etm"];
                _loc_5 = new Date();
                _loc_5.fullYear = Number(_loc_4.substr(0, 4));
                _loc_5.month = Number(_loc_4.substr(4, 2)) - 1;
                _loc_5.date = Number(_loc_4.substr(6, 2));
                _loc_6 = _loc_5.fullYear + "年" + (_loc_5.month + 1) + "月" + _loc_5.date + "日";
                this.updateTipAttr(TipsDef.TIP_ATTR_NAME_VIDEO_NAME, _loc_3.albumName);
                this.updateTipAttr(TipsDef.TIP_ATTR_NAME_EXPIRED_TIME, _loc_6);
            }
            this._isTyrWatchTipShown = false;
            return;
        }// end function

        private function checkShowStatus() : Boolean
        {
            var _loc_1:* = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
            if (SwitchManager.getInstance().getStatus(SwitchDef.ID_SHOW_TIPS) && _loc_1.curActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_READY) && _loc_1.curActor.hasStatus(BodyDef.PLAYER_STATUS_ALREADY_INFO_READY) && !_loc_1.curActor.smallWindowMode)
            {
                return true;
            }
            return false;
        }// end function

        private function onPlayerPreparePlayEnd() : void
        {
            var _loc_4:ContinuePlayProxy = null;
            var _loc_5:String = null;
            var _loc_6:String = null;
            var _loc_7:ContinueInfo = null;
            var _loc_1:* = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
            var _loc_2:* = facade.retrieveProxy(ControllBarProxy.NAME) as ControllBarProxy;
            var _loc_3:* = _loc_1.curActor.movieModel;
            if (_loc_3 != null && _loc_1.curActor.currentTime < _loc_3.trailerTime && _loc_3.trailerTime > 0 && Settings.instance.skipTrailer)
            {
                this.showTip(TipsDef.TIP_ID_SKIPPING_TAIL);
            }
            else
            {
                _loc_4 = facade.retrieveProxy(ContinuePlayProxy.NAME) as ContinuePlayProxy;
                if (!_loc_4.isCyclePlay)
                {
                    if (_loc_4.isJSContinue)
                    {
                        if (_loc_4.JSContinueTitle)
                        {
                            this.updateTipAttr(TipsDef.TIP_ATTR_NAME_DESCRIPTION, _loc_4.JSContinueTitle);
                        }
                        else
                        {
                            this.updateTipAttr(TipsDef.TIP_ATTR_NAME_DESCRIPTION, "下一个节目");
                        }
                        if (!_loc_2.hasStatus(ControllBarDef.STATUS_FILTER_OPEN) && _loc_1.curActor.movieModel.duration >= TipsDef.DEF_VIDEO_CURRENTTIME_MIN)
                        {
                            this.showTip(TipsDef.TIP_ID_NEXT_VIDEO);
                        }
                    }
                    else
                    {
                        _loc_5 = _loc_1.curActor.loadMovieParams.tvid;
                        _loc_6 = _loc_1.curActor.loadMovieParams.vid;
                        _loc_7 = _loc_4.findNextContinueInfo(_loc_5, _loc_6);
                        if (_loc_4.isContinue && _loc_7)
                        {
                            if (_loc_7.title)
                            {
                                this.updateTipAttr(TipsDef.TIP_ATTR_NAME_DESCRIPTION, _loc_7.title);
                            }
                            else
                            {
                                this.updateTipAttr(TipsDef.TIP_ATTR_NAME_DESCRIPTION, "下一个节目");
                            }
                            if (!_loc_2.hasStatus(ControllBarDef.STATUS_FILTER_OPEN) && _loc_1.curActor.movieModel.duration >= TipsDef.DEF_VIDEO_CURRENTTIME_MIN)
                            {
                                this.showTip(TipsDef.TIP_ID_NEXT_VIDEO);
                            }
                        }
                    }
                }
            }
            return;
        }// end function

        private function onPlayerDefinitionSwitched(param1:int) : void
        {
            if (!Settings.instance.autoMatchRate || FlashVarConfig.owner == FlashVarConfig.OWNER_CLIENT)
            {
                if (Settings.instance.definition == DefinitionEnum.FOUR_K || Settings.instance.definition == DefinitionEnum.FULL_HD || Settings.instance.definition == DefinitionEnum.SUPER_HIGH)
                {
                    this.updateTipAttr(TipsDef.TIP_ATTR_NAME_DEFINITION, ChineseNameOfLangAudioDef.getDefinitionName(Settings.instance.definition));
                    this.showTip(TipsDef.TIP_ID_SWAPPING_DEFINITION_DEF);
                }
                else
                {
                    this.showTip(TipsDef.TIP_ID_SWAPPING_DEF);
                }
                TweenLite.killTweensOf(this.onPlayerDefinitionSwitchComplete);
                TweenLite.delayedCall(param1 / 1000, this.onPlayerDefinitionSwitchComplete);
            }
            return;
        }// end function

        private function onPlayerDefinitionSwitchComplete() : void
        {
            var _loc_2:EnumItem = null;
            var _loc_3:TopBarProxy = null;
            var _loc_1:* = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
            if (_loc_1.curActor.movieModel)
            {
                _loc_2 = _loc_1.curActor.movieModel.curDefinitionInfo.type;
                if (_loc_2 == DefinitionEnum.LIMIT)
                {
                    _loc_3 = facade.retrieveProxy(TopBarProxy.NAME) as TopBarProxy;
                    if (GlobalStage.isFullScreen() && _loc_3.scaleValue != TopBarDef.SCALE_VALUE_75)
                    {
                        if (TipManager.isShow(TipsDef.TIP_ID_SWAPPING_DEF))
                        {
                            this.hideTip(TipsDef.TIP_ID_SWAPPING_DEF);
                        }
                        this.showTip(TipsDef.TIP_ID_CHANG_SIZE_75);
                    }
                    else
                    {
                        this.updateTipAttr(TipsDef.TIP_ATTR_NAME_DEFINITION, ChineseNameOfLangAudioDef.getDefinitionName(DefinitionEnum.LIMIT));
                        this.showTip(TipsDef.TIP_ID_SWAPPED_DEF);
                    }
                }
                else if (_loc_2 == DefinitionEnum.FOUR_K || _loc_2 == DefinitionEnum.FULL_HD || _loc_2 == DefinitionEnum.SUPER_HIGH)
                {
                    this.updateTipAttr(TipsDef.TIP_ATTR_NAME_DEFINITION, ChineseNameOfLangAudioDef.getDefinitionName(_loc_2));
                    this.showTip(TipsDef.TIP_ID_SWAPPED_DEFINITION_DEF);
                }
                else
                {
                    this.updateTipAttr(TipsDef.TIP_ATTR_NAME_DEFINITION, ChineseNameOfLangAudioDef.getDefinitionName(_loc_2));
                    this.showTip(TipsDef.TIP_ID_SWAPPED_DEF);
                }
            }
            return;
        }// end function

        private function onPlayerAudioTrackSwitched(param1:int) : void
        {
            this.showTip(TipsDef.TIP_ID_SWAPPING_TRACK);
            TweenLite.killTweensOf(this.onPlayerAudioTrackSwitchComplete);
            TweenLite.delayedCall(param1 / 1000, this.onPlayerAudioTrackSwitchComplete);
            return;
        }// end function

        private function onPlayerAudioTrackSwitchComplete() : void
        {
            var _loc_1:* = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
            var _loc_2:* = _loc_1.curActor.movieModel.curAudioTrackInfo.com.qiyi.player.core.model:IAudioTrackInfo::type;
            this.updateTipAttr(TipsDef.TIP_ATTR_NAME_AUDIO_TRACK, ChineseNameOfLangAudioDef.getAudioName(_loc_2));
            this.showTip(TipsDef.TIP_ID_SWAPPED_TRACK);
            return;
        }// end function

        private function onPlayerStuck() : void
        {
            var _loc_1:PlayerProxy = null;
            var _loc_2:IAudioTrackInfo = null;
            var _loc_3:int = 0;
            var _loc_4:int = 0;
            var _loc_5:EnumItem = null;
            if (this._tipsProxy.lagDownDefinition(TipsDef.LAG_TIME_SWAP_TIP_QD) && !Settings.instance.autoMatchRate)
            {
                _loc_1 = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
                if (_loc_1.curActor.movieModel.curDefinitionInfo.type != DefinitionEnum.LIMIT)
                {
                    _loc_2 = _loc_1.curActor.movieModel.curAudioTrackInfo;
                    _loc_3 = _loc_2.definitionCount;
                    _loc_4 = 0;
                    while (_loc_4 < _loc_3)
                    {
                        
                        _loc_5 = _loc_2.findDefinitionInfoAt(_loc_4).type;
                        if (_loc_5 == DefinitionEnum.LIMIT)
                        {
                            this.showTip(TipsDef.TIP_ID_SWAP_TIP_QD);
                            break;
                        }
                        _loc_4++;
                    }
                }
            }
            return;
        }// end function

        private function onPlayerStartFromHistory(param1:int) : void
        {
            var _loc_3:String = null;
            var _loc_2:* = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
            if (param1 > TipsDef.HISTORY_MIN_TIME && _loc_2.curActor.loadMovieType == BodyDef.LOAD_MOVIE_TYPE_ORIGINAL)
            {
                _loc_3 = Strings.formatAsTimeCode(param1 / ConstUtils.S_2_MS, _loc_2.curActor.movieModel.duration >= ConstUtils.H_2_MS);
                this.updateTipAttr(TipsDef.TIP_ATTR_NAME_HISTORY_TIME, _loc_3);
                this.showTip(TipsDef.TIP_ID_HISTORY_TIME);
            }
            return;
        }// end function

        private function onPlayerRunning(param1:int, param2:int, param3:int, param4:int) : void
        {
            TipManager.setCurrTime(param1 / 1000, Statistics.instance.playDuration / 1000);
            return;
        }// end function

        private function onTipEvent(event:TipEvent) : void
        {
            switch(event.type)
            {
                case TipEvent.ASEvent:
                {
                    this.doASEvent(event.eventName);
                    break;
                }
                case TipEvent.JSEvent:
                {
                    try
                    {
                        ExternalInterface.call(event.eventName, event.eventParams);
                    }
                    catch (error:Error)
                    {
                    }
                    break;
                }
                case TipEvent.LinkEvent:
                {
                    this.doLinkEvent(event.tipId, event.url);
                    break;
                }
                case TipEvent.Close:
                {
                    break;
                }
                case TipEvent.Error:
                {
                    break;
                }
                case TipEvent.Show:
                {
                    if (event.tipId == TipsDef.TIP_ID_TRY_WATCH || event.tipId == TipsDef.TIP_ID_TRY_WATCH_NOT_HAVE_TICKET || event.tipId == TipsDef.TIP_ID_TRY_WATCH_HAVE_TICKET || event.tipId == TipsDef.TIP_ID_TRY_WATCH_TOTAL)
                    {
                        this._tipsView.setCloseBtnVisible(false);
                    }
                    else
                    {
                        this._tipsView.setCloseBtnVisible(true);
                    }
                    this.doShowEvent(event.tipId);
                    break;
                }
                case TipEvent.Hide:
                {
                    this.onTipHided();
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        private function doASEvent(param1:String) : void
        {
            var _loc_5:String = null;
            var _loc_6:String = null;
            var _loc_7:String = null;
            var _loc_2:* = facade.retrieveProxy(ADProxy.NAME) as ADProxy;
            if (_loc_2.hasStatus(ADDef.STATUS_LOADING) || _loc_2.hasStatus(ADDef.STATUS_PLAYING) || _loc_2.hasStatus(ADDef.STATUS_PAUSED))
            {
                return;
            }
            var _loc_3:* = facade.retrieveProxy(JavascriptAPIProxy.NAME) as JavascriptAPIProxy;
            var _loc_4:* = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
            switch(param1)
            {
                case TipsDef.AS_EVENT_NAME_SKIP_SET:
                {
                    Settings.instance.skipTrailer = false;
                    Settings.instance.skipTitle = false;
                    break;
                }
                case TipsDef.AS_EVENT_NAME_WATCH_START:
                {
                    sendNotification(HintDef.NOTIFIC_HINT_CHECK, true);
                    break;
                }
                case TipsDef.AS_EVENT_NAME_SWAPTOQD:
                {
                    Settings.instance.autoMatchRate = false;
                    Settings.instance.definition = DefinitionEnum.LIMIT;
                    break;
                }
                case TipsDef.AS_EVENT_NAME_SCREEN_DEFAULT:
                {
                    sendNotification(TopBarDef.NOTIFIC_REQUEST_SCALE, TopBarDef.SCALE_VALUE_100);
                    break;
                }
                case TipsDef.AS_EVENT_NAME_SWITCHOVER_NEXT:
                {
                    _loc_3.callJsRequestJSSendPB(BodyDef.REQUEST_JS_PB_TYPE_DEMANDS);
                    sendNotification(ContinuePlayDef.NOTIFIC_REQUEST_NEXT_VIDEO);
                    break;
                }
                case TipsDef.AS_EVENT_NAME_TRY_WATCH_USE_TICKET:
                case TipsDef.AS_EVENT_NAME_TRY_WATCH_BUY:
                {
                    GlobalStage.setNormalScreen();
                    _loc_5 = "";
                    _loc_6 = "";
                    _loc_7 = "";
                    if (_loc_4.curActor.loadMovieParams)
                    {
                        _loc_5 = _loc_4.curActor.loadMovieParams.tvid;
                        _loc_6 = _loc_4.curActor.loadMovieParams.vid;
                        _loc_7 = _loc_4.curActor.movieModel ? (_loc_4.curActor.movieModel.albumId) : ("");
                    }
                    _loc_3.callJsRecharge(_loc_5, _loc_6, _loc_7, "Q00304", 1);
                    sendNotification(BodyDef.NOTIFIC_PLAYER_PAUSE);
                    break;
                }
                case TipsDef.AS_EVENT_NAME_LOGIN:
                {
                    GlobalStage.setNormalScreen();
                    _loc_3.requestLogin();
                    break;
                }
                default:
                {
                    break;
                }
            }
            this.hideTip();
            return;
        }// end function

        private function onTipHided() : void
        {
            var _loc_1:* = facade.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
            if (_loc_1.curActor.isTryWatch)
            {
                this._tipsProxy.addStatus(TipsDef.STATUS_OPEN);
                if (_loc_1.curActor.tryWatchType == TryWatchEnum.TOTAL)
                {
                    this.showTip(TipsDef.TIP_ID_TRY_WATCH_TOTAL);
                }
                else if (_loc_1.curActor.authenticationTipType == TipsDef.AUTH_TIP_TYPE_NOT_TICKET)
                {
                    this.showTip(TipsDef.TIP_ID_TRY_WATCH_NOT_HAVE_TICKET);
                }
                else if (_loc_1.curActor.authenticationTipType == TipsDef.AUTH_TIP_TYPE_TICKET)
                {
                    this.showTip(TipsDef.TIP_ID_TRY_WATCH_HAVE_TICKET);
                }
                else
                {
                    this.showTip(TipsDef.TIP_ID_TRY_WATCH);
                }
            }
            return;
        }// end function

        private function checkTipsLocation() : void
        {
            var _loc_1:* = facade.retrieveProxy(ControllBarProxy.NAME) as ControllBarProxy;
            if (_loc_1.hasStatus(ControllBarDef.STATUS_SHOW))
            {
                if (_loc_1.hasStatus(ControllBarDef.STATUS_SEEK_BAR_SHOW))
                {
                    if (_loc_1.hasStatus(ControllBarDef.STATUS_SEEK_BAR_THICK))
                    {
                        this._tipsView.setGap(TipsDef.STAGE_GAP_1);
                    }
                    else
                    {
                        this._tipsView.setGap(TipsDef.STAGE_GAP_2);
                    }
                }
                else
                {
                    this._tipsView.setGap(TipsDef.STAGE_GAP_4);
                }
            }
            else
            {
                this._tipsView.setGap(TipsDef.STAGE_GAP_3);
            }
            return;
        }// end function

        private function doLinkEvent(param1:String, param2:String) : void
        {
            GlobalStage.setNormalScreen();
            switch(param1)
            {
                case TipsDef.TIP_ID_AD_NOTICE_BUY_VIP_TIPS:
                {
                    navigateToURL(new URLRequest(param2), "_blank");
                    this.hideTip();
                    return;
                }
                default:
                {
                    break;
                }
            }
            navigateToURL(new URLRequest(param2), "_self");
            this.hideTip();
            return;
        }// end function

        private function doShowEvent(param1:String) : void
        {
            switch(param1)
            {
                case TipsDef.TIP_ID_AD_NOTICE_BUY_VIP_TIPS:
                {
                    PingBack.getInstance().playerActionPing(PingBackDef.SHOW_BUY_VIP_TIPS);
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

    }
}

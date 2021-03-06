﻿package com.qiyi.player.wonder.plugins.ad.model
{
    import com.qiyi.player.base.logging.*;
    import com.qiyi.player.core.model.impls.pub.*;
    import com.qiyi.player.wonder.common.config.*;
    import com.qiyi.player.wonder.common.status.*;
    import com.qiyi.player.wonder.plugins.ad.*;
    import org.puremvc.as3.patterns.proxy.*;

    public class ADProxy extends Proxy implements IStatus
    {
        private var _status:Status;
        private var _curPlayCount:int;
        private var _curAdContextPlayDuration:int;
        private var _curAdContext15PlayDuration:int;
        private var _prePlayCount:int;
        private var _preAdContextPlayDuration:int;
        private var _preAdContext15PlayDuration:int;
        private var _log:ILogger;
        private var _mute:Boolean;
        private var _switchVideoType:int = 0;
        private var _cupId:String;
        private var _blocked:Boolean = false;
        private var _viewPoints:Array;
        public static const NAME:String = "com.qiyi.player.wonder.plugins.ad.model.ADProxy";

        public function ADProxy(param1:Object = null)
        {
            this._log = Log.getLogger("com.qiyi.player.wonder.plugins.ad.model.ADProxy");
            this._cupId = FlashVarConfig.cupId;
            super(NAME, param1);
            this._status = new Status(ADDef.STATUS_BEGIN, ADDef.STATUS_END);
            this._mute = Settings.instance.mute;
            this._status.addStatus(ADDef.STATUS_VIEW_INIT);
            return;
        }// end function

        public function get status() : Status
        {
            return this._status;
        }// end function

        public function set curPlayCount(param1:int) : void
        {
            this._curPlayCount = param1;
            return;
        }// end function

        public function get curPlayCount() : int
        {
            return this._curPlayCount;
        }// end function

        public function set prePlayCount(param1:int) : void
        {
            this._prePlayCount = param1;
            return;
        }// end function

        public function get prePlayCount() : int
        {
            return this._prePlayCount;
        }// end function

        public function set curAdContextPlayDuration(param1:int) : void
        {
            this._curAdContextPlayDuration = param1;
            return;
        }// end function

        public function get curAdContextPlayDuration() : int
        {
            return this._curAdContextPlayDuration;
        }// end function

        public function set preAdContextPlayDuration(param1:int) : void
        {
            this._preAdContextPlayDuration = param1;
            return;
        }// end function

        public function get preAdContextPlayDuration() : int
        {
            return this._preAdContextPlayDuration;
        }// end function

        public function set curAdContext15PlayDuration(param1:int) : void
        {
            this._curAdContext15PlayDuration = param1;
            return;
        }// end function

        public function get curAdContext15PlayDuration() : int
        {
            return this._curAdContext15PlayDuration;
        }// end function

        public function set preAdContext15PlayDuration(param1:int) : void
        {
            this._preAdContext15PlayDuration = param1;
            return;
        }// end function

        public function get preAdContext15PlayDuration() : int
        {
            return this._preAdContext15PlayDuration;
        }// end function

        public function set mute(param1:Boolean) : void
        {
            this._mute = param1;
            return;
        }// end function

        public function get mute() : Boolean
        {
            return this._mute;
        }// end function

        public function set switchVideoType(param1:int) : void
        {
            this._switchVideoType = param1;
            return;
        }// end function

        public function get switchVideoType() : int
        {
            return this._switchVideoType;
        }// end function

        public function set cupId(param1:String) : void
        {
            if (param1 == null || param1 == "")
            {
                this._cupId = FlashVarConfig.cupId;
            }
            else
            {
                this._cupId = param1;
            }
            return;
        }// end function

        public function get cupId() : String
        {
            return this._cupId;
        }// end function

        public function set blocked(param1:Boolean) : void
        {
            this._blocked = param1;
            return;
        }// end function

        public function get blocked() : Boolean
        {
            return this._blocked;
        }// end function

        public function get viewPoints() : Array
        {
            return this._viewPoints;
        }// end function

        public function setADViewPoints(param1:Array = null) : void
        {
            this._viewPoints = param1;
            return;
        }// end function

        public function clearADViewPoints() : void
        {
            this._viewPoints = null;
            return;
        }// end function

        public function addStatus(param1:int, param2:Boolean = true) : void
        {
            if (param1 >= ADDef.STATUS_BEGIN && param1 < ADDef.STATUS_END && !this._status.hasStatus(param1))
            {
                if (param1 == ADDef.STATUS_OPEN && !this._status.hasStatus(ADDef.STATUS_VIEW_INIT))
                {
                    this._status.addStatus(ADDef.STATUS_VIEW_INIT);
                    sendNotification(ADDef.NOTIFIC_ADD_STATUS, ADDef.STATUS_VIEW_INIT);
                }
                switch(param1)
                {
                    case ADDef.STATUS_LOADING:
                    {
                        this._status.removeStatus(ADDef.STATUS_PLAYING);
                        this._status.removeStatus(ADDef.STATUS_PAUSED);
                        this._status.removeStatus(ADDef.STATUS_PLAY_END);
                        break;
                    }
                    case ADDef.STATUS_PLAYING:
                    {
                        this._status.removeStatus(ADDef.STATUS_LOADING);
                        this._status.removeStatus(ADDef.STATUS_PAUSED);
                        this._status.removeStatus(ADDef.STATUS_PLAY_END);
                        break;
                    }
                    case ADDef.STATUS_PAUSED:
                    {
                        this._status.removeStatus(ADDef.STATUS_LOADING);
                        this._status.removeStatus(ADDef.STATUS_PLAYING);
                        this._status.removeStatus(ADDef.STATUS_PLAY_END);
                        break;
                    }
                    case ADDef.STATUS_PLAY_END:
                    {
                        this._status.removeStatus(ADDef.STATUS_LOADING);
                        this._status.removeStatus(ADDef.STATUS_PLAYING);
                        this._status.removeStatus(ADDef.STATUS_PAUSED);
                        break;
                    }
                    case ADDef.STATUS_PRE_LOADING:
                    {
                        this._status.removeStatus(ADDef.STATUS_PRE_SUCCESS);
                        this._status.removeStatus(ADDef.STATUS_PRE_FAILED);
                        break;
                    }
                    case ADDef.STATUS_PRE_SUCCESS:
                    {
                        this._status.removeStatus(ADDef.STATUS_PRE_LOADING);
                        this._status.removeStatus(ADDef.STATUS_PRE_FAILED);
                        break;
                    }
                    case ADDef.STATUS_PRE_FAILED:
                    {
                        this._status.removeStatus(ADDef.STATUS_PRE_LOADING);
                        this._status.removeStatus(ADDef.STATUS_PRE_SUCCESS);
                        break;
                    }
                    default:
                    {
                        break;
                    }
                }
                this._log.info("ADProxy add status:" + param1);
                this._status.addStatus(param1);
                if (param2)
                {
                    sendNotification(ADDef.NOTIFIC_ADD_STATUS, param1);
                }
            }
            return;
        }// end function

        public function removeStatus(param1:int, param2:Boolean = true) : void
        {
            if (param1 >= ADDef.STATUS_BEGIN && param1 < ADDef.STATUS_END && this._status.hasStatus(param1))
            {
                switch(param1)
                {
                    case ADDef.STATUS_LOADING:
                    {
                        break;
                    }
                    case ADDef.STATUS_PLAYING:
                    {
                        break;
                    }
                    case ADDef.STATUS_PAUSED:
                    {
                        break;
                    }
                    case ADDef.STATUS_PLAY_END:
                    {
                        break;
                    }
                    case ADDef.STATUS_PRE_LOADING:
                    {
                        break;
                    }
                    case ADDef.STATUS_PRE_SUCCESS:
                    {
                        break;
                    }
                    case ADDef.STATUS_PRE_FAILED:
                    {
                        break;
                    }
                    default:
                    {
                        break;
                    }
                }
                this._log.info("ADProxy remove status:" + param1);
                this._status.removeStatus(param1);
                if (param2)
                {
                    sendNotification(ADDef.NOTIFIC_REMOVE_STATUS, param1);
                }
            }
            return;
        }// end function

        public function hasStatus(param1:int) : Boolean
        {
            return this._status.hasStatus(param1);
        }// end function

    }
}

﻿package com.qiyi.player.wonder.plugins.setting.model
{
    import com.qiyi.player.core.model.impls.pub.*;
    import com.qiyi.player.wonder.common.status.*;
    import com.qiyi.player.wonder.plugins.setting.*;
    import org.puremvc.as3.patterns.proxy.*;

    public class SettingProxy extends Proxy implements IStatus
    {
        private var _status:Status;
        public static const NAME:String = "com.qiyi.player.wonder.plugins.setting.model.SettingProxy";

        public function SettingProxy(param1:Object = null)
        {
            super(NAME, param1);
            this._status = new Status(SettingDef.STATUS_BEGIN, SettingDef.STATUS_END);
            Settings.instance.subtitleSize = SettingDef.FONT_SIZE_LIST[SettingDef.DEFAULT_SUBTITLE_SIZE_INDEX];
            Settings.instance.subtitlePos = SettingDef.DEFAULT_SUBTITLE_POS;
            return;
        }// end function

        public function get status() : Status
        {
            return this._status;
        }// end function

        public function addStatus(param1:int, param2:Boolean = true) : void
        {
            if (param1 >= SettingDef.STATUS_BEGIN && param1 < SettingDef.STATUS_END && !this._status.hasStatus(param1))
            {
                if (param1 == SettingDef.STATUS_OPEN && !this._status.hasStatus(SettingDef.STATUS_VIEW_INIT))
                {
                    this._status.addStatus(SettingDef.STATUS_VIEW_INIT);
                    sendNotification(SettingDef.NOTIFIC_ADD_STATUS, SettingDef.STATUS_VIEW_INIT);
                }
                if (param1 == SettingDef.STATUS_DEFINITION_OPEN && !this._status.hasStatus(SettingDef.STATUS_DEFINITION_VIEW_INIT))
                {
                    this._status.addStatus(SettingDef.STATUS_DEFINITION_VIEW_INIT);
                    sendNotification(SettingDef.NOTIFIC_ADD_STATUS, SettingDef.STATUS_DEFINITION_VIEW_INIT);
                }
                if (param1 == SettingDef.STATUS_FILTER_OPEN && !this._status.hasStatus(SettingDef.STATUS_FILTER_VIEW_INIT))
                {
                    this._status.addStatus(SettingDef.STATUS_FILTER_VIEW_INIT);
                    sendNotification(SettingDef.NOTIFIC_ADD_STATUS, SettingDef.STATUS_FILTER_VIEW_INIT);
                }
                this._status.addStatus(param1);
                if (param2)
                {
                    sendNotification(SettingDef.NOTIFIC_ADD_STATUS, param1);
                }
            }
            return;
        }// end function

        public function removeStatus(param1:int, param2:Boolean = true) : void
        {
            if (param1 >= SettingDef.STATUS_BEGIN && param1 < SettingDef.STATUS_END && this._status.hasStatus(param1))
            {
                this._status.removeStatus(param1);
                if (param2)
                {
                    sendNotification(SettingDef.NOTIFIC_REMOVE_STATUS, param1);
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

﻿package com.qiyi.player.wonder.plugins.continueplay.view
{
    import com.qiyi.player.wonder.common.event.*;

    public class ContinuePlayEvent extends CommonEvent
    {
        public static const Evt_Open:String = "evtContinuePlayOpen";
        public static const Evt_Close:String = "evtContinuePlayClose";
        public static const Evt_ListItemClick:String = "evtListItemClick";
        public static const Evt_ArrowClick:String = "evtArrowClick";
        public static const Evt_SwitchPageTriggerRequest:String = "evtSwitchPageTriggerRequest";
        public static const Evt_SwitchOverPage:String = "evtSwitchOverPage";
        public static const Evt_SwitchOverPageDone:String = "evtSwitchOverPageDone";

        public function ContinuePlayEvent(param1:String, param2:Object = null)
        {
            super(param1, param2);
            return;
        }// end function

    }
}

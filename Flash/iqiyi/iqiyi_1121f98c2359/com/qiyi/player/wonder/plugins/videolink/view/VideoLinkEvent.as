﻿package com.qiyi.player.wonder.plugins.videolink.view
{
    import com.qiyi.player.wonder.common.event.*;

    public class VideoLinkEvent extends CommonEvent
    {
        public static const Evt_Open:String = "evtVideoLinkOpen";
        public static const Evt_Close:String = "evtVideoLinkClose";
        public static const Evt_BtnAndIconClick:String = "evtVideoLinkBtnAndIconClick";

        public function VideoLinkEvent(param1:String, param2:Object = null)
        {
            super(param1, param2);
            return;
        }// end function

    }
}
